class Job {
  String id;
  final String name;
  final int ratePerHour;

  Job({required this.id, required this.name, required this.ratePerHour});

  static Job? fromMap(Map<String, dynamic>? data, String documentID) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(id: documentID, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
