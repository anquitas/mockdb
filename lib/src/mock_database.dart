


// IMPORTS ---
import 'package:mockdb/mockdb.dart';




// CLASS DEFINITION ---

class MockDB {
  

  // SINGLETON INSTANCE --- 
  static final MockDB instance = MockDB._internal();


  // CONSTRUCTORS ---
  MockDB._internal();


  // DATABASE AREA --- 
  final Map<String, MockCollection> _collections = {};



  // either returns a collection or creates if it does not exists
  MockCollection<T> collection<T>(String name) {

    if (!_collections.containsKey(name)) {
      _collections[name] = MockCollection<T>();
    }
    return _collections[name] as MockCollection<T>;

  } // Me: collection


} // class
