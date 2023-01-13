import 'package:flutter/material.dart';
import 'package:planit/widgets/max_length_text_form_field.dart';
import 'package:planit/widgets/date_time_picker_form_field.dart';
import 'package:planit/boundaries/calendar_item_boundary.dart';
import 'package:planit/models/calendar_item.dart';
import 'package:planit/models/schedule_type.dart';
import 'package:planit/widgets/radio_button_form_field.dart';
import 'package:get_it/get_it.dart';
import 'package:planit/screens/calendar_item_screen_arguments.dart';
import 'package:planit/utility.dart';

class CalendarItemScreen extends StatefulWidget {
  static const routeName = "/calendar-item";

  @override
  State<CalendarItemScreen> createState() => _CalendarItemScreenState();
}

class _CalendarItemScreenState extends State<CalendarItemScreen> {
  @override
  Widget build(BuildContext context) {
    // fetch CalendarItem from arguments (edit), or create a new blank one (add)
    final arguments = ModalRoute.of(context)!.settings.arguments
        as CalendarItemScreenArguments;
    final isAdd = arguments.calendarItem == null;
    final calendarItem = isAdd
        ? CalendarItem.withDateTime(arguments.now)
        : arguments.calendarItem!;
    final calendarItems = arguments.calendarItems;

    // convert schedule type enum to list of {"value": <>, "display":}
    // which is used by radio button form field to present radio buttons
    final scheduleTypeRadioButtonOptions = ScheduleType.values
        .map((scheduleType) => {
              "value": scheduleType,
              "display": scheduleType.display,
            })
        .toList();

    // spacing between rows in form
    const verticalSpacing = SizedBox(
      height: 45,
    );

    final calendarItemForm = CalendarItemForm(
      widget: widget,
      calendarItem: calendarItem,
      verticalSpacing: verticalSpacing,
      scheduleTypeRadioButtonOptions: scheduleTypeRadioButtonOptions,
    );
    final calendarItemBoundary = GetIt.I.get<CalendarItemBoundary>();
    return Scaffold(
      appBar: AppBar(
        title: Text("${isAdd ? 'Add' : 'Edit'} Calendar Item"),
        actions: [
          if (!isAdd)
            IconButton(
              icon: const Icon(Icons.delete_outline_outlined),
              onPressed: () async {
                final navigator = Navigator.of(context);
                Utility.reorderCalendarItems(
                    calendarItems!, calendarItem.begin);
                await calendarItemBoundary.addCalendarItems(calendarItems);
                await calendarItemBoundary.removeCalendarItem(calendarItem);
                navigator.pop();
              },
            ),
          IconButton(
            icon: const Icon(Icons.save_sharp),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final currentState = calendarItemForm.formKey.currentState;
              if (currentState == null) return;
              if (currentState.validate()) {
                currentState.save(); // should populate calendarItem

                await calendarItemBoundary.addCalendarItem(calendarItem);
                navigator.pop(); // save success, go back
              }
            },
          ),
        ],
      ),
      body: calendarItemForm,
    );
  }
}

class CalendarItemForm extends StatelessWidget {
  CalendarItemForm({
    Key? key,
    required this.widget,
    required this.calendarItem,
    required this.verticalSpacing,
    required this.scheduleTypeRadioButtonOptions,
  }) : super(key: key);

  final CalendarItemScreen widget;
  final CalendarItem calendarItem;
  final SizedBox verticalSpacing;
  final List<Map<String, Object>> scheduleTypeRadioButtonOptions;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MaxLengthTextFormField(
                labelText: "Title",
                maxLength: 150,
                initialValue: calendarItem.title,
                onSaved: (newTitle) {
                  if (newTitle != null) calendarItem.title = newTitle;
                },
              ),
              verticalSpacing,
              MaxLengthTextFormField(
                labelText: "Duration Minutes",
                maxLength: 10,
                keyboardType: TextInputType.number,
                initialValue: calendarItem.durationMinutes.toString(),
                validatorExtra: (value) {
                  final durationMinutes = int.tryParse(value ?? "");
                  if (durationMinutes == null) return "Cannot parse $value";
                  return null;
                },
                onSaved: (newDuration) {
                  if (newDuration == null) return;
                  final durationMinutes = int.tryParse(newDuration);
                  if (durationMinutes == null) return;
                  calendarItem.durationMinutes = durationMinutes;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
