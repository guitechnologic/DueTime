import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 8) return oldValue;

    String result = '';
    for (int i = 0; i < digits.length; i++) {
      result += digits[i];
      if (i == 1 || i == 3) {
        if (i != digits.length - 1) result += '/';
      }
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
