import 'package:flutter/material.dart';
import 'package:todo_app/app/home/job_entries/format.dart';

import 'entry.dart';
import 'job.dart';

class EntryListModel {
  Job job;
  Entry entry;
  final format = Format();

  EntryListModel({required this.job, required this.entry});

  String get dayOfWeek => format.dayOfWeek(entry.start);

  String get startDate => format.date(entry.start);

  String startTime(BuildContext context) =>
      TimeOfDay.fromDateTime(entry.start).format(context);

  String endTime(BuildContext context) =>
      TimeOfDay.fromDateTime(entry.end).format(context);

  String get durationFormatted => format.hours(entry.durationInHours);

  double get pay => job.ratePerHour * entry.durationInHours;

  String get payFormatted => format.currency(pay);
}
