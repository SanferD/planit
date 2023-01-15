import "package:flutter/material.dart";
import 'dart:async';
import 'dart:math';

class CurrentTimeIndicatorByHorizontalLine extends StatefulWidget {
  CurrentTimeIndicatorByHorizontalLine({
    Key? key,
    required this.scrollController,
    required this.getCurrentTimeOffset,
  }) : super(key: key);

  final double Function() getCurrentTimeOffset;
  final ScrollController scrollController;
  var horizontalTimelineTopPosition = -1.0;

  bool get showHorizontalTimeline => horizontalTimelineTopPosition >= 0.0;

  @override
  State<CurrentTimeIndicatorByHorizontalLine> createState() =>
      _CurrentTimeIndicatorByHorizontalLineState();
}

class _CurrentTimeIndicatorByHorizontalLineState
    extends State<CurrentTimeIndicatorByHorizontalLine> {
  Timer? timer;
  var hasAddedListenerToUpdateHorizontalTimeline = false;

  void initTimerToPeriodicallyResetHorizontalNowTimeLine() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 15), (_) {
      setState(() {});
    });
  }

  void Function() scrollControllerListener(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return () {
      final offset = widget.scrollController.offset;
      if (max(0.0, offset - 10) <= widget.getCurrentTimeOffset() &&
          widget.getCurrentTimeOffset() <= offset + height) {
        setState(() {
          widget.horizontalTimelineTopPosition =
              widget.getCurrentTimeOffset() - offset;
        });
      } else {
        if (widget.horizontalTimelineTopPosition != -1.0) {
          setState(() {
            widget.horizontalTimelineTopPosition = -1.0;
          });
        }
      }
    };
  }

  void addListenerToUpdateHorizontalTimeline(BuildContext context) {
    widget.scrollController.addListener(scrollControllerListener(context));
  }

  @override
  void initState() {
    initTimerToPeriodicallyResetHorizontalNowTimeLine();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    addListenerToUpdateHorizontalTimeline(context);
    return Visibility(
      visible: widget.horizontalTimelineTopPosition >= 0.0,
      child: Positioned(
        top: widget.horizontalTimelineTopPosition,
        width: MediaQuery.of(context).size.width,
        child: const Divider(
          thickness: 2,
          color: Colors.red,
        ),
      ),
    );
  }
}
