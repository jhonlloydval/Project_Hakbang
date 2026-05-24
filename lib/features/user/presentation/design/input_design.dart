import 'package:flutter/material.dart';
import 'package:hakbang/features/user/presentation/design/app_colors.dart';

class InputDesign {
  static const _hintColor = AppColors.textMuted;
  static const _fillColor = AppColors.surface2;
  static const _enabledBorderColor = AppColors.border2;
  static const _focusedBorderColor = AppColors.accent;

  static const _hintStyle = TextStyle(color: _hintColor, fontSize: 14);

  static const _contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 13,
  );

  static OutlineInputBorder borderInput({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static InputDecoration unfocusedInputDecoration(
    String hintText, {
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      hintStyle: _hintStyle,
      filled: true,
      fillColor: _fillColor,
      contentPadding: _contentPadding,
      border: borderInput(color: _enabledBorderColor, width: 1.5),
      enabledBorder: borderInput(color: _enabledBorderColor, width: 1.5),
      focusedBorder: borderInput(color: _focusedBorderColor, width: 1.5),
    );
  }
}
