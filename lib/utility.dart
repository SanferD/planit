import 'package:intl/intl.dart';
import 'package:planit/models/calendar_item.dart';
import 'package:planit/models/schedule_type.dart';

class Utility {
  static String yMMMEd(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat("h:mm a").format(dateTime);
  }

  static int durationInMinutes(DateTime startDateTime, DateTime endDateTime) {
    return endDateTime.difference(startDateTime).inMinutes;
  }

  static String dayOnly(DateTime dateTime) {
    return DateFormat.EEEE().format(dateTime);
  }

  static String MMMEd(DateTime dateTime) {
    return DateFormat.MMMEd().format(dateTime);
  }

  static void reorderCalendarItems(
      List<CalendarItem> calendarItems, final DateTime newBegin) {
    if (calendarItems.isEmpty) return;

    CalendarItem? firstRelativeCalendarItem;
    for (var i = 0; i < calendarItems.length; i++) {
      if (calendarItems[i].scheduleType == ScheduleType.relative) {
        firstRelativeCalendarItem = calendarItems[i];
        break;
      }
    }
    if (firstRelativeCalendarItem == null) return;

    // presumes all relative items are consecutive
    var nextBegin = newBegin;
    for (var i = 0; i < calendarItems.length; i++) {
      final current = calendarItems[i];
      final durationInMinutes =
          Utility.durationInMinutes(current.begin, current.end);
      current.begin = nextBegin;
      current.end = current.begin.add(Duration(minutes: durationInMinutes));

      nextBegin = current.end;
    }
  }
}
