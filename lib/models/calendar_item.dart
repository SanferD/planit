import 'package:isar/isar.dart';

import 'schedule_type.dart';

part 'calendar_item.g.dart';

@collection
class CalendarItem {
  Id? id;
  String title;
  @Index()
  late DateTime begin;
  late DateTime end;
  @enumerated
  ScheduleType scheduleType;

  CalendarItem({
    this.title = "",
    DateTime? beginInclusive,
    DateTime? endInclusive,
    this.scheduleType = ScheduleType.relative,
  }) {
    final now = DateTime.now();
    begin = beginInclusive ?? now;
    end = endInclusive ?? now.add(const Duration(hours: 1));
  }
}