import 'package:flutter/material.dart';
import 'package:planit/screens/calendar_screen.dart';

class CalendarSwipableScreen extends StatelessWidget {
  CalendarSwipableScreen({super.key});

  late CalendarScreen currentPage;
  var hasJumped = false;

  @override
  Widget build(BuildContext context) {
    const initialPage = 300;
    final PageController controller = PageController(initialPage: initialPage);
    controller.addListener(() async {
      if (controller.page == null) return;
      if (controller.page!.toInt() == initialPage && hasJumped) {
        while (currentPage.jumpToNow == null) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
        // hack for now, wait 300ms. Should wait until page has loaded all items
        await Future.delayed(const Duration(milliseconds: 300));
        currentPage.jumpToNow!();
        hasJumped = false;
      }
    });

    final now = DateTime.now();
    return PageView.builder(
      controller: controller,
      itemBuilder: ((context, index) {
        final days = index - initialPage;
        currentPage = CalendarScreen(
          now: now.add(Duration(days: days)),
          resetToToday: () {
            hasJumped = true;
            controller.jumpToPage(initialPage);
          },
        );
        return currentPage;
      }),
    );
  }
}
