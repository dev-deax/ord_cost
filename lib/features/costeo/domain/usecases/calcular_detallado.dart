import 'package:ord_cost/core/utils/formatters.dart';
import 'package:ord_cost/features/costeo/domain/entities/calculo_detallado.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';

class CalcularDetallado {
  FactoresCalculo calcularFactores(List<OrderInput> orders, PeriodParams params) {
    final totalMP = orders.fold<double>(0, (sum, order) => sum + order.mp);
    final totalMOD = orders.fold<double>(0, (sum, order) => sum + order.mod);

    return FactoresCalculo(
      factorMI: totalMP > 0 ? params.materialesIndirectos / totalMP : 0,
      factorMOI: totalMOD > 0 ? params.manoObraIndirecta / totalMOD : 0,
      factorOtrosGastos: params.tasaCIFFactor,
    );
  }

  TotalesCalculo calcularTotales(List<CalculoDetallado> calculos) {
    return TotalesCalculo(
      totalMP: calculos.fold<double>(0, (sum, calc) => sum + calc.mp),
      totalMOD: calculos.fold<double>(0, (sum, calc) => sum + calc.mod),
      totalMI: calculos.fold<double>(0, (sum, calc) => sum + calc.mi),
      totalMOI: calculos.fold<double>(0, (sum, calc) => sum + calc.moi),
      totalOtrosGastos: calculos.fold<double>(0, (sum, calc) => sum + calc.otrosGastosIndirectos),
      totalCIF: calculos.fold<double>(0, (sum, calc) => sum + calc.cif),
      totalGastosProduccion: calculos.fold<double>(0, (sum, calc) => sum + calc.totalGastosProduccion),
      totalUnidades: calculos.fold<double>(0, (sum, calc) => sum + calc.unidades),
    );
  }

  List<CalculoDetallado> execute(List<OrderInput> orders, PeriodParams params) {
    if (orders.isEmpty) return [];


    final totalMP = orders.fold<double>(0, (sum, order) => sum + order.mp);
    final totalMOD = orders.fold<double>(0, (sum, order) => sum + order.mod);

    final factorMI = totalMP > 0 ? params.materialesIndirectos / totalMP : 0;
    final factorMOI = totalMOD > 0 ? params.manoObraIndirecta / totalMOD : 0;
    final factorOtrosGastos = params.tasaCIFFactor;

    return orders.map((order) {
      final mi = Formatters.round2(order.mp * factorMI);
      final moi = Formatters.round2(order.mod * factorMOI);
      final otrosGastosIndirectos = Formatters.round2(order.mod * factorOtrosGastos);
      final cif = Formatters.round2(mi + moi + otrosGastosIndirectos);
      final totalGastosProduccion = Formatters.round2(order.mp + order.mod + cif);

      double? costoUnitario;
      if (order.unidades > 0) {
        costoUnitario = Formatters.round2(totalGastosProduccion / order.unidades);
      }

      return CalculoDetallado(
        orden: order.orden,
        mp: order.mp,
        mod: order.mod,
        mi: mi,
        moi: moi,
        otrosGastosIndirectos: otrosGastosIndirectos,
        cif: cif,
        totalGastosProduccion: totalGastosProduccion,
        unidades: order.unidades.toDouble(),
        costoUnitario: costoUnitario,
      );
    }).toList();
  }
}
