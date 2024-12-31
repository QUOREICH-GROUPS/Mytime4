import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/queue_ticket.dart';
import '../services/queue_service.dart';

final activeTicketProvider = StateNotifierProvider<ActiveTicketNotifier, QueueTicket?>((ref) {
  return ActiveTicketNotifier(ref.watch(queueServiceProvider));
});

class ActiveTicketNotifier extends StateNotifier<QueueTicket?> {
  final QueueService _queueService;
  
  ActiveTicketNotifier(this._queueService) : super(null);

  Future<void> getNewTicket(String serviceId, String transactionType) async {
    state = await _queueService.getTicket(serviceId, transactionType);
  }

  Future<void> updatePosition() async {
    if (state != null) {
      final newPosition = await _queueService.getCurrentPosition(state!.id);
      state = QueueTicket(
        id: state!.id,
        serviceId: state!.serviceId,
        transactionType: state!.transactionType,
        position: newPosition,
        estimatedWaitTime: Duration(minutes: newPosition * 3),
        timestamp: state!.timestamp,
      );
    }
  }

  void clearTicket() {
    state = null;
  }
}