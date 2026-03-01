import 'package:mockdb/mockdb.dart';

import 'test_obj.dart';

void main() async {
  print('🚀 Starting MockDB Integration Tests...\n');

  try {
    // await testCreateRecord();
    // await testUpdateRecord();
    // await testDeleteRecord();
    await testDeleteMany();

    // await testCollectionIsolation();
    // await testSimpleSearch();
    // testQueryResult();
    // await testFindId();
    
    print('\n✅ All tests passed successfully!');
  } catch (e, stackTrace) {
    print('\n❌ Test failed!');
    print(e);
    print(stackTrace);
  }
}

/// 1. Test Creating a Record
Future<void> testCreateRecord() async {
  print('Running: testCreateRecord...');
  final db = MockDB.instance;
  final users = db.collection<String>('users');

  final record = await users.create('Alice');

  assert(record.id.isNotEmpty, 'ID should not be empty');
  assert(record.data == 'Alice', 'Data should match input');
  // assert(record.createdAt is DateTime, 'Timestamp should be created');
  
  print('  - Passed!');
}

/// 2. Test Updating a Record
Future<void> testUpdateRecord() async {
  print('Running: testUpdateRecord...');
  final users = MockDB.instance.collection<String>('users');
  
  final original = await users.create('Bob');
  var updated = (await users.updateById(original.id, 'moby')).records[0];
  print(updated.data);
  updated = (await users.updateOne((usr) => usr == "moby", 'Bobby')).records[0];
  print(updated.data);

  assert(updated?.data == 'Bobby', 'Data should be updated');
  assert(updated?.id == original.id, 'ID should remain the same');
  assert(updated?.createdAt == original.createdAt, 'Timestamp should not change');
  
  print('  - Passed!');
}

/// 3. Test Deleting a Record
Future<void> testDeleteRecord() async {
  print('Running: testDeleteRecord...');
  final users = MockDB.instance.collection<String>('users');
  final rec1 = await users.create('Bob');
  final rec2 = await users.create('Alice');
  final rec3 = await users.create('beyta');


  
  final record = await users.create('Charlie');
  final deleted = (await users.deleteById(record.id)).records[0].data;
  print("deleted: " +deleted);
  final found = (await users.findById(record.id)).records;
  print("found: $found");
  final del2 = (await users.deleteOne((usr) => usr == "Alice")).records[0].data;
  print("deleted2: " +del2);
  final found2 = (await users.findById(record.id)).records;
  print("found2: $found");

  print((await users.find()).data);
  assert(deleted == true, 'Delete should return true');
  assert(found == null, 'Record should no longer exist');
  
  print('  - Passed!');
}

Future<void> testDeleteMany() async {
  print('Running: testDeleteMany...');
  final collection = MockDB.instance.collection<String>('accounts');
  
  // 1. Reset
  await collection.delete((_) => true);

  // 2. Seed data with a pattern
  await collection.create('USER_Oğuz');
  await collection.create('USER_Gemini');
  await collection.create('ADMIN_Root');
  await collection.create('USER_Guest');
  await collection.create('ADMIN_Dev');

  print('Initial count: ${(await collection.find()).count}'); // Should be 5

  // 3. Delete all that start with 'USER_'
  final deletedResult = await collection.delete(
    (data) => data.startsWith('USER_')
  );

  // 4. Verification
  final remaining = await collection.find();
  
  print('Deleted count: ${deletedResult.count}'); // Should be 3
  print('Remaining records: ${remaining.data}');   // Should be [ADMIN_Root, ADMIN_Dev]

  // --- Assertions ---
  assert(deletedResult.count == 3, 'Should have deleted exactly 3 users');
  assert(remaining.count == 2, 'Should have 2 admins left');
  
  // Check that no 'USER_' strings remain
  final hasUsers = remaining.data.any((name) => name.startsWith('USER_'));
  assert(!hasUsers, 'There should be no records starting with USER_ left');

  print('  - Passed!');
}