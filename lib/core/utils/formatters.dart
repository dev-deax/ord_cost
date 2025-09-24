import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_GT',
    symbol: 'Q',
    decimalDigits: 2,
  );

  static String formatCurrency(double value) {
    return _currencyFormat.format(value);
  }

  static String formatNumber(double value, {int decimals = 2}) {
    final format = NumberFormat('#,##0.${'0' * decimals}', 'es_GT');
    return format.format(value);
  }

  static int? parseInt(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }

  static double? parseNum(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      return null;
    }
  }

  static double round2(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
}
