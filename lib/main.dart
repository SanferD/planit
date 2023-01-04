import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:get_it/get_it.dart';

import 'screens/calendar_swipable_screen.dart';
import 'package:planit/models/calendar_item.dart';
import 'package:planit/boundaries/calendar_item_boundary.dart';
import 'package:planit/screens/calendar_item_screen.dart';

const PLAN_IT = "PlanIt";

void main() async {
  final getIt = GetIt.instance;

  final isar = await Isar.open([CalendarItemSchema]);
  getIt.registerSingleton(CalendarItemBoundary(isar));

  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: PLAN_IT,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (_) => CalendarSwipableScreen(),
        CalendarItemScreen.routeName: (_) => CalendarItemScreen(),
      },
    );
  }
}
