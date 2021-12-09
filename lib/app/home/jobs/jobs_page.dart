import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/job_entries/job_entries_page.dart';
import 'package:todo_app/app/home/jobs/job_list_type.dart';
import 'package:todo_app/app/home/jobs/empty_content.dart';
import 'package:todo_app/app/home/jobs/list_item_builder.dart';
import 'package:todo_app/app/home/models/job.dart';
import 'package:todo_app/common_widgets/show_alert_dialog.dart';
import 'package:todo_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/services/data_base.dart';

import 'edit_job_page.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation Failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          IconButton(
              onPressed: () => EditJobPage.show(
                  context, Provider.of<Database>(context, listen: false)),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job?>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
                  key: Key('job-${job!.id}'),
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (action) => _delete(context, job),
                  child: JobListTile(
                    job: job,
                    onTap: () => JobEntriesPage.show(context, database, job),
                  ),
                ));
      },
    );
  }
}
