import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatMarketCap(double number) {
    if(number >= 1e15) {
      return "${(number / 1e15).toStringAsFixed(2)} Q";
    } else if(number >= 1e12) {
      return "${(number / 1e12).toStringAsFixed(2)} T";
    } else if (number >= 1e9) {
      return "${(number / 1e9).toStringAsFixed(2)} B";
    } else if (number >= 1e6) {
      return "${(number / 1e6).toStringAsFixed(2)} M";
    } else if (number >= 1e3) {
      return "${(number / 1e3).toStringAsFixed(2)} K";
    } else {
      return number.toStringAsFixed(3);
    }
  }

  static String formatPrice(double number) {
    var formatter;
    if (number >= 10000) {
      formatter = NumberFormat("#,##0.00");
    } else if (number >= 1000) {
      formatter = NumberFormat("#,##0.00");
    } else if (number >=1){
      formatter = NumberFormat("#,##0.00");
    } else if (number >= 0.1){
      formatter = NumberFormat("#,##0.0000");
    } else if (number >= 0.01){
      formatter = NumberFormat("#,##0.000000");
    } else {
      formatter = NumberFormat("#,##0.0000000");
    }

    String formattedPrice = formatter.format(number);
    return formattedPrice;
  }

  static String formatPrice2(double number) {
    var formatter;

    if(number >= 1e15) {
      return "${(number / 1e15).toStringAsFixed(2)} Q";
    } else if(number >= 1e12) {
      return "${(number / 1e12).toStringAsFixed(2)} T";
    } else if (number >= 1e9) {
      return "${(number / 1e9).toStringAsFixed(2)} B";
    } else if (number >= 1e6) {
      return "${(number / 1e6).toStringAsFixed(2)} M";
    } else if (number >= 1e3) {
      if (number < 999999) {
        formatter = NumberFormat("#,##0.0");
        String formattedPrice = formatter.format(number);
        return formattedPrice;
      } else {
        return "${(number / 1e3).toStringAsFixed(2)} K";
      }
    } else {
      if (number >=1){
        formatter = NumberFormat("#,##0.00");
      } else if (number >= 0.1){
        formatter = NumberFormat("#,##0.0000");
      } else if (number >= 0.01){
        formatter = NumberFormat("#,##0.00000");
      } else {
        formatter = NumberFormat("#,##0.000000");
      }
      String formattedPrice = formatter.format(number);
      return formattedPrice;
    }
  }

  static String formatAlertPrice(String input) {
    var formatter;
    if (input.isEmpty) return input;

    List<String> parts = input.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    formatter = NumberFormat("#,##0");
    String formattedInteger = formatter.format(int.parse(integerPart));

    return decimalPart != null ? "$formattedInteger.$decimalPart" : formattedInteger;
  }
  static String removeCommas(String input) {
    return input.replaceAll(',', '');
  }

  static String formatSupply(double number) {
    if(number >= 1e15) {
      return "${(number / 1e15).toStringAsFixed(2)} Q";
    } else if(number >= 1e12) {
      return "${(number / 1e12).toStringAsFixed(2)} T";
    }  else {
      return formatPrice(number);
    }
  }

  static String formatTime(int time) {
    final date = DateTime.fromMillisecondsSinceEpoch(time);
    final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  static String formatDate(int time) {
    final date = DateTime.fromMillisecondsSinceEpoch(time);
    final formattedDate = DateFormat('yyyy-MMMM-dd').format(date);
    return formattedDate;
  }


}