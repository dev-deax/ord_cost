import 'package:ord_cost/core/utils/formatters.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/domain/entities/order_calc.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';
import 'package:ord_cost/features/costeo/domain/entities/totales.dart';

class CalcularTotales {
  TotalesPeriodo execute(List<OrderCalc> orders, PeriodParams params) {
    double cogm = 0;
    double wip = 0;
    double cifAplicadoTotal = 0;

    for (final order in orders) {
      cifAplicadoTotal += order.cif;

      if (order.status == OrderStatus.terminada) {
        cogm += order.costoProduccion;
      } else {
        wip += order.costoProduccion;
      }
    }

    final cifReal = params.cifReal;
    final sobreSubAplicacion = Formatters.round2(cifAplicadoTotal - cifReal);

    return TotalesPeriodo(
      cogm: Formatters.round2(cogm),
      wip: Formatters.round2(wip),
      cifAplicadoTotal: Formatters.round2(cifAplicadoTotal),
      cifReal: cifReal,
      sobreSubAplicacion: sobreSubAplicacion,
    );
  }
}
