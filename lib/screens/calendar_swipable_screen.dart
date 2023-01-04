import 'package:flutter/material.dart';
import 'package:planit/screens/calendar_screen.dart';

class CalendarSwipableScreen extends StatelessWidget {
  const CalendarSwipableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const initialPage = 300;
    final PageController controller = PageController(initialPage: initialPage);

    final now = DateTime.now();
    return PageView.builder(
      controller: controller,
      itemBuilder: ((context, index) {
        final days = index - initialPage;
        return CalendarScreen(
          now: now.add(Duration(days: days)),
          resetToToday: () => controller.jumpToPage(initialPage),
        );
      }),
    );
  }
}
