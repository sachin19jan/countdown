import 'dart:async';
import 'package:countdown_timer/adv_column.dart';
import 'package:countdown_timer/adv_row.dart';
import 'package:flutter/material.dart';

class AdvCountdown extends StatefulWidget {
  final DateTime futureDate;
  final TextStyle style;

  AdvCountdown({this.futureDate, TextStyle style})
      : this.style = style ??
            TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w600);

  @override
  State<StatefulWidget> createState() => AdvCountdownState();
}

class AdvCountdownState extends State<AdvCountdown> {
  TextStyle _numberStyle;
  TextStyle _datepartStyle;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _numberStyle = widget.style.copyWith(fontWeight: FontWeight.w700);
    _datepartStyle = widget.style;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (this.mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = widget.futureDate.difference(DateTime.now());
    if (duration.isNegative) {
      _numberStyle = _numberStyle.copyWith(color: Colors.black);
      _datepartStyle = _datepartStyle.copyWith(color: Colors.black);
    }

    int day = duration.inDays.abs();
    int hour = (duration.inHours.abs() % 24);
    int minute = (duration.inMinutes.abs() % 60);
    int second = (duration.inSeconds.abs() % 60);
    String dayDatePart = day.abs() == 1 ? "day" : "days";
    String hourDatePart = hour.abs() == 1 ? "hour" : "hours";
    String minuteDatePart = minute.abs() == 1 ? "minute" : "minutes";
    String secondDatePart = second.abs() == 1 ? "second" : "seconds";
    Widget separator = Text(":", style: _numberStyle);
    List<Widget> children = [];

    if (minute == 0 && hour == 0 && day == 0) {
      children.add(
          _buildItem(second * (duration.isNegative ? -1 : 1), secondDatePart));
    } else {
      children.addAll([separator, _buildItem(second, secondDatePart)]);
    }

    if (minute != 0) {
      if (hour == 0 && day == 0) {
        children.insert(
            0,
            _buildItem(
                minute * (duration.isNegative ? -1 : 1), minuteDatePart));
      } else {
        children.insert(0, _buildItem(minute, minuteDatePart));
        children.insert(0, separator);
      }
    }

    if (hour != 0) {
      if (day == 0) {
        children.insert(
            0, _buildItem(hour * (duration.isNegative ? -1 : 1), hourDatePart));
      } else {
        children.insert(0, _buildItem(hour, hourDatePart));
        children.insert(0, separator);
      }
    }

    if (day != 0) {
      children.insert(
          0, _buildItem(day * (duration.isNegative ? -1 : 1), dayDatePart));
    }

    return AdvRow(
        mainAxisSize: MainAxisSize.min,
        divider: RowDivider(8.0),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children);
  }

  Widget _buildItem(int amount, String datePart) {
    List<Widget> children = [];

    children.add(Text("$amount", style: _numberStyle));
    children.add(Text("$datePart",
        style:
            _datepartStyle.copyWith(fontSize: _datepartStyle.fontSize * 0.4)));

    return AdvColumn(children: children);
  }
}
