import 'package:isar/isar.dart';
import 'package:planit/models/calendar_item.dart';

class CalendarItemBoundary {
  final Isar isar;

  CalendarItemBoundary(this.isar);

  Future<void> addCalendarItem(final CalendarItem calendarItem) async {
    await isar.writeTxn(() async {
      isar.calendarItems.put(calendarItem);
    });
  }

  Future<void> removeCalendarItem(final CalendarItem calendarItem) async {
    if (calendarItem.id == null) return;
    await isar.writeTxn(() async {
      isar.calendarItems.delete(calendarItem.id!);
    });
  }

  Future<List<CalendarItem>> listCalendarItems(
      final DateTime lowerInclusive, final DateTime upperInclusive) async {
    return await isar.calendarItems
        .filter()
        .beginBetween(lowerInclusive, upperInclusive)
        .findAll();
  }
}
