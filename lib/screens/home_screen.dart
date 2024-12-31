import 'package:flutter/material.dart';
import '../widgets/service_card.dart';
import '../widgets/current_queue_status.dart';
import '../widgets/theme_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTimes'),
        actions: [
          const ThemeSwitch(),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue sur MyTimes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const CurrentQueueStatus(),
              const SizedBox(height: 24),
              const Text(
                'Services disponibles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  ServiceCard(
                    icon: Icons.account_balance,
                    title: 'Banque',
                    color: Colors.blue,
                    serviceId: 'bank',
                  ),
                  ServiceCard(
                    icon: Icons.restaurant,
                    title: 'Restaurant',
                    color: Colors.orange,
                    serviceId: 'restaurant',
                  ),
                  ServiceCard(
                    icon: Icons.electric_bolt,
                    title: 'SONABEL',
                    color: Colors.green,
                    serviceId: 'sonabel',
                  ),
                  ServiceCard(
                    icon: Icons.water_drop,
                    title: 'ONEA',
                    color: Colors.purple,
                    serviceId: 'onea',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}