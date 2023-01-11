import 'package:planit/models/calendar_item.dart';

class CalendarItemScreenArguments {
  final DateTime now;
  final CalendarItem? calendarItem;
  final List<CalendarItem>? calendarItems;

  CalendarItemScreenArguments(
      {required this.now, this.calendarItem, this.calendarItems}) {
    assert((this.calendarItem == null && this.calendarItems == null) ||
        (this.calendarItem != null && this.calendarItems != null));
  }
}
