import 'package:mockdb/mockdb.dart';

void main() async {
  print('🚀 Starting MockDB Integration Tests...\n');

  try {
    await testCreateRecord();
    await testUpdateRecord();
    await testDeleteRecord();
    await testCollectionIsolation();
    
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
  final updated = await users.update(original.id, 'Bobby');

  assert(updated?.data == 'Bobby', 'Data should be updated');
  assert(updated?.id == original.id, 'ID should remain the same');
  assert(updated?.createdAt == original.createdAt, 'Timestamp should not change');
  
  print('  - Passed!');
}

/// 3. Test Deleting a Record
Future<void> testDeleteRecord() async {
  print('Running: testDeleteRecord...');
  final users = MockDB.instance.collection<String>('users');
  
  final record = await users.create('Charlie');
  final deleted = await users.delete(record.id);
  final found = await users.get(record.id);

  assert(deleted == true, 'Delete should return true');
  assert(found == null, 'Record should no longer exist');
  
  print('  - Passed!');
}

/// 4. Test Collection Isolation
Future<void> testCollectionIsolation() async {
  print('Running: testCollectionIsolation...');
  final db = MockDB.instance;
  
  final users = db.collection<String>('users');
  final posts = db.collection<String>('posts');

  await users.create('User1');
  final allPosts = await posts.getAll();

  assert(allPosts.isEmpty, 'Posts collection should be empty even if users has data');
  
  print('  - Passed!');
}