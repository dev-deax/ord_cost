import 'package:equatable/equatable.dart';

class TotalesPeriodo extends Equatable {
  final double cogm;

  final double wip;
  final double cifAplicadoTotal;
  final double cifReal;
  final double sobreSubAplicacion;
  const TotalesPeriodo({
    required this.cogm,
    required this.wip,
    required this.cifAplicadoTotal,
    required this.cifReal,
    required this.sobreSubAplicacion,
  });

  @override
  List<Object> get props => [
        cogm,
        wip,
        cifAplicadoTotal,
        cifReal,
        sobreSubAplicacion,
      ];
}
