import 'package:ord_cost/core/utils/formatters.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/domain/entities/order_calc.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';

class CalcularOrden {
  OrderCalc execute(OrderInput order, PeriodParams params) {
    final cif = Formatters.round2(order.mod * params.tasaCIFFactor);
    final costoProduccion = Formatters.round2(order.mp + order.mod + cif);

    double? costoUnitario;
    if (order.unidades > 0) {
      costoUnitario = Formatters.round2(costoProduccion / order.unidades);
    }

    return OrderCalc(
      orden: order.orden,
      mp: order.mp,
      mod: order.mod,
      unidades: order.unidades,
      status: order.status,
      cif: cif,
      costoProduccion: costoProduccion,
      costoUnitario: costoUnitario,
    );
  }
}
