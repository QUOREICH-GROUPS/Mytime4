import 'package:flutter/material.dart';
import '../models/queue_ticket.dart';
import 'package:intl/intl.dart';

class TicketInfoCard extends StatelessWidget {
  final QueueTicket ticket;

  const TicketInfoCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket #${ticket.id.substring(0, 6)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(ticket.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow('Service', ticket.serviceId),
            const SizedBox(height: 8),
            _buildInfoRow('Type', ticket.transactionType),
            const SizedBox(height: 8),
            _buildInfoRow('Position', ticket.position.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}