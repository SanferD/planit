import 'package:planit/models/calendar_item.dart';

class CalendarItemScreenArguments {
  final DateTime now;
  final CalendarItem? calendarItem;

  CalendarItemScreenArguments({required this.now, this.calendarItem});
}
