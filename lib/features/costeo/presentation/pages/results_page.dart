import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ord_cost/core/utils/formatters.dart';
import 'package:ord_cost/features/costeo/domain/entities/calculo_detallado.dart';
import 'package:ord_cost/features/costeo/presentation/providers.dart';

class ResultsPage extends ConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculoDetalladoAsync = ref.watch(calculoDetalladoProvider);
    final factoresAsync = ref.watch(factoresProvider);
    final totalesDetalladosAsync = ref.watch(totalesDetalladosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Detallados'),
        centerTitle: true,
      ),
      body: calculoDetalladoAsync.when(
        data: (calculos) => factoresAsync.when(
          data: (factores) => totalesDetalladosAsync.when(
            data: (totales) => _buildDetailedResultsContent(context, calculos, factores, totales),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(context, error),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(context, error),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildCIFTable(BuildContext context, List<CalculoDetallado> calculos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cálculo de CIF (Costos Indirectos de Fabricación)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('MI')),
                  DataColumn(label: Text('MOI')),
                  DataColumn(label: Text('Otros Gastos')),
                  DataColumn(label: Text('CIF')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.mi))),
                      DataCell(Text(Formatters.formatCurrency(calc.moi))),
                      DataCell(Text(Formatters.formatCurrency(calc.otrosGastosIndirectos))),
                      DataCell(Text(Formatters.formatCurrency(calc.cif))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostosUnitariosTable(BuildContext context, List<CalculoDetallado> calculos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Costos Unitarios',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('Total Gastos')),
                  DataColumn(label: Text('Unidades')),
                  DataColumn(label: Text('Costo Unitario')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.totalGastosProduccion))),
                      DataCell(Text(calc.unidades.toString())),
                      DataCell(
                        Text(
                          calc.costoUnitario != null ? Formatters.formatCurrency(calc.costoUnitario!) : 'N/A',
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedResultsContent(BuildContext context, List<CalculoDetallado> calculos, FactoresCalculo factores, TotalesCalculo totales) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalsCard(context, totales),
          const SizedBox(height: 24),
          _buildMITable(context, calculos, factores),
          const SizedBox(height: 24),
          _buildMOITable(context, calculos, factores),
          const SizedBox(height: 24),
          _buildOtrosGastosTable(context, calculos, factores),
          const SizedBox(height: 24),
          _buildCIFTable(context, calculos),
          const SizedBox(height: 24),
          _buildGastosProduccionTable(context, calculos),
          const SizedBox(height: 24),
          _buildCostosUnitariosTable(context, calculos),
          const SizedBox(height: 24),
          _buildTablaGeneral(context, calculos),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
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
            'Error al cargar resultados',
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
    );
  }

  Widget _buildGastosProduccionTable(BuildContext context, List<CalculoDetallado> calculos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gastos de Producción por Orden',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('MP')),
                  DataColumn(label: Text('MOD')),
                  DataColumn(label: Text('CIF')),
                  DataColumn(label: Text('Total Gastos')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.mp))),
                      DataCell(Text(Formatters.formatCurrency(calc.mod))),
                      DataCell(Text(Formatters.formatCurrency(calc.cif))),
                      DataCell(Text(Formatters.formatCurrency(calc.totalGastosProduccion))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMITable(BuildContext context, List<CalculoDetallado> calculos, FactoresCalculo factores) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cálculo de Materiales Indirectos (MI)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('MP')),
                  DataColumn(label: Text('Factor MI')),
                  DataColumn(label: Text('MI')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.mp))),
                      DataCell(Text(Formatters.formatNumber(factores.factorMI, decimals: 4))),
                      DataCell(Text(Formatters.formatCurrency(calc.mi))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMOITable(BuildContext context, List<CalculoDetallado> calculos, FactoresCalculo factores) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cálculo de Mano de Obra Indirecta (MOI)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('MOD')),
                  DataColumn(label: Text('Factor MOI')),
                  DataColumn(label: Text('MOI')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.mod))),
                      DataCell(Text(Formatters.formatNumber(factores.factorMOI, decimals: 4))),
                      DataCell(Text(Formatters.formatCurrency(calc.moi))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtrosGastosTable(BuildContext context, List<CalculoDetallado> calculos, FactoresCalculo factores) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cálculo de Otros Gastos Indirectos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('MOD')),
                  DataColumn(label: Text('Factor Otros Gastos')),
                  DataColumn(label: Text('Otros Gastos')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.mod))),
                      DataCell(Text(Formatters.formatNumber(factores.factorOtrosGastos, decimals: 4))),
                      DataCell(Text(Formatters.formatCurrency(calc.otrosGastosIndirectos))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTablaGeneral(BuildContext context, List<CalculoDetallado> calculos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabla General - Resumen Completo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('MP')),
                  DataColumn(label: Text('MOD')),
                  DataColumn(label: Text('MI')),
                  DataColumn(label: Text('MOI')),
                  DataColumn(label: Text('Otros Gastos')),
                  DataColumn(label: Text('CIF')),
                  DataColumn(label: Text('Total Gastos')),
                  DataColumn(label: Text('Unidades')),
                  DataColumn(label: Text('Costo Unitario')),
                ],
                rows: calculos.map<DataRow>((calc) {
                  return DataRow(
                    cells: [
                      DataCell(Text('#${calc.orden}')),
                      DataCell(Text(Formatters.formatCurrency(calc.mp))),
                      DataCell(Text(Formatters.formatCurrency(calc.mod))),
                      DataCell(Text(Formatters.formatCurrency(calc.mi))),
                      DataCell(Text(Formatters.formatCurrency(calc.moi))),
                      DataCell(Text(Formatters.formatCurrency(calc.otrosGastosIndirectos))),
                      DataCell(Text(Formatters.formatCurrency(calc.cif))),
                      DataCell(Text(Formatters.formatCurrency(calc.totalGastosProduccion))),
                      DataCell(Text(calc.unidades.toString())),
                      DataCell(
                        Text(
                          calc.costoUnitario != null ? Formatters.formatCurrency(calc.costoUnitario!) : 'N/A',
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsCard(BuildContext context, TotalesCalculo totales) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Totales del Período',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTotalItem(
                    context,
                    'Total MP',
                    Formatters.formatCurrency(totales.totalMP),
                    Icons.inventory,
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTotalItem(
                    context,
                    'Total MOD',
                    Formatters.formatCurrency(totales.totalMOD),
                    Icons.work,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTotalItem(
                    context,
                    'Total MI',
                    Formatters.formatCurrency(totales.totalMI),
                    Icons.inventory_2,
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTotalItem(
                    context,
                    'Total MOI',
                    Formatters.formatCurrency(totales.totalMOI),
                    Icons.engineering,
                    Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTotalItem(
                    context,
                    'Total Otros Gastos',
                    Formatters.formatCurrency(totales.totalOtrosGastos),
                    Icons.account_balance,
                    Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTotalItem(
                    context,
                    'Total CIF',
                    Formatters.formatCurrency(totales.totalCIF),
                    Icons.calculate,
                    Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.summarize,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total Gastos de Producción',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCurrency(totales.totalGastosProduccion),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
