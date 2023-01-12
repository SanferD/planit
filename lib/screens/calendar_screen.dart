import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:planit/boundaries/calendar_item_boundary.dart';
import 'package:planit/models/calendar_item.dart';
import 'package:planit/models/schedule_type.dart';
import 'package:planit/screens/calendar_item_screen.dart';
import 'package:planit/utility.dart';
import 'package:planit/screens/calendar_item_screen_arguments.dart';
import 'dart:async';

class CalendarScreen extends StatefulWidget {
  final DateTime now;
  final void Function() resetToToday;
  final scrollController;

  CalendarScreen({Key? key, required this.now, required this.resetToToday})
      : scrollController = ScrollController(),
        super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<List<CalendarItem>> calendarItemsFuture;

  static const slotSize = 80;
  DateTime get now => widget.now;
  Timer? timer;

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      //job
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTimer();
    final calendarItemBoundary = GetIt.I.get<CalendarItemBoundary>();
    final lowerInclusive = DateTime(now.year, now.month, now.day);
    final upperInclusive = DateTime(now.year, now.month, now.day, 23, 59, 59);
    calendarItemsFuture =
        calendarItemBoundary.listCalendarItems(lowerInclusive, upperInclusive);

    return Scaffold(
      appBar: AppBar(
        title: Text(Utility.MMMEd(now)),
        actions: [
          FutureBuilder(
              future: calendarItemBoundary.listCalendarItems(
                  lowerInclusive, upperInclusive),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("");

                final calendarItems = snapshot.data!;
                calendarItems
                    .sort((one, two) => one.begin.isBefore(two.begin) ? -1 : 1);
                if (calendarItems.isEmpty) return const Text("");
                CalendarItem? firstRelativeCalendarItem;
                for (var i = 0; i < calendarItems.length; i++) {
                  firstRelativeCalendarItem = calendarItems[i];
                  if (firstRelativeCalendarItem.scheduleType ==
                      ScheduleType.relative) break;
                }
                if (firstRelativeCalendarItem == null) return const Text("");
                return ElevatedButton(
                  onPressed: () async {
                    final timeOfDayOfFirstRelativeCalendarItem =
                        TimeOfDay.fromDateTime(
                            firstRelativeCalendarItem!.begin);
                    final newTimeOfDay = await showTimePicker(
                        context: context,
                        initialTime: timeOfDayOfFirstRelativeCalendarItem);
                    if (newTimeOfDay == null) return;
                    if (timeOfDayOfFirstRelativeCalendarItem == newTimeOfDay)
                      return;

                    final newBegin = DateTime(now.year, now.month, now.day,
                        newTimeOfDay.hour, newTimeOfDay.minute);
                    Utility.reorderCalendarItems(calendarItems, newBegin);
                    await calendarItemBoundary.addCalendarItems(calendarItems);
                    setState(() {
                      calendarItemsFuture = calendarItemBoundary
                          .listCalendarItems(lowerInclusive, upperInclusive);
                    });
                  },
                  child: Text(Utility.formatTime(calendarItems[0].begin)),
                );
              }),
          IconButton(
            onPressed: () {
              widget.resetToToday();
              final height = MediaQuery.of(context).size.height;
              widget.scrollController
                  .jumpTo(currentTimeOffset + 40 - height / 2);
            },
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final arguments = CalendarItemScreenArguments(now: now);
              await Navigator.pushNamed(
                context,
                CalendarItemScreen.routeName,
                arguments: arguments,
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

          return SingleChildScrollView(
            controller: widget.scrollController,
            child: calendarItems.isEmpty
                ? NoCalendarItems(
                    now: now,
                    updateLitsOfItems: () {
                      setState(() {
                        calendarItemsFuture = calendarItemBoundary
                            .listCalendarItems(lowerInclusive, upperInclusive);
                      });
                    },
                  )
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
                      getNowHorizontalTimeLine(context, slotSize),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget getNowHorizontalTimeLine(BuildContext context, int slotSize) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        width: mediaWidth,
        height: currentTimeOffset,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.75,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  double get currentTimeOffset {
    final now = DateTime.now();
    final minutes =
        (now.difference(DateTime(now.year, now.month, now.day))).inMinutes;
    final numberOfSlots = (minutes / 15).floor();
    final offset = minutes % 15;
    final height = numberOfSlots * slotSize + (offset / 15) * slotSize;
    return height;
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
              top: (windowDateTimeInMinutes / 15.0) * slotSize,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: numSlots * slotSize,
                  width: mediaWidth * .1,
                  child: IconButton(
                    onPressed: () async {
                      final calendarItem2 = CalendarItem(
                        title: "",
                        beginInclusive: calendarItem.end,
                        endInclusive: calendarItem.end.add(
                          const Duration(minutes: 15),
                        ),
                        scheduleType: ScheduleType.relative,
                      );
                      if (index + 1 >= calendarItems.length) {
                        await calendarItemBoundary
                            .addCalendarItem(calendarItem2);
                      } else {
                        calendarItems.insert(index + 1, calendarItem2);
                        Utility.reorderCalendarItems(
                            calendarItems.sublist(index + 2),
                            calendarItem2.end);
                        await calendarItemBoundary
                            .addCalendarItems(calendarItems.sublist(index + 1));
                      }
                      setState(() {
                        calendarItemsFuture = calendarItemBoundary
                            .listCalendarItems(lowerInclusive, upperInclusive);
                      });
                    },
                    icon: const Icon(Icons.add_circle_rounded),
                    iconSize: 26,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: numSlots * slotSize,
                    child: Card(
                      color: Colors.green[400],
                      child: CalendarScreenListItem(
                        calendarItem: calendarItem,
                        updateItem: (updatedCalendarItem) async {
                          final index =
                              calendarItems.indexOf(updatedCalendarItem);
                          assert(index != -1,
                              "$updatedCalendarItem, $calendarItems");
                          Utility.reorderCalendarItems(
                              calendarItems.sublist(index + 1),
                              updatedCalendarItem.end);
                          await calendarItemBoundary
                              .addCalendarItems(calendarItems.sublist(index));
                          setState(() {
                            calendarItemsFuture =
                                calendarItemBoundary.listCalendarItems(
                                    lowerInclusive, upperInclusive);
                          });
                        },
                        onTap: () async {
                          final arguments = CalendarItemScreenArguments(
                            calendarItem: calendarItem,
                            now: now,
                            calendarItems: calendarItems
                                .sublist(index + 1)
                                .map((item) => CalendarItem.clone(item))
                                .toList(),
                          );
                          await Navigator.pushNamed(
                            context,
                            CalendarItemScreen.routeName,
                            arguments: arguments,
                          );
                          setState(() {
                            calendarItemsFuture =
                                calendarItemBoundary.listCalendarItems(
                                    lowerInclusive, upperInclusive);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
    required this.updateLitsOfItems,
  }) : super(key: key);

  final DateTime now;
  final void Function() updateLitsOfItems;

  @override
  Widget build(BuildContext context) {
    final calendarItemBoundary = GetIt.I.get<CalendarItemBoundary>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Calendar Items for ${Utility.yMMMEd(now)}.",
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_rounded),
              iconSize: 50,
              onPressed: () async {
                final calendarItem = CalendarItem.withDateTime(this.now);
                await calendarItemBoundary.addCalendarItem(calendarItem);
                updateLitsOfItems();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreenListItem extends StatelessWidget {
  final CalendarItem calendarItem;
  final void Function()? onTap;
  final void Function(CalendarItem) updateItem;
  final TextEditingController durationController;
  final TextEditingController titleController;

  CalendarScreenListItem(
      {Key? key,
      required this.calendarItem,
      this.onTap,
      required this.updateItem})
      : durationController = TextEditingController.fromValue(
          TextEditingValue(
            text:
                Utility.durationInMinutes(calendarItem.begin, calendarItem.end)
                    .toString(),
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
    final calendarDurationMinutes =
        Utility.durationInMinutes(calendarItem.begin, calendarItem.end);
    final isShort = calendarDurationMinutes < 15;
    durationController.selection = TextSelection.fromPosition(
        TextPosition(offset: durationController.text.length));
    return ListTile(
      visualDensity: isShort ? const VisualDensity(vertical: -2.1) : null,
      minVerticalPadding: -20,
      leading: CircleAvatar(
        radius: isShort ? 17 : 20,
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
          onSubmitted: (value) {
            final newDurationMinutes = int.parse(durationController.text);
            if (newDurationMinutes < 0 || newDurationMinutes > 60 * 24) {
              print("$newDurationMinutes is too large");
              return;
            }
            calendarItem.end = calendarItem.begin.add(Duration(
              minutes: newDurationMinutes,
            ));
            updateItem(calendarItem);
          },
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 2.0, top: isShort ? 4.5 : 0.0),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: isShort ? -13.0 : 0.0),
            border: InputBorder.none,
          ),
          controller: titleController,
          style: TextStyle(fontSize: isShort ? 16 : 18),
          onSubmitted: (value) {
            final newTitle = titleController.text;
            if (newTitle.length > 100) {
              print("$newTitle is too large");
              return;
            }
            calendarItem.title = newTitle;
            updateItem(calendarItem);
          },
        ),
      ),
      subtitle: (calendarDurationMinutes >= 15)
          ? Row(
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
            )
          : null,
      trailing: Chip(
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
      ),
      onLongPress: onTap,
    );
  }
}
