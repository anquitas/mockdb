


// IMPORTS ---
// import 'package:mockdb/mockdb.dart';

// lib/src/mock_db.dart
// --- IMPORTS ---
import 'collection/mock_collection.dart';


// --- CLASS DEFINITION ---

class MockDB {
  
  // --- SINGLETON INSTANCE --- 
  static final MockDB instance = MockDB._internal();


  // --- CONSTRUCTORS ---
  MockDB._internal(); // ~ private constructor


  // --- DATABASE AREA --- 
  final Map<String, MockCollection<dynamic>> _collections = {};


  // --- METHODS ---
  // ~ either returns a collection or creates if it does not exists
  MockCollection<T> collection<T>(String name) {

    if (!_collections.containsKey(name)) {
      _collections[name] = MockCollection<T>(name);
    }
    return _collections[name] as MockCollection<T>;

  } // ~ MockCollection()


} // class
