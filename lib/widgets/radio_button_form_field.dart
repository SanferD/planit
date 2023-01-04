import 'package:flutter/material.dart';

class RadioButtonFormField<T> extends FormField<T> {
  RadioButtonFormField({
    Key? key,
    required String optionsKeyForDisplay,
    required String optionsKeyForValue,
    required List<Map<dynamic, dynamic>> options,
    Widget label = const Text(""),
    required T initialValue,
    FormFieldValidator<T>? validator,
    ValueChanged<T?>? onChanged,
    void Function(T?)? onSaved,
  }) : super(
            key: key,
            validator: validator,
            initialValue: initialValue,
            onSaved: onSaved,
            builder: (field) {
              void onChangedHandler(T? value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              final optionListTiles = options
                  .map(
                    (optionItem) => SizedBox(
                      width: 140,
                      child: ListTile(
                        horizontalTitleGap: 0,
                        title: Text(optionItem[optionsKeyForDisplay]),
                        leading: Radio<T>(
                          groupValue: field.value,
                          value: optionItem[optionsKeyForValue],
                          onChanged: (T? value) {
                            if (value == null) return;
                            onChangedHandler(value);
                          },
                        ),
                      ),
                    ),
                  )
                  .toList();
              final rowChildren = [label];
              rowChildren.addAll(optionListTiles);
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: rowChildren,
              );
            });

  @override
  _RadioButtonFormFieldState<T> createState() =>
      _RadioButtonFormFieldState<T>();
}

class _RadioButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  RadioButtonFormField<T> get widget => super.widget as RadioButtonFormField<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
  }
}
