import 'package:flutter/material.dart';

import 'package:planit/utility.dart';

class DateTimePickerFormField extends FormField<DateTime> {
  DateTimePickerFormField({
    Key? key,
    label = const Text(""),
    required DateTime initialValue,
    FormFieldValidator<DateTime>? validator,
    ValueChanged<DateTime?>? onChanged,
    void Function(DateTime?)? onSaved,
  }) : super(
            key: key,
            validator: validator,
            initialValue: initialValue,
            onSaved: onSaved,
            builder: (field) {
              void onChangedHandler(DateTime? value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              final itemDateString = Utility.MMMEd(field.value ?? initialValue);
              final itemTimeString =
                  Utility.formatTime(field.value ?? initialValue);
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      label,
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedDateTime = await showDatePicker(
                            context: field.context,
                            initialDate: initialValue,
                            firstDate:
                                initialValue.subtract(const Duration(days: 30)),
                            lastDate:
                                initialValue.add(const Duration(days: 30)),
                          );
                          if (pickedDateTime == null) return;
                          onChangedHandler(DateTime(
                            pickedDateTime.year,
                            pickedDateTime.month,
                            pickedDateTime.day,
                            initialValue.hour,
                            initialValue.minute,
                            0,
                          ));
                        },
                        child: Text(
                          itemDateString,
                          style: Theme.of(field.context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () async {
                          final pickedTimeOfDay = await showTimePicker(
                            context: field.context,
                            initialTime: TimeOfDay.fromDateTime(initialValue),
                          );
                          if (pickedTimeOfDay == null) return;
                          onChangedHandler(DateTime(
                            initialValue.year,
                            initialValue.month,
                            initialValue.day,
                            pickedTimeOfDay.hour,
                            pickedTimeOfDay.minute,
                            0,
                          ));
                        },
                        child: Text(
                          itemTimeString,
                          style: Theme.of(field.context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (field.errorText != null)
                    Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(field.context).errorColor,
                      ),
                    ),
                ],
              );
            });
}
