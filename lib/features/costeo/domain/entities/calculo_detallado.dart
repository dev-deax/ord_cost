import 'package:equatable/equatable.dart';

class CalculoDetallado extends Equatable {
  final int orden;
  final double mp;
  final double mod;
  final double mi;
  final double moi;
  final double otrosGastosIndirectos;
  final double cif;
  final double totalGastosProduccion;
  final double unidades;
  final double? costoUnitario;

  const CalculoDetallado({
    required this.orden,
    required this.mp,
    required this.mod,
    required this.mi,
    required this.moi,
    required this.otrosGastosIndirectos,
    required this.cif,
    required this.totalGastosProduccion,
    required this.unidades,
    this.costoUnitario,
  });

  @override
  List<Object?> get props => [
        orden,
        mp,
        mod,
        mi,
        moi,
        otrosGastosIndirectos,
        cif,
        totalGastosProduccion,
        unidades,
        costoUnitario,
      ];
}

class FactoresCalculo extends Equatable {
  final double factorMI;
  final double factorMOI;
  final double factorOtrosGastos;

  const FactoresCalculo({
    required this.factorMI,
    required this.factorMOI,
    required this.factorOtrosGastos,
  });

  @override
  List<Object> get props => [factorMI, factorMOI, factorOtrosGastos];
}

class TotalesCalculo extends Equatable {
  final double totalMP;
  final double totalMOD;
  final double totalMI;
  final double totalMOI;
  final double totalOtrosGastos;
  final double totalCIF;
  final double totalGastosProduccion;
  final double totalUnidades;

  const TotalesCalculo({
    required this.totalMP,
    required this.totalMOD,
    required this.totalMI,
    required this.totalMOI,
    required this.totalOtrosGastos,
    required this.totalCIF,
    required this.totalGastosProduccion,
    required this.totalUnidades,
  });

  @override
  List<Object> get props => [
        totalMP,
        totalMOD,
        totalMI,
        totalMOI,
        totalOtrosGastos,
        totalCIF,
        totalGastosProduccion,
        totalUnidades,
      ];
}
