import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset('assets/images/splash_logo.svg', width: 100, height: 100),
                    Text('OrdaCost', style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              Text(
                'Bienvenido al Sistema de Costeo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Gestiona órdenes de producción y calcula costos con precisión',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildNavigationCard(
                      context,
                      title: 'Órdenes',
                      subtitle: 'Gestionar órdenes de producción',
                      icon: Icons.inventory_2,
                      onTap: () => context.go('/orders'),
                    ),
                    _buildNavigationCard(
                      context,
                      title: 'Parámetros CIF',
                      subtitle: 'Configurar costos indirectos',
                      icon: Icons.settings,
                      onTap: () => context.go('/params'),
                    ),
                    _buildNavigationCard(
                      context,
                      title: 'Resultados',
                      subtitle: 'Ver cálculos y totales',
                      icon: Icons.analytics,
                      onTap: () => context.go('/results'),
                    ),
                    _buildNavigationCard(
                      context,
                      title: 'Ayuda',
                      subtitle: 'Guía de uso del sistema',
                      icon: Icons.help_outline,
                      onTap: () => _showHelpDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda'),
        content: const Text(
          'OrdaCost te permite:\n\n'
          '• Gestionar órdenes de producción\n'
          '• Configurar parámetros de CIF\n'
          '• Calcular costos automáticamente\n'
          '• Ver reportes y totales\n\n'
          'Usa la navegación inferior para acceder a cada sección.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
