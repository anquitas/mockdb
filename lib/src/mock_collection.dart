// USE --> 
 

// IMPORTS ---
import 'dart:async'; // async operations
import 'package:mockdb/mockdb.dart'; // ~ exposing db class
import 'package:uuid/uuid.dart'; // to create unique id



// CLASS DEFINITION ---

class MockCollection<T> {

  // PROPERTIES ---
  final Map<String, MockRecord<T>> _store = {}; // ~ DB object to hold records

  final _uuidGenerator = const Uuid(); // Instantiate the UUID generator

  final _controller = StreamController<List<MockRecord<T>>>.broadcast();
  

  /// Stream for listeners
  Stream<List<MockRecord<T>>> get stream => _controller.stream;


  // METHODS ---

  // ~ Generate simple random ID
  String _genId() {
    return _uuidGenerator.v4();
  }

  // ~ Create new record
  Future<MockRecord<T>> create(T data) {
    final id = _genId();
    final createdAt = DateTime.now().toUtc();
    final record = MockRecord(id: id, data: data, createdAt: createdAt);
    _store[id] = record;
    _controller.add(_store.values.toList());
     
     printTest();

    return Future.value(record); 
  }

  // ~ Get record by ID
  Future<MockRecord<T>?> get(String id) {
    return Future.value(_store[id]);
  }

  // ~ Update record
  Future<MockRecord<T>?> update(String id, T newData) {
    if (!_store.containsKey(id)) return Future.value(null);

    final updated = _store[id]!.copyWith(data: newData);
    _store[id] = updated;
    _controller.add(_store.values.toList());
    return Future.value(updated);
  }

  // ~ Delete record
  Future<bool> delete(String id) {
    final removed = _store.remove(id);
    _controller.add(_store.values.toList());
    return Future.value(removed != null);
  }

  //~  List all records
  Future<List<MockRecord<T>>> getAll() {
    return Future.value(_store.values.toList());
  }


  // 👉 TEST METHOD — PRINT ALL RECORDS
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
