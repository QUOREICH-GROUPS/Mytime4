import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/database_service.dart';
import '../services/queue_service.dart';

class SyncService {
  final DatabaseService _databaseService;
  final QueueService _queueService;
  Timer? _syncTimer;

  SyncService(this._databaseService, this._queueService);

  void startSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) => syncData());
    
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncData();
      }
    });
  }

  Future<void> syncData() async {
    final pendingItems = await _databaseService.getPendingSyncItems();
    
    for (final item in pendingItems) {
      try {
        if (item['action'] == 'create') {
          await _queueService.syncTicket(item['ticketId'], json.decode(item['data']));
        } else if (item['action'] == 'update') {
          await _queueService.updateTicket(item['ticketId'], json.decode(item['data']));
        }
        
        await _databaseService.markAsSynced(item['ticketId']);
      } catch (e) {
        print('Sync failed for ticket ${item['ticketId']}: $e');
      }
    }
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}