// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../components/_internal_components.dart';
import '../components/event_scroll_notifier.dart';
import '../enumerations.dart';
import '../event_arrangers/event_arrangers.dart';
import '../event_controller.dart';
import '../modals.dart';
import '../painters.dart';
import '../typedefs.dart';
import 'package:intl/intl.dart' hide TextDirection;

/// A single page for week view.
class CustomInternalWeekViewPage<T extends Object?> extends StatefulWidget {
  /// Width of the page.
  final double width;

  /// Height of the page.
  final double height;

  /// Dates to display on page.
  final List<DateTime> dates;

  /// Builds tile for a single event.
  final EventTileBuilder<T> eventTileBuilder;

  /// A calendar controller that controls all the events and rebuilds widget
  /// if event(s) are added or removed.
  final EventController<T> controller;

  /// A builder to build time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Flag to display live line.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final HourIndicatorSettings liveTimeIndicatorSettings;

  ///  Height occupied by one minute time span.
  final double heightPerMinute;

  /// Width of timeline.
  final double timeLineWidth;

  /// Offset of timeline.
  final double timeLineOffset;

  /// Height occupied by one hour time span.
  final double hourHeight;

  /// Arranger to arrange events.
  final EventArranger<T> eventArranger;

  /// Flag to display vertical line or not.
  final bool showVerticalLine;

  /// Offset for vertical line offset.
  final double verticalLineOffset;

  /// Builder for week day title.
  final DateWidgetBuilder weekDayBuilder;
  final DateEventsWidgetBuilder dateEventsWidgetBuilder;

  /// Height of week title.
  final double weekTitleHeight;

  /// Width of week title.
  final double weekTitleWidth;

  final ScrollController scrollController;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// Defines which days should be displayed in one week.
  ///
  /// By default all the days will be visible.
  /// Sequence will be monday to sunday.
  final List<WeekDays> weekDays;

  /// Called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  final MinuteSlotSize minuteSlotSize;

  final EventScrollConfiguration scrollConfiguration;

  DateTime selectedDateTime ;

  /// A single page for week view.
   CustomInternalWeekViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.weekTitleHeight,
    required this.weekDayBuilder,
    required this.width,
    required this.dates,
    required this.eventTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.showLiveLine,
    required this.liveTimeIndicatorSettings,
    required this.heightPerMinute,
    required this.timeLineWidth,
    required this.timeLineOffset,
    required this.height,
    required this.hourHeight,
    required this.eventArranger,
    required this.verticalLineOffset,
    required this.weekTitleWidth,
    required this.scrollController,
    required this.onTileTap,
    required this.onDateLongPress,
    required this.weekDays,
    required this.minuteSlotSize,
    required this.scrollConfiguration,
    required this.selectedDateTime,
    required this.dateEventsWidgetBuilder,
  }) : super(key: key);

  @override
  State<CustomInternalWeekViewPage<Object?>> createState() => _CustomInternalWeekViewPageState<Object?>();
}

class _CustomInternalWeekViewPageState<T extends Object?> extends State<CustomInternalWeekViewPage<T>> {
  @override
  Widget build(BuildContext context) {
    final filteredDates = _filteredDate();
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: widget.height + widget.weekTitleHeight,
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: widget.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: widget.weekTitleHeight,
                    width: widget.timeLineWidth,
                    child: Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(widget.dates.contains(widget.selectedDateTime))
                            Text('${widget.selectedDateTime.day}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w300),),
                            if(!widget.dates.contains(widget.selectedDateTime))
                            Text('${widget.dates.first.day}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w300),),
                            if(widget.dates.contains(widget.selectedDateTime))
                            Text(DateFormat('MMM').format(DateTime(0, widget.selectedDateTime.month)),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                            if(!widget.dates.contains(widget.selectedDateTime))
                            Text(DateFormat('MMM').format(DateTime(0, widget.dates.first.month)),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                    )),
                  ),
                  ...List.generate(
                    filteredDates.length,
                    (index) => SizedBox(
                      height: widget.weekTitleHeight,
                      width: widget.weekTitleWidth,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            widget.selectedDateTime =  filteredDates[index];
                          });
                          print(widget.controller.getEventsOnDay(filteredDates[index]));
                        },
                        child: Container(
                          height: 44,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (filteredDates[index] == widget.selectedDateTime)?
                                Color(0xff1479FF):Colors.transparent
                          ),
                          child: widget.weekDayBuilder(
                            filteredDates[index],widget.selectedDateTime
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
           widget.dateEventsWidgetBuilder(widget.controller.getEventsOnDay(widget.selectedDateTime).where((element) => element.isDate!).toList(),MediaQuery.of(context).size.width-(widget.timeLineWidth)),
            // Container(
            //   height: widget.weekTitleHeight,
            //   width: MediaQuery.of(context).size.width-(widget.timeLineWidth),
            //   color: Colors.blue,
            // ),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: HourLinePainter(
                          lineColor: widget.hourIndicatorSettings.color,
                          lineHeight: widget.hourIndicatorSettings.height,
                          offset: widget.timeLineWidth - widget.hourIndicatorSettings.offset,
                          minuteHeight: widget.heightPerMinute,
                          verticalLineOffset: widget.verticalLineOffset,
                          showVerticalLine: widget.showVerticalLine,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: EventGenerator<T>(
                          height: widget.height,
                          date: widget.selectedDateTime,
                          onTileTap: widget.onTileTap,
                          eventArranger: widget.eventArranger,
                          events: widget.controller.getEventsOnDay(widget.selectedDateTime),
                          heightPerMinute: widget.heightPerMinute,
                          eventTileBuilder: widget.eventTileBuilder,
                          scrollNotifier: widget.scrollConfiguration,
                          width: widget.width -
                              widget.timeLineWidth -
                              widget.hourIndicatorSettings.offset -
                              widget.verticalLineOffset,
                        ),
                      ),
                      TimeLine(
                        timeLineWidth: widget.timeLineWidth,
                        hourHeight: widget.hourHeight,
                        height: widget.height,
                        timeLineOffset: widget.timeLineOffset,
                        timeLineBuilder: widget.timeLineBuilder,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _filteredDate() {
    final output = <DateTime>[];
    final weekDays = widget.weekDays.toList();
    for (final date in widget.dates) {
      if (weekDays.any((weekDay) => weekDay.index + 1 == date.weekday)) {
        output.add(date);
      }
    }

    return output;
  }
}
