import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/job_entries/format.dart';
import 'package:todo_app/app/home/models/entry.dart';
import 'package:todo_app/app/home/models/entry_list_model.dart';
import 'package:todo_app/app/home/models/job.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    required this.entry,
    required this.job,
    required this.onTap,
  });

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(
                  context, Provider.of<Format>(context, listen: false)),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context, Format format) {
    final entryListModel = EntryListModel(job: job, entry: entry);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(entryListModel.dayOfWeek,
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(entryListModel.startDate, style: TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              entryListModel.payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text(
              '${entryListModel.startTime(context)} - ${entryListModel.endTime(context)}',
              style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(entryListModel.durationFormatted,
              style: TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment!.isNotEmpty)
          Text(
            entry.comment!,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    required this.key,
    required this.entry,
    required this.job,
    required this.onDismissed,
    required this.onTap,
  });

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        job: job,
        onTap: onTap,
      ),
    );
  }
}
