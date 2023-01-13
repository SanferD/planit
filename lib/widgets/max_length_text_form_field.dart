import 'package:flutter/material.dart';

class MaxLengthTextFormField extends TextFormField {
  final String labelText;
  final int maxLength;
  final FormFieldValidator<String>? validatorExtra;

  MaxLengthTextFormField({
    required this.labelText,
    required this.maxLength,
    FormFieldSetter<String>? onSaved,
    Key? key,
    this.validatorExtra,
    super.keyboardType,
    super.initialValue,
  }) : super(
          key: key,
          decoration: InputDecoration(
            labelText: labelText,
          ),
          validator: (value) {
            if (value == null) {
              return "$labelText cannot be empty";
            }
            value = value.trim();
            if (value.isEmpty) {
              return "$labelText cannor be empty";
            }
            if (value.length > maxLength) {
              return "$labelText length cannot exceed $maxLength";
            }
            if (validatorExtra != null) {
              return validatorExtra(value);
            }
            return null;
          },
          onSaved: onSaved,
        );
}
