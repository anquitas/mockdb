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

  Future<List<MockRecord<T>>> getAll() {
    // ~  List all records
    return Future.value(_store.values.toList());
  }

  Future<MockRecord<T>?> get(String id) {
    // ~ Get record by ID
    return Future.value(_store[id]);
  }

  Future<List<MockRecord<T>>> search(bool Function(T data) criteria) {
    // ~ simple query
    // We filter the internal map based on the 'data' field
    final results = _store.values
        .where((record) => criteria(record.data))
        .toList();
    return Future.value(results);
  }

  // Inside MockCollection<T>
  // Inside MockCollection<T>
  Future<MockQueryResult<T>> find([bool Function(T data)? criteria]) async {
    // If criteria is null, we return 'true' for every item (Select All)
    final filter = criteria ?? (data) => true;

    final filtered = _store.values
        .where((record) => filter(record.data))
        .toList();

    return MockQueryResult(filtered);
  }

  // --- UPDATE METHODS ---
  Future<MockRecord<T>?> updateById(String id, T newData) {
    if (!_store.containsKey(id)) return Future.value(null);

    final updated = _store[id]!.copyWith(data: newData);
    _store[id] = updated;
    _controller.add(_store.values.toList());
    return Future.value(updated);
  }

  Future<MockRecord<T>?> updateOne(
    bool Function(T data) criteria,
    T newData,
  ) async {
    try {
      // 1. Find the first record that matches the criteria
      final entry = _store.entries.firstWhere((e) => criteria(e.value.data));

      // 2. Create the updated record
      final updated = entry.value.copyWith(data: newData);

      // 3. Save and notify
      _store[entry.key] = updated;
      _controller.add(_store.values.toList());

      return updated;
    } catch (e) {
      // .firstWhere throws a StateError if no match is found
      return null;
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
  Future<bool> deleteById(String id) {
    final removed = _store.remove(id);
    _controller.add(_store.values.toList());
    return Future.value(removed != null);
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
