import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ord_cost/core/utils/formatters.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';
import 'package:ord_cost/features/costeo/presentation/providers.dart';

class ParamsPage extends ConsumerWidget {
  const ParamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paramsAsync = ref.watch(paramsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parámetros CIF'),
        centerTitle: true,
      ),
      body: paramsAsync.when(
        data: (params) => _buildParamsForm(context, ref, params),
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
                'Error al cargar parámetros',
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

  Widget _buildParamsForm(BuildContext context, WidgetRef ref, PeriodParams params) {
    final formKey = GlobalKey<FormState>();
    final tasaController = TextEditingController(
      text: (params.tasaCIFFactor * 100).toString(),
    );
    final miController = TextEditingController(
      text: params.materialesIndirectos.toString(),
    );
    final moiController = TextEditingController(
      text: params.manoObraIndirecta.toString(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuración de CIF',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configure los parámetros para el cálculo de Costos Indirectos de Fabricación',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: tasaController,
              decoration: const InputDecoration(
                labelText: 'Tasa CIF (%)',
                helperText: 'Porcentaje aplicado sobre MOD',
                prefixIcon: Icon(Icons.percent),
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese la tasa CIF';
                }
                final num = Formatters.parseNum(value);
                if (num == null || num <= 0) {
                  return 'Tasa debe ser mayor a 0';
                }
                return null;
              },
              onChanged: (value) {
                final num = Formatters.parseNum(value);
                if (num != null && num > 0) {
                  ref.read(paramsProvider.notifier).setTasaPercent(num);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: miController,
              decoration: const InputDecoration(
                labelText: 'Materiales Indirectos (Q)',
                helperText: 'Costo total de materiales indirectos del período',
                prefixIcon: Icon(Icons.inventory_2),
                prefixText: 'Q ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el costo de MI';
                }
                final num = Formatters.parseNum(value);
                if (num == null || num < 0) {
                  return 'Valor debe ser mayor o igual a 0';
                }
                return null;
              },
              onChanged: (value) {
                final num = Formatters.parseNum(value);
                if (num != null && num >= 0) {
                  ref.read(paramsProvider.notifier).setMI(num);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: moiController,
              decoration: const InputDecoration(
                labelText: 'Mano de Obra Indirecta (Q)',
                helperText: 'Costo total de mano de obra indirecta del período',
                prefixIcon: Icon(Icons.engineering),
                prefixText: 'Q ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el costo de MOI';
                }
                final num = Formatters.parseNum(value);
                if (num == null || num < 0) {
                  return 'Valor debe ser mayor o igual a 0';
                }
                return null;
              },
              onChanged: (value) {
                final num = Formatters.parseNum(value);
                if (num != null && num >= 0) {
                  ref.read(paramsProvider.notifier).setMOI(num);
                }
              },
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• La tasa CIF se aplica sobre el costo de Mano de Obra Directa\n'
                      '• Los valores se guardan automáticamente al modificar\n'
                      '• CIF Real = Materiales Indirectos + Mano de Obra Indirecta\n'
                      '• Otros Gastos Indirectos = MOD × Tasa CIF (calculado automáticamente)\n'
                      '• Factor MI = Materiales Indirectos / Total MP\n'
                      '• Factor MOI = Mano de Obra Indirecta / Total MOD',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
