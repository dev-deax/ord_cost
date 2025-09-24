import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ord_cost/core/utils/formatters.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/presentation/providers.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Producción'),
        actions: [
          IconButton(
            onPressed: () => _showAddOrderDialog(context, ref),
            icon: const Icon(Icons.add),
            tooltip: 'Agregar Orden',
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty ? _buildEmptyState(context) : _buildOrdersList(context, ref, orders),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar órdenes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay órdenes registradas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primera orden de producción',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showAddOrderDialog(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Orden'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, WidgetRef ref, List<OrderInput> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Orden #${order.orden}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    _buildStatusChip(context, order.status),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        'MP',
                        Formatters.formatCurrency(order.mp),
                        Icons.inventory,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        'MOD',
                        Formatters.formatCurrency(order.mod),
                        Icons.engineering,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        'Unidades',
                        order.unidades.toString(),
                        Icons.production_quantity_limits,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => _showEditOrderDialog(context, ref, index, order),
                        child: const Text('Editar'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showDeleteConfirmation(context, ref, index),
                        child: const Text('Eliminar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, OrderStatus status) {
    return Chip(
      label: Text(
        status == OrderStatus.terminada ? 'Terminada' : 'En Proceso',
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: status == OrderStatus.terminada ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
    );
  }

  void _showAddOrderDialog(BuildContext context, WidgetRef? ref) {
    _showOrderDialog(context, ref, null, null);
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, int index) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Orden'),
        content: const Text('¿Está seguro de que desea eliminar esta orden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(ordersProvider.notifier).removeOrder(index);
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditOrderDialog(BuildContext context, WidgetRef ref, int index, OrderInput order) {
    _showOrderDialog(context, ref, index, order);
  }

  void _showOrderDialog(BuildContext context, WidgetRef? ref, int? index, OrderInput? order) {
    final formKey = GlobalKey<FormState>();
    final ordenController = TextEditingController(text: order?.orden.toString() ?? '');
    final mpController = TextEditingController(text: order?.mp.toString() ?? '');
    final modController = TextEditingController(text: order?.mod.toString() ?? '');
    final unidadesController = TextEditingController(text: order?.unidades.toString() ?? '');
    var selectedStatus = order?.status ?? OrderStatus.enProceso;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(index != null ? 'Editar Orden' : 'Nueva Orden'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: ordenController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Orden',
                      prefixIcon: Icon(Icons.tag),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el número de orden';
                      }
                      if (Formatters.parseInt(value) == null) {
                        return 'Número inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: mpController,
                    decoration: const InputDecoration(
                      labelText: 'Materia Prima (Q)',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el costo de MP';
                      }
                      if (Formatters.parseNum(value) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: modController,
                    decoration: const InputDecoration(
                      labelText: 'Mano de Obra Directa (Q)',
                      prefixIcon: Icon(Icons.engineering),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el costo de MOD';
                      }
                      if (Formatters.parseNum(value) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: unidadesController,
                    decoration: const InputDecoration(
                      labelText: 'Unidades',
                      prefixIcon: Icon(Icons.production_quantity_limits),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la cantidad de unidades';
                      }
                      if (Formatters.parseInt(value) == null) {
                        return 'Cantidad inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<OrderStatus>(
                    segments: const [
                      ButtonSegment(
                        value: OrderStatus.enProceso,
                        label: Text('En Proceso'),
                        icon: Icon(Icons.hourglass_empty),
                      ),
                      ButtonSegment(
                        value: OrderStatus.terminada,
                        label: Text('Terminada'),
                        icon: Icon(Icons.check_circle),
                      ),
                    ],
                    selected: {selectedStatus},
                    onSelectionChanged: (Set<OrderStatus> selection) {
                      setState(() {
                        selectedStatus = selection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate() && ref != null) {
                  final newOrder = OrderInput(
                    orden: Formatters.parseInt(ordenController.text)!,
                    mp: Formatters.parseNum(mpController.text)!,
                    mod: Formatters.parseNum(modController.text)!,
                    unidades: Formatters.parseInt(unidadesController.text)!,
                    status: selectedStatus,
                  );

                  if (index != null) {
                    ref.read(ordersProvider.notifier).updateOrder(index, newOrder);
                  } else {
                    ref.read(ordersProvider.notifier).addOrder(newOrder);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(index != null ? 'Actualizar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
