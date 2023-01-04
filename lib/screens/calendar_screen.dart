import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:planit/boundaries/calendar_item_boundary.dart';
import 'package:planit/models/calendar_item.dart';
import 'package:planit/models/schedule_type.dart';
import 'package:planit/screens/calendar_item_screen.dart';
import 'package:planit/utility.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime now;

  const CalendarScreen({Key? key, required this.now}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<List<CalendarItem>> calendarItemsFuture;

  DateTime get now => widget.now;

  @override
  Widget build(BuildContext context) {
    print(now);
    final calendarItemBoundary = GetIt.I.get<CalendarItemBoundary>();
    final lowerInclusive = DateTime(now.year, now.month, now.day);
    final upperInclusive = DateTime(now.year, now.month, now.day, 23, 59, 59);
    calendarItemsFuture =
        calendarItemBoundary.listCalendarItems(lowerInclusive, upperInclusive);

    return Scaffold(
      appBar: AppBar(
        title: Text(Utility.MMMEd(now)),
        actions: [
          IconButton(
            onPressed: () {
              print("todo");
            },
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                CalendarItemScreen.routeName,
              );
              setState(() {
                calendarItemsFuture = calendarItemBoundary.listCalendarItems(
                    lowerInclusive, upperInclusive);
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CalendarItem>>(
        future: calendarItemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");

          final calendarItems = snapshot.data!;
          calendarItems
              .sort((one, two) => one.begin.isBefore(two.begin) ? -1 : 1);

          const slotSize = 80;
          return SingleChildScrollView(
            child: calendarItems.isEmpty
                ? NoCalendarItems(now: now)
                : Stack(
                    children: [
                      getTimelineBorder(now, context, slotSize),
                      getCalendarItems(
                        context,
                        calendarItems,
                        now,
                        slotSize,
                        calendarItemBoundary,
                        lowerInclusive,
                        upperInclusive,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Column getCalendarItems(
      BuildContext context,
      List<CalendarItem> calendarItems,
      DateTime now,
      int slotSize,
      CalendarItemBoundary calendarItemBoundary,
      DateTime lowerInclusive,
      DateTime upperInclusive) {
    final mediaWidth = MediaQuery.of(context).size.width;
    var previousDateTime = DateTime(now.year, now.month, now.day);
    return Column(
      children: List.generate(
        calendarItems.length,
        (index) {
          final calendarItem = calendarItems[index];
          final calendarDurationMinutes =
              Utility.durationInMinutes(calendarItem.begin, calendarItem.end);
          final numSlots = calendarDurationMinutes / 15.0;
          final windowDateTimeInMinutes =
              Utility.durationInMinutes(previousDateTime, calendarItem.begin);
          previousDateTime = calendarItem.end;
          return Padding(
            padding: EdgeInsets.only(
              left: mediaWidth * .1,
              top: (windowDateTimeInMinutes / 15.0) * slotSize,
            ),
            child: SizedBox(
              height: numSlots * slotSize,
              child: Card(
                color: Colors.green[400],
                child: CalendarScreenListItem(
                  calendarItem: calendarItem,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      CalendarItemScreen.routeName,
                      arguments: calendarItem,
                    );
                    setState(() {
                      calendarItemsFuture = calendarItemBoundary
                          .listCalendarItems(lowerInclusive, upperInclusive);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column getTimelineBorder(DateTime now, BuildContext context, int slotSize) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List<Widget>.generate(
        24 * 4,
        (index) {
          final dateTime = DateTime(now.year, now.month, now.day,
              (index / 4).floor(), ((index % 4) * 15).round());
          final isHour = (index % 4) == 0;
          return Container(
            width: mediaWidth,
            height: slotSize.toDouble(),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: isHour ? 3 : 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utility.formatTime(dateTime),
                  style: const TextStyle(
                    fontSize: 8,
                  ),
                ),
                if (dateTime.hour == 0 && dateTime.minute == 0)
                  Text(Utility.dayOnly(dateTime)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NoCalendarItems extends StatelessWidget {
  const NoCalendarItems({
    Key? key,
    required this.now,
  }) : super(key: key);

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Calendar Items for ${Utility.yMMMEd(now)}.",
          ),
        ],
      ),
    );
  }
}

class CalendarScreenListItem extends StatelessWidget {
  final CalendarItem calendarItem;
  final void Function()? onTap;

  const CalendarScreenListItem(
      {Key? key, required this.calendarItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    const subtitleStyle = TextStyle(fontSize: 12);
    const trailingTextStyle = TextStyle(fontSize: 12);
    final calendarDurationMinutes =
        Utility.durationInMinutes(calendarItem.begin, calendarItem.end);
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          calendarDurationMinutes.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Text(
          calendarItem.title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Utility.formatTime(calendarItem.begin),
            style: subtitleStyle,
          ),
          const Text(" - ", style: subtitleStyle),
          Text(
            Utility.formatTime(calendarItem.end),
            style: subtitleStyle,
          ),
        ],
      ),
      trailing: Chip(
        label:
            Text(calendarItem.scheduleType.display, style: trailingTextStyle),
        avatar: CircleAvatar(
          child: Text(
            calendarItem.scheduleType.display.characters.first.toUpperCase(),
            style: trailingTextStyle,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
