import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/home/entries/entries_bloc.dart';
import 'package:todo_app/app/home/entries/entries_list_tile.dart';
import 'package:todo_app/app/home/job_entries/format.dart';
import 'package:todo_app/app/home/jobs/list_item_builder.dart';
import 'package:todo_app/services/data_base.dart';

class EntriesPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    final format = Provider.of<Format>(context);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database, format: format),
      child: EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
