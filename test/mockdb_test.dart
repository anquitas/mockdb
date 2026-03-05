import 'package:mockdb/mockdb.dart';

void main() async {
  print('🚀 Testing with MockResult structure...\n');

  final db = MockDB.instance;
  final users = db.collection<String>('users');

  // --- 1. Test Creation & count ---
  print('--- Test: Create & count ---');
  await users.create('Alice');
  await users.create('Bob');
  
  final result = await users.findMany();
  print('Result toString: $result'); // Should use your override
  print('Total Count: ${result.count}');
  
  if (result.count == 2) {
    print('✅ Count check passed.');
  }

  // --- 2. Test Data Extraction (the .data getter) ---
  print('\n--- Test: Data Extraction ---');
  List<String> rawNames = result.data; // Uses your .map logic internally
  print('Raw names list: $rawNames');
  
  if (rawNames.contains('Alice') && rawNames.contains('Bob')) {
    print('✅ .data list extraction works.');
  }

  // --- 3. Test First/Last Helpers ---
  print('\n--- Test: First/Last Data & IDs ---');
  print('First Entry Data: ${result.firstData}');
  print('First Entry ID:   ${result.firstId}');
  print('Last Entry Data:  ${result.lastData}');
  
  if (result.firstId != null && result.firstId!.isNotEmpty) {
    print('✅ ID extraction works.');
  }

  // --- 4. Test Single Record Wrapper Access ---
  print('\n--- Test: MockRecord Wrapper Access ---');
  // Accessing the actual MockRecord via your .first getter
  final firstRecord = result.first; 
  if (firstRecord != null) {
    print('Metadata check - Created At: ${firstRecord.createdAt}');
  }

  // --- 5. Test Empty Result ---
  print('\n--- Test: Empty State ---');
  final emptySearch = await users.findMany((name) => name == 'Ghost');
  print('Search for "Ghost" isEmpty: ${emptySearch.isEmpty}');
  
  if (emptySearch.firstData == null) {
    print('✅ Empty search returned null for firstData as expected.');
  }

  print('🧪 INITIALIZING CRUD TESTS...\n');

  await testCreate(users);
  await testRead(users);
  await testUpdate(users);
  await testDelete(users);

  print('\n🏁 ALL TESTS COMPLETED.');

}




// --- 1. CREATE TEST ---
Future<void> testCreate(MockCollection<String> col) async {
  print('▶️ Testing CREATE...');
  final result = await col.create('Alice');
  
  if (result.count == 1 && result.firstData == 'Alice') {
    print('  ✅ Success: Record created with ID: ${result.firstId}');
  } else {
    print('  ❌ Failure: Record not created.');
  }
}

// --- 2. READ TEST (Find & FindOne) ---
Future<void> testRead(MockCollection<String> col) async {
  print('\n▶️ Testing READ...');
  
  // Test FindAll
  final all = await col.findMany();
  print('  - Found ${all.count} total records.');

  // Test FindOne with Criteria
  final search = await col.findOne((name) => name == 'Alice');
  if (search.isNotEmpty) {
    print('  ✅ Success: Found "${search.firstData}" via search.');
  }
}

// --- 3. UPDATE TEST ---
Future<void> testUpdate(MockCollection<String> col) async {
  print('\n▶️ Testing UPDATE...');
  
  // We need an ID to test updateById
  final id = (await col.findMany()).firstId!;
  
  final result = await col.updateById(id, 'Alice-Updated');
  
  if (result.firstData == 'Alice-Updated') {
    print('  ✅ Success: Data updated to "${result.firstData}".');
    print('  - Timestamp change: ${result.first?.updatedAt}');
  }
}

// --- 4. DELETE TEST ---
Future<void> testDelete(MockCollection<String> col) async {
  print('\n▶️ Testing DELETE (Clear)...');
  
  // Currently, our engine uses 'clear' for bulk delete
  // await col.clear();
  
  final result = await col.findMany();
  if (result.isEmpty) {
    print('  ✅ Success: Collection is now empty.');
  }
}