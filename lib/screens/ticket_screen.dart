import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/queue_provider.dart';
import '../widgets/ticket_info_card.dart';
import '../widgets/estimated_time_display.dart';

class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key});

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _startUpdateTimer();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => ref.read(activeTicketProvider.notifier).updatePosition(),
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticket = ref.watch(activeTicketProvider);

    if (ticket == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre ticket'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TicketInfoCard(ticket: ticket),
          const SizedBox(height: 24),
          EstimatedTimeDisplay(
            position: ticket.position,
            estimatedTime: ticket.estimatedWaitTime,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(activeTicketProvider.notifier).clearTicket();
              Navigator.of(context).pop();
            },
            child: const Text('Annuler le ticket'),
          ),
        ],
      ),
    );
  }
}