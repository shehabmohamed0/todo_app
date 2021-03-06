import 'package:intl/intl.dart';
import 'package:todo_app/app/home/models/entry.dart';
import 'package:todo_app/app/home/models/job.dart';
import 'package:todo_app/services/api_path.dart';
import 'package:todo_app/services/fire_store_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Stream<List<Job?>> jobsStream();

  Future<void> deleteJob(Job job);

  Future<void> setEntry(Entry entry);

  Stream<Job?> jobStream({required String jobId});

  Future<void> deleteEntry(Entry entry);

  Stream<List<Entry>> entriesStream({Job? job});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDataBase implements Database {
  final String uid;

  FireStoreDataBase({required this.uid});

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<Job?> jobStream({required String jobId}) => _service.documentStream(
        path: APIPath.job(uid, jobId),
        builder: (data, documentID) => Job.fromMap(data, documentID),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.start.compareTo(rhs.start),
      );
}
