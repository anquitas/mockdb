// USE -->
 

// IMPORTS ---
import 'dart:async';
import 'dart:math';

import 'package:mockdb/mockdb.dart';



// CLASS DEFINITION ---

class MockCollection<T> {

  // PROPERTIES ---
  final Map<String, MockRecord<T>> _store = {}; // DB object to hold record



  final _controller = StreamController<List<MockRecord<T>>>.broadcast();
  

  /// Stream for listeners
  Stream<List<MockRecord<T>>> get stream => _controller.stream;


  // METHODS ---

  // Generate simple random ID
  String _genId() {
    return Random().nextInt(9999999).toString();
  }

  /// Create new record
  Future<MockRecord<T>> create(T data) {
    final id = _genId();
    final record = MockRecord(id: id, data: data);
    _store[id] = record;
    _controller.add(_store.values.toList());
     
     printTest();

    return Future.value(record); 
  }

  /// Get record by ID
  Future<MockRecord<T>?> get(String id) {
    return Future.value(_store[id]);
  }

  /// Update record
  Future<MockRecord<T>?> update(String id, T newData) {
    if (!_store.containsKey(id)) return Future.value(null);

    final updated = _store[id]!.copyWith(data: newData);
    _store[id] = updated;
    _controller.add(_store.values.toList());
    return Future.value(updated);
  }

  /// Delete record
  Future<bool> delete(String id) {
    final removed = _store.remove(id);
    _controller.add(_store.values.toList());
    return Future.value(removed != null);
  }

  /// List all records
  Future<List<MockRecord<T>>> getAll() {
    return Future.value(_store.values.toList());
  }


  // --------------------------------------------------
  // 👉 TEST METHOD — PRINT ALL RECORDS
  // --------------------------------------------------
  void printTest() {
    if (_store.isEmpty) {
      print("[MockCollection] (empty)");
      return;
    }

    print("===== MockCollection Records =====");
    for (final record in _store.values) {
      print("ID: ${record.id} | DATA: ${record.data}");
    }
    print("==================================");
  }

}
