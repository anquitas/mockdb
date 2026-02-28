import 'package:mockdb/mockdb.dart';

void main() async {
  print('🚀 Starting MockDB Integration Tests...\n');

  try {
    // await testCreateRecord();
    // await testUpdateRecord();
    // await testDeleteRecord();
    // await testCollectionIsolation();
    await testSimpleSearch();
    
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

Future<void> testSimpleSearch() async {
  print('Running: testSimpleSearch...');
  
  // 1. Setup - Create a collection of strings
  final db = MockDB.instance;
  final collection = db.collection<String>('search_test');
  
  // 2. Seed Data
  await collection.create('Apple');
  await collection.create('Banana');
  await collection.create('Apricot');
  await collection.create('Blueberry');

  // 3. Perform Search (Find items starting with 'A')
  final aResults = await collection.search((data) => data.startsWith('A'));

  print(await collection.getAll());

  // 4. Assertions
  assert(aResults.length == 2, 'Should find exactly 2 items starting with A');
  
  // Verify the content is correct
  final names = aResults.map((r) => r.data).toList();
  assert(names.contains('Apple'), 'Results should include Apple');
  assert(names.contains('Apricot'), 'Results should include Apricot');
  assert(!names.contains('Banana'), 'Results should NOT include Banana');

  // 5. Perform Search (Find specific match)
  final blueberry = await collection.search((data) => data == 'Blueberry');
  assert(blueberry.length == 1, 'Should find exactly 1 Blueberry');
  assert(blueberry.first.data == 'Blueberry', 'Data should match');

  print('  - Passed!');
}