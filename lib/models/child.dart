class ChildModel {
  final int? id;
  final String firstName;
  final String lastName;
  final DateTime dob;

  ChildModel({this.id, required this.firstName, required this.lastName, required this.dob});

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'dob': dob.toIso8601String(),
  };

  factory ChildModel.fromMap(Map<String, dynamic> m) => ChildModel(
    id: m['id'] as int?,
    firstName: m['firstName'] as String,
    lastName: m['lastName'] as String,
    dob: DateTime.parse(m['dob'] as String),
  );
}