import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/queue_ticket.dart';

class DatabaseService {
  static Database? _database;
  static const String ticketsTable = 'tickets';
  static const String syncTable = 'sync_queue';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mytimes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $ticketsTable(
            id TEXT PRIMARY KEY,
            serviceId TEXT NOT NULL,
            transactionType TEXT NOT NULL,
            position INTEGER NOT NULL,
            estimatedWaitTime INTEGER NOT NULL,
            timestamp TEXT NOT NULL,
            status TEXT NOT NULL,
            synced INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE $syncTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ticketId TEXT NOT NULL,
            action TEXT NOT NULL,
            data TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> saveTicket(QueueTicket ticket) async {
    final db = await database;
    await db.insert(
      ticketsTable,
      {
        'id': ticket.id,
        'serviceId': ticket.serviceId,
        'transactionType': ticket.transactionType,
        'position': ticket.position,
        'estimatedWaitTime': ticket.estimatedWaitTime.inMinutes,
        'timestamp': ticket.timestamp.toIso8601String(),
        'status': ticket.status,
        'synced': 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _addToSyncQueue(ticket.id, 'create', ticket.toJson());
  }

  Future<void> updateTicketStatus(String ticketId, String status) async {
    final db = await database;
    await db.update(
      ticketsTable,
      {'status': status, 'synced': 0},
      where: 'id = ?',
      whereArgs: [ticketId],
    );

    await _addToSyncQueue(ticketId, 'update', {'status': status});
  }

  Future<void> _addToSyncQueue(String ticketId, String action, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      syncTable,
      {
        'ticketId': ticketId,
        'action': action,
        'data': json.encode(data),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<QueueTicket>> getTicketHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      ticketsTable,
      orderBy: 'timestamp DESC',
      limit: 50,
    );

    return List.generate(maps.length, (i) {
      return QueueTicket.fromJson(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query(syncTable, orderBy: 'timestamp ASC');
  }

  Future<void> markAsSynced(String ticketId) async {
    final db = await database;
    await db.update(
      ticketsTable,
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [ticketId],
    );
    
    await db.delete(
      syncTable,
      where: 'ticketId = ?',
      whereArgs: [ticketId],
    );
  }
}