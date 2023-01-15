import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:planit/boundaries/calendar_item_boundary.dart';
import 'package:planit/models/calendar_item.dart';
import 'package:planit/models/schedule_type.dart';
import 'package:planit/screens/calendar_item_screen.dart';
import 'package:planit/utility.dart';
import 'package:planit/screens/calendar_item_screen_arguments.dart';
import 'package:planit/widgets/calendar_screen_list_item.dart';
import 'package:planit/widgets/current_time_indicator_by_horizontal_line.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime now;
  final void Function() resetToToday;
  void Function()? jumpToNow; // set/updated once calendarItems are loaded
  final ScrollController timelineScrollController;
  final ScrollController calendarItemsScrollController;
  final ScrollController horizontalNowLineScrollController;

  static const slotSize = 80;

  CalendarScreen({Key? key, required this.now, required this.resetToToday})
      : timelineScrollController = ScrollController(),
        calendarItemsScrollController = ScrollController(),
        horizontalNowLineScrollController = ScrollController(),
        super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<List<CalendarItem>> calendarItemsFuture;

  DateTime get now => widget.now;

  bool get showHorizontalTimeline => isToday;

  double get currentTimeOffsetBottom {
    final minutes = Utility.durationInMinutes(now, nowJustBeforeTomorrow);
    final numberOfSlots = (minutes / 15).floor();
    final singleSlotOffset = minutes % 15;
    final offset = numberOfSlots * CalendarScreen.slotSize +
        (singleSlotOffset / 15) * CalendarScreen.slotSize;
    return offset;
  }

  double get currentTimeOffsetTop {
    final minutes = Utility.durationInMinutes(nowZero, now);
    final numberOfSlots = (minutes / 15).floor();
    final singleSlotOffset = minutes % 15;
    final offset = numberOfSlots * CalendarScreen.slotSize +
        (singleSlotOffset / 15) * CalendarScreen.slotSize;
    return offset;
  }

  bool get isToday {
    final now2 = DateTime.now();
    return now2.year == now.year &&
        now2.month == now.month &&
        now2.day == now.day;
  }

  DateTime get nowZero => DateTime(now.year, now.month, now.day);
  DateTime get nowJustBeforeTomorrow =>
      DateTime(now.year, now.month, now.day, 23, 59, 59);

  @override
  Widget build(BuildContext context) {
    final calendarItemBoundary = GetIt.I.get<CalendarItemBoundary>();
    calendarItemsFuture =
        calendarItemBoundary.listCalendarItems(nowZero, nowJustBeforeTomorrow);

    return Scaffold(
      appBar: AppBar(
        title: Text(Utility.MMMEd(now)),
        actions: [
          getRelativeTimeOffsetWidget(calendarItemBoundary),
          getJumpToNowWidget(),
          // getAddCalendarItemWidget(context, calendarItemBoundary, lowerInclusive, upperInclusive),
        ],
      ),
      body: FutureBuilder<List<CalendarItem>>(
        future: calendarItemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");

          final calendarItems = snapshot.data!;
          sortCalendarItemsByBegin(calendarItems);
          setJumpToNowIfNotSet(context);

          return calendarItems.isEmpty
              ? NoCalendarItems(
                  now: now,
                  updateLitsOfItems: () {
                    setState(() {
                      reloadCalendarItemsFuture(calendarItemBoundary);
                    });
                  },
                )
              : NotificationListener<ScrollNotification>(
                  child: Stack(
                    children: [
                      getTimelineBorder(
                        now,
                        context,
                        CalendarScreen.slotSize,
                      ),
                      getCalendarItemsWidget(
                        context,
                        calendarItems,
                        CalendarScreen.slotSize,
                        calendarItemBoundary,
                      ),
                      if (isToday)
                        CurrentTimeIndicatorByHorizontalLine(
                          getCurrentTimeOffset: () => currentTimeOffsetTop,
                          scrollController:
                              widget.calendarItemsScrollController,
                        ),
                    ],
                  ),
                  onNotification: (scrollInfo) {
                    widget.timelineScrollController
                        .jumpTo(widget.calendarItemsScrollController.offset);
                    return true;
                  });
        },
      ),
    );
  }

  FutureBuilder<List<CalendarItem>> getRelativeTimeOffsetWidget(
      CalendarItemBoundary calendarItemBoundary) {
    return FutureBuilder(
        future: calendarItemBoundary.listCalendarItems(
            nowZero, nowJustBeforeTomorrow), // != this.calendarItemsFuture
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("");

          final calendarItems = snapshot.data!;
          sortCalendarItemsByBegin(calendarItems);
          if (calendarItems.isEmpty) return const Text("");
          CalendarItem? firstRelativeCalendarItem =
              getFirstRelativeCalendarItem(calendarItems);
          if (firstRelativeCalendarItem == null) return const Text("");
          return ElevatedButton(
            onPressed: () async {
              final timeOfDayOfFirstRelativeCalendarItem =
                  TimeOfDay.fromDateTime(firstRelativeCalendarItem.begin);
              final newTimeOfDay = await showTimePicker(
                  context: context,
                  initialTime: timeOfDayOfFirstRelativeCalendarItem);
              if (newTimeOfDay == null) return;
              if (timeOfDayOfFirstRelativeCalendarItem == newTimeOfDay) return;

              final newBegin = DateTime(now.year, now.month, now.day,
                  newTimeOfDay.hour, newTimeOfDay.minute);
              Utility.reorderCalendarItems(calendarItems, newBegin);
              await calendarItemBoundary
                  .addOrUpdateCalendarItems(calendarItems);
              setState(() {
                reloadCalendarItemsFuture(calendarItemBoundary);
              });
            },
            child: Text(Utility.formatTime(calendarItems[0].begin)),
          );
        });
  }

  IconButton getJumpToNowWidget() {
    return IconButton(
      onPressed: () {
        widget.resetToToday();
        if (widget.jumpToNow == null) return;
        widget.jumpToNow!();
      },
      icon: const Icon(Icons.calendar_today),
    );
  }

  void setJumpToNowIfNotSet(BuildContext context) {
    if (widget.jumpToNow != null) return;
    widget.jumpToNow = () {
      final height = MediaQuery.of(context).size.height;
      widget.calendarItemsScrollController
          .jumpTo(currentTimeOffsetTop + 40 - height / 2);
    };
  }

  IconButton getAddCalendarItemWidget(
      BuildContext context,
      CalendarItemBoundary calendarItemBoundary,
      DateTime lowerInclusive,
      DateTime upperInclusive) {
    // not used
    return IconButton(
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
    );
  }

  CalendarItem? getFirstRelativeCalendarItem(List<CalendarItem> calendarItems) {
    CalendarItem? firstRelativeCalendarItem;
    for (var i = 0; i < calendarItems.length; i++) {
      firstRelativeCalendarItem = calendarItems[i];
      if (firstRelativeCalendarItem.scheduleType == ScheduleType.relative)
        break;
    }
    return firstRelativeCalendarItem;
  }

  void sortCalendarItemsByBegin(List<CalendarItem> calendarItems) {
    calendarItems.sort((one, two) => one.begin.isBefore(two.begin) ? -1 : 1);
  }

  void reloadCalendarItemsFuture(CalendarItemBoundary calendarItemBoundary) {
    calendarItemsFuture =
        calendarItemBoundary.listCalendarItems(nowZero, nowJustBeforeTomorrow);
  }

  IconButton getAddRelativeCalendarItemAfterThisOneIconButton(
      CalendarItem calendarItem,
      List<CalendarItem> calendarItems,
      int index,
      CalendarItemBoundary calendarItemBoundary) {
    return IconButton(
      onPressed: () async {
        final calendarItem2 = CalendarItem(
          title: "",
          beginInclusive: calendarItem.end,
          endInclusive: calendarItem.end.add(
            const Duration(minutes: 15),
          ),
          scheduleType: ScheduleType.relative,
        );
        calendarItems.insert(index + 1, calendarItem2);
        if (index + 2 < calendarItems.length) {
          Utility.reorderCalendarItems(
              calendarItems.sublist(index + 2), calendarItem2.end);
        }
        await calendarItemBoundary
            .addOrUpdateCalendarItems(calendarItems.sublist(index + 1));
        setState(() {
          reloadCalendarItemsFuture(calendarItemBoundary);
        });
      },
      icon: const Icon(Icons.add_circle_rounded),
      iconSize: 26,
    );
  }

  Widget getTimelineBorder(DateTime now, BuildContext context, int slotSize) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      controller: widget.timelineScrollController,
      itemCount: 24 * 4,
      itemBuilder: (context, index) {
        final dateTimeLine = nowZero.add(Duration(
          hours: (index / 4).floor(),
          minutes: ((index % 4) * 15).round(),
        ));
        final isHour = (index % 4) == 0;
        var isNewDayLine = dateTimeLine.hour == 0 && dateTimeLine.minute == 0;
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
                Utility.formatTime(dateTimeLine),
                style: const TextStyle(
                  fontSize: 8,
                ),
              ),
              if (isNewDayLine) Text(Utility.dayOnly(dateTimeLine)),
            ],
          ),
        );
      },
    );
  }

  DateTime getPreviousDateTime(List<CalendarItem> calendarItems, int index) {
    if (index == 0 || calendarItems.isEmpty) return nowZero;
    return calendarItems[index - 1].end;
  }

  Widget getCalendarItemsWidget(
      BuildContext context,
      List<CalendarItem> calendarItems,
      int slotSize,
      CalendarItemBoundary calendarItemBoundary) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      controller: widget.calendarItemsScrollController,
      itemCount: calendarItems.length + 1,
      itemBuilder: (context, index) {
        final previousDateTime = getPreviousDateTime(calendarItems, index);
        if (index == calendarItems.length) {
          final windowDateTimeInMinutes = Utility.durationInMinutes(
              previousDateTime, nowJustBeforeTomorrow);
          return Padding(
            padding: EdgeInsets.only(
                top: (windowDateTimeInMinutes / 15.0) * slotSize),
            child: Container(),
          );
        }
        final calendarItem = calendarItems[index];
        final numSlotsForItem = calendarItem.durationMinutes / 15.0;
        final windowDateTimeInMinutes =
            Utility.durationInMinutes(previousDateTime, calendarItem.begin);
        return Padding(
          padding: EdgeInsets.only(
            top: (windowDateTimeInMinutes / 15.0) * slotSize,
          ),
          child: Row(
            children: [
              SizedBox(
                height: numSlotsForItem * slotSize,
                width: mediaWidth * .1,
                child: getAddRelativeCalendarItemAfterThisOneIconButton(
                    calendarItem, calendarItems, index, calendarItemBoundary),
              ),
              Expanded(
                child: SizedBox(
                  height: numSlotsForItem * slotSize,
                  child: getCalendarItemCard(calendarItem, calendarItems,
                      calendarItemBoundary, index, context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Card getCalendarItemCard(
      CalendarItem calendarItem,
      List<CalendarItem> calendarItems,
      CalendarItemBoundary calendarItemBoundary,
      int index,
      BuildContext context) {
    return Card(
      color: Colors.green[400],
      child: CalendarScreenListItem(
        calendarItem: calendarItem,
        updateItem: (updatedCalendarItem) async {
          Utility.reorderCalendarItems(
              calendarItems.sublist(index + 1), updatedCalendarItem.end);
          await calendarItemBoundary
              .addOrUpdateCalendarItems(calendarItems.sublist(index));
          setState(() {
            reloadCalendarItemsFuture(calendarItemBoundary);
          });
        },
        onLongPress: () async {
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
            reloadCalendarItemsFuture(calendarItemBoundary);
          });
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
                final calendarItem = CalendarItem.withDateTime(now);
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
