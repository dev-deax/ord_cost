import 'package:equatable/equatable.dart';

class PeriodParams extends Equatable {
  final double tasaCIFFactor;
  final double materialesIndirectos;
  final double manoObraIndirecta;

  const PeriodParams({
    required this.tasaCIFFactor,
    required this.materialesIndirectos,
    required this.manoObraIndirecta,
  });

  double get cifReal => materialesIndirectos + manoObraIndirecta;

  @override
  List<Object> get props => [
        tasaCIFFactor,
        materialesIndirectos,
        manoObraIndirecta,
      ];

  PeriodParams copyWith({
    double? tasaCIFFactor,
    double? materialesIndirectos,
    double? manoObraIndirecta,
  }) {
    return PeriodParams(
      tasaCIFFactor: tasaCIFFactor ?? this.tasaCIFFactor,
      materialesIndirectos: materialesIndirectos ?? this.materialesIndirectos,
      manoObraIndirecta: manoObraIndirecta ?? this.manoObraIndirecta,
    );
  }
}
