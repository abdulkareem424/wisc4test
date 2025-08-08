import 'package:wisc_app/services/db_service.dart';

void main() async {
  try {
    // Initialize the database service
    final dbService = await DbService.init();
    
    // Add 3 children with different ages
    final children = [
      {
        'firstName': 'Emma',
        'lastName': 'Johnson',
        'dob': '2012-05-15', // 11 years old
        'type': 'child'
      },
      {
        'firstName': 'Liam',
        'lastName': 'Smith',
        'dob': '2009-08-22', // 14 years old
        'type': 'child'
      },
      {
        'firstName': 'Olivia',
        'lastName': 'Williams',
        'dob': '2010-03-10', // 13 years old
        'type': 'child'
      }
    ];
    
    // Insert each child
    for (var child in children) {
      final id = await dbService.insertChild(child);
      print('Added child: ${child['firstName']} ${child['lastName']} (ID: $id)');
    }
    
    // Retrieve and display all children
    final allChildren = await dbService.getChildren();
    print('\nAll children in database:');
    for (var child in allChildren) {
      print('${child['firstName']} ${child['lastName']} - DOB: ${child['dob']}');
    }
    
    print('\nDatabase operations completed successfully!');
  } catch (e) {
    print('Error: $e');
  }
}
