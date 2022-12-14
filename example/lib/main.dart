import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import 'model/event.dart';
import 'pages/mobile/mobile_home_page.dart';
import 'pages/web/web_home_page.dart';
import 'widgets/responsive_widget.dart';

DateTime get _now => DateTime.now();

void main() {
  runApp(MyApp());
}

 class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    var days = getDaysInBetween(DateTime(2022, 09, 12,13,00),DateTime(2022, 09, 14,13,00));
    for(var day in days){
      _events.add(
        CalendarEventData(
          date: day,
          title: "Ahmed Elashry",
          description: "Today is ahmed meeting.",
          startTime: day,
          isDate: true,
          endTime: day,
          endDate: day,
        ),

      );
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return CalendarControllerProvider<Event>(
      controller: EventController<Event>()..addAll(_events),
      child: MaterialApp(
        title: 'Flutter Calendar Page Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        scrollBehavior: ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        home: ResponsiveWidget(
          mobileWidget: MobileHomePage(),
          webWidget: WebHomePage(),
        ),
      ),
    );
  }
}

List<CalendarEventData<Event>> _events = [

];
List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  print(days);
  return days;
}