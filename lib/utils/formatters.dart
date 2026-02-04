import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }

  static double parse(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }
}

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'es_ES').format(date);
  }

  static String formatShortDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else if (dateOnly.year == today.year) {
      return DateFormat('d MMM', 'es_ES').format(date);
    } else {
      return DateFormat('d MMM yyyy', 'es_ES').format(date);
    }
  }

  static String getDayName(int day) {
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sab', 'Dom'];
    return days[day - 1];
  }

  static String getMonthName(int month) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}

class PercentageFormatter {
  static String format(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
}
