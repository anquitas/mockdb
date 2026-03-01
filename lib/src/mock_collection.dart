// USE --> expose and manage data for a data model of a type

// IMPORTS ---
import 'dart:async'; // async operations
import 'package:mockdb/mockdb.dart'; // ~ exposing db class
import 'package:mockdb/src/mock_query_result.dart';
import 'package:uuid/uuid.dart'; // to create unique id

// CLASS DEFINITION ---

class MockCollection<T> {
  // PROPERTIES ---

  // ~ DATA HOLD
  final Map<String, MockRecord<T>> _store =
      {}; // ~ private DB object to hold records
  final _controller = StreamController<List<MockRecord<T>>>.broadcast();

  // ? util -- maybe carry it somewhere else
  final _uuidGenerator = const Uuid(); // Instantiate the UUID generator

  /// Stream getter for listeners
  Stream<List<MockRecord<T>>> get stream => _controller.stream;

  // METHODS ---
  void notify() => _controller.add(_store.values.toList());

  // ~ Generate simple random ID
  String _genId() {
    return _uuidGenerator.v4();
  }

  // --- CREATE METHODS ---
  // ~ Create new record
  Future<MockRecord<T>> create(T data) {
    final id = _genId();
    final createdAt = DateTime.now().toUtc();
    final record = MockRecord(id: id, data: data, createdAt: createdAt);
    _store[id] = record;
    _controller.add(_store.values.toList());

    // printTest();

    return Future.value(record);
  }

  // READ METHODS ---
  

  Future<MockQueryResult<T>> findById(String id) async {
    final record = _store[id];
    return MockQueryResult(record != null ? [record] : []);
  }

  Future<MockQueryResult<T>> find([bool Function(T data)? criteria]) async {
    // If criteria is null, we return 'true' for every item (Select All)
    final filter = criteria ?? (data) => true;

    final filtered = _store.values
        .where((record) => filter(record.data))
        .toList();

    return MockQueryResult(filtered);
  }

  // --- UPDATE METHODS ---
  Future<MockQueryResult<T>> updateById(String id, T newData) async {
    if (!_store.containsKey(id)) {
      return MockQueryResult([]); // Return empty result if ID missing
    }

    final updated = _store[id]!.copyWith(data: newData);
    _store[id] = updated;
    notify();
    
    return MockQueryResult([updated]);
  }

  Future<MockQueryResult<T>> updateOne(bool Function(T data) criteria, T newData) async {
    try {
      // Find the first match
      final entry = _store.entries.firstWhere((e) => criteria(e.value.data));
      
      // Use our updateById logic to handle the save and notify
      return await updateById(entry.key, newData);
    } catch (e) {
      return MockQueryResult([]); // Return empty result if no match found
    }
  }

  Future<MockQueryResult<T>> update(
    bool Function(T data) criteria,
    T newData,
  ) async {
    List<MockRecord<T>> updatedRecords = [];

    // 1. Loop through all records in the store
    for (var entry in _store.entries) {
      final record = entry.value;

      // 2. Check if the 'letter' inside the 'envelope' matches the criteria
      if (criteria(record.data)) {
        // 3. Create the updated version (Same ID, New Data)
        final updated = record.copyWith(data: newData);

        // 4. Save back to store
        _store[entry.key] = updated;
        updatedRecords.add(updated);
      }
    }

    // 5. If we changed anything, notify the stream listeners
    if (updatedRecords.isNotEmpty) {
      _controller.add(_store.values.toList());
    }

    // 6. Return a QueryResult so the user can see what was changed
    return MockQueryResult(updatedRecords);
  }

  // --- DELETE METHODS ---
  // Future<bool> deleteById(String id) {
  //   final removed = _store.remove(id);
  //   _controller.add(_store.values.toList());
  //   return Future.value(removed != null);
  // }


  Future<MockQueryResult<T>> deleteById(String id) async {
    final record = _store.remove(id);
    
    if (record != null) {
      notify();
      return MockQueryResult([record]);
    }
    
    return MockQueryResult([]);
  }


  // --- TEST METHOD — PRINT ALL RECORDS
  void printTest() {
    print("+ [ LOG ] PRINT TEST ---");

    if (_store.isEmpty) {
      print("+ [LOG] (mockCollection is empty)");
      return;
    }

    for (final record in _store.values) {
      print("ID: ${record.id} | DATA: ${record.data}");
    }
    print("+ [LOG] end of printTest ---");
  }
}
