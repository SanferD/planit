import 'package:flutter/material.dart';

class MaxLengthTextFormField extends TextFormField {
  final String labelText;
  final int maxLength;

  MaxLengthTextFormField({
    required this.labelText,
    required this.maxLength,
    FormFieldSetter<String>? onSaved,
    Key? key,
    super.initialValue,
  }) : super(
          key: key,
          decoration: InputDecoration(
            labelText: labelText,
          ),
          validator: (title) {
            if (title == null) {
              return "$labelText cannot be empty";
            }
            title = title.trim();
            if (title.isEmpty) {
              return "$labelText cannor be empty";
            }
            if (title.length > maxLength) {
              return "$labelText length cannot exceed $maxLength";
            }
            return null;
          },
          onSaved: onSaved,
        );
}
