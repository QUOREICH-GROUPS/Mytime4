import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/queue_provider.dart';
import '../widgets/transaction_type_card.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  final String serviceName;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Sélectionnez le type de transaction',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TransactionTypeCard(
            title: 'Dépôt',
            icon: Icons.arrow_upward,
            onTap: () => _getTicket(ref, 'deposit'),
          ),
          const SizedBox(height: 12),
          TransactionTypeCard(
            title: 'Retrait',
            icon: Icons.arrow_downward,
            onTap: () => _getTicket(ref, 'withdrawal'),
          ),
          const SizedBox(height: 12),
          TransactionTypeCard(
            title: 'Consultation',
            icon: Icons.search,
            onTap: () => _getTicket(ref, 'inquiry'),
          ),
        ],
      ),
    );
  }

  Future<void> _getTicket(WidgetRef ref, String transactionType) async {
    try {
      await ref.read(activeTicketProvider.notifier).getNewTicket(
        serviceId,
        transactionType,
      );
      // Navigate to ticket screen
    } catch (e) {
      // Handle error
    }
  }
}