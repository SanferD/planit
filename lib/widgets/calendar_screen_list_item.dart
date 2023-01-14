import "package:flutter/material.dart";
import "package:planit/models/calendar_item.dart";
import "package:planit/utility.dart";

class CalendarScreenListItem extends StatelessWidget {
  final CalendarItem calendarItem;
  final void Function()? onLongPress;
  final void Function(CalendarItem) updateItem;
  final TextEditingController durationController;
  final TextEditingController titleController;

  CalendarScreenListItem(
      {super.key,
      required this.calendarItem,
      this.onLongPress,
      required this.updateItem})
      : durationController = TextEditingController.fromValue(
          TextEditingValue(
            text: calendarItem.durationMinutes.toString(),
          ),
        ),
        titleController = TextEditingController.fromValue(
          TextEditingValue(
            text: calendarItem.title,
          ),
        );

  @override
  Widget build(BuildContext context) {
    const subtitleStyle = TextStyle(fontSize: 12);
    const trailingTextStyle = TextStyle(fontSize: 12);
    final isShort = calendarItem.durationMinutes < 15;
    setDurationCursorPositionToEnd();

    return ListTile(
      visualDensity: isShort ? const VisualDensity(vertical: -2.1) : null,
      minVerticalPadding: -20,
      leading: getDurationWidget(isShort),
      title: getTitleWidget(isShort),
      subtitle: (calendarItem.durationMinutes >= 15)
          ? getDateRangeWidget(subtitleStyle)
          : null,
      trailing: getScheduleTypeWidget(trailingTextStyle),
      onLongPress: onLongPress,
    );
  }

  void setDurationCursorPositionToEnd() {
    durationController.selection =
        TextSelection.collapsed(offset: durationController.text.length);
  }

  Chip getScheduleTypeWidget(TextStyle trailingTextStyle) {
    return Chip(
      visualDensity: const VisualDensity(vertical: -4),
      padding: const EdgeInsets.all(0.0),
      label: Text(
        calendarItem.scheduleType.display,
        style: trailingTextStyle,
      ),
      avatar: CircleAvatar(
        child: Text(
          calendarItem.scheduleType.display.characters.first.toUpperCase(),
          style: trailingTextStyle,
        ),
      ),
    );
  }

  Row getDateRangeWidget(TextStyle subtitleStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          Utility.formatTime(calendarItem.begin),
          style: subtitleStyle,
        ),
        Text(" - ", style: subtitleStyle),
        Text(
          Utility.formatTime(calendarItem.end),
          style: subtitleStyle,
        ),
      ],
    );
  }

  Padding getTitleWidget(bool isShort) {
    return Padding(
      padding: EdgeInsets.only(
        left: 2.0,
        top: isShort ? 4.5 : 0.0,
      ),
      child: Focus(
        onFocusChange: onSubmittedTitle,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: isShort ? -13.0 : 0.0),
            border: InputBorder.none,
          ),
          controller: titleController,
          style: TextStyle(fontSize: isShort ? 16 : 18),
        ),
      ),
    );
  }

  CircleAvatar getDurationWidget(bool isShort) {
    return CircleAvatar(
      radius: isShort ? 17 : 20,
      child: Focus(
        onFocusChange: onSubmittedDuration,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: isShort
                ? const EdgeInsets.only(left: 7, bottom: 15)
                : const EdgeInsets.only(left: 10, bottom: 10),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          controller: durationController,
          style: TextStyle(fontSize: isShort ? 16 : 18),
        ),
      ),
    );
  }

  void onSubmittedTitle(_) {
    final newTitle = titleController.text;
    if (newTitle.length > 100) {
      print("$newTitle is too large");
      return;
    }
    if (calendarItem.title == newTitle) return;
    calendarItem.title = newTitle;
    updateItem(calendarItem);
  }

  void onSubmittedDuration(_) {
    final newDurationMinutes = int.tryParse(durationController.text);
    if (newDurationMinutes == null) return;
    if (newDurationMinutes < 0 || newDurationMinutes > 60 * 24) {
      print("$newDurationMinutes is too large");
      return;
    }
    if (newDurationMinutes == calendarItem.durationMinutes) return;
    calendarItem.durationMinutes = newDurationMinutes;
    updateItem(calendarItem);
  }
}
