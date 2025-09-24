import 'package:equatable/equatable.dart';

class OrderInput extends Equatable {
  final int orden;

  final double mp;
  final double mod;
  final int unidades;
  final OrderStatus status;
  const OrderInput({
    required this.orden,
    required this.mp,
    required this.mod,
    required this.unidades,
    required this.status,
  });

  @override
  List<Object> get props => [orden, mp, mod, unidades, status];

  OrderInput copyWith({
    int? orden,
    double? mp,
    double? mod,
    int? unidades,
    OrderStatus? status,
  }) {
    return OrderInput(
      orden: orden ?? this.orden,
      mp: mp ?? this.mp,
      mod: mod ?? this.mod,
      unidades: unidades ?? this.unidades,
      status: status ?? this.status,
    );
  }
}

enum OrderStatus { terminada, enProceso }
