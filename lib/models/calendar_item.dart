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

  CalendarItem.withDateTime(DateTime dateTime)
      : title = "",
        scheduleType = ScheduleType.relative {
    begin = dateTime;
    end = begin.add(const Duration(hours: 1));
  }

  CalendarItem.clone(CalendarItem otherItem)
      : id = otherItem.id,
        title = otherItem.title,
        begin = otherItem.begin,
        end = otherItem.end,
        scheduleType = otherItem.scheduleType;

  @override
  operator ==(covariant CalendarItem other) => other.id == id;
}
