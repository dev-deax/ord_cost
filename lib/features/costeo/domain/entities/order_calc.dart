import 'package:equatable/equatable.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';

class OrderCalc extends Equatable {
  final int orden;

  final double mp;
  final double mod;
  final int unidades;
  final OrderStatus status;
  final double cif;
  final double costoProduccion;
  final double? costoUnitario;
  const OrderCalc({
    required this.orden,
    required this.mp,
    required this.mod,
    required this.unidades,
    required this.status,
    required this.cif,
    required this.costoProduccion,
    this.costoUnitario,
  });

  @override
  List<Object?> get props => [
        orden,
        mp,
        mod,
        unidades,
        status,
        cif,
        costoProduccion,
        costoUnitario,
      ];
}
