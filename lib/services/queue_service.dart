import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/queue_ticket.dart';

final queueServiceProvider = Provider((ref) => QueueService());

class QueueService {
  final Map<String, int> _serviceQueues = {};
  final Random _random = Random();

  String _generateTicketId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) => chars[_random.nextInt(chars.length)]).join();
  }

  Future<QueueTicket> getTicket(String serviceId, String transactionType) async {
    // Get current queue length for the service
    final currentQueue = _serviceQueues[serviceId] ?? 0;
    _serviceQueues[serviceId] = currentQueue + 1;

    // Generate random position within reasonable bounds
    final position = currentQueue + 1;
    final estimatedTimePerPerson = _getEstimatedTimePerPerson(transactionType);
    
    return QueueTicket(
      id: _generateTicketId(),
      serviceId: serviceId,
      transactionType: transactionType,
      position: position,
      estimatedWaitTime: Duration(minutes: position * estimatedTimePerPerson),
      timestamp: DateTime.now(),
    );
  }

  int _getEstimatedTimePerPerson(String transactionType) {
    switch (transactionType.toLowerCase()) {
      case 'deposit':
        return 5;
      case 'withdrawal':
        return 4;
      case 'inquiry':
        return 3;
      default:
        return 5;
    }
  }

  Future<int> getCurrentPosition(String ticketId) async {
    // Simulate queue movement
    return max(1, _random.nextInt(5));
  }

  Future<void> cancelTicket(String ticketId, String serviceId) async {
    final currentQueue = _serviceQueues[serviceId] ?? 0;
    if (currentQueue > 0) {
      _serviceQueues[serviceId] = currentQueue - 1;
    }
  }

  Future<void> syncTicket(String ticketId, Map<String, dynamic> data) async {
    // Implement API sync logic here
  }

  Future<void> updateTicket(String ticketId, Map<String, dynamic> data) async {
    // Implement API update logic here
  }
}