import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/models/job.dart';
import 'package:todo_app/common_widgets/show_alert_dialog.dart';
import 'package:todo_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:todo_app/services/data_base.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job? job;

  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);

  static Future<void> show(BuildContext context, Database database,
      {Job? job}) async {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              database: database,
              job: job,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _ratePerHourNode = FocusNode();

  bool isLoading = false;
  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          isLoading = true;
        });
        final id = widget.job?.id ?? documentIdFromCurrentDate();
        final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job!.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          await showAlertDialog(
              context: context,
              title: 'Name already used',
              content: 'Please choose a different job name',
              defaultActionText: 'OK');
          setState(() {
            isLoading = false;
          });
        } else {
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(widget.job == null ? 'New Job' : 'Edit job'),
          actions: [
            TextButton(
              onPressed: !isLoading ? () => _submit() : null,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            )
          ],
        ),
        body: _buildContents());
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        focusNode: _nameNode,
        initialValue: _name,
        decoration: InputDecoration(
          labelText: 'Job name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Name can\'t be empty';
          }
        },
        onSaved: (value) => _name = value,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_ratePerHourNode),
      ),
      TextFormField(
        focusNode: _ratePerHourNode,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Name can\'t be empty';
          }
        },
        keyboardType:
            TextInputType.numberWithOptions(decimal: false, signed: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
