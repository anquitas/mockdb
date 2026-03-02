// * USE -- to act as a return object holding records returned, useful getters, methods

// --- IMPORTS ---

import 'mock_record.dart';

// --- CLASS DEFINITION ---

class MockResult<T> {
  // --- PROPS ---

  // TODO info about collection, request, response like time, error, status etc

  final List<MockRecord<T>> records; // ~ REAL DATA STORED INSIDE CLASS

  // --- GETTERS ---

  // ~ META INFO GETTERS

  // the number of records found or affected
  int get count => records.length;

  // true if records are empty
  bool get isEmpty => records.isEmpty;

  // ~ DATA GETTERS

  // the list of data, instead of MockRecord
  List<T> get data => records.map((r) => r.data).toList();

  // data of the first record, null if empty
  T? get firstData => records.isNotEmpty ? records.first.data : null;

  // data of the first record, null if empty
  T? get lastData => records.isNotEmpty ? records.last.data : null;

  // ~ RECORD GETTERS

  // data of the first record, null if empty
  MockRecord<T>? get first => records.isNotEmpty ? records.first : null;

  // data of the first record, null if empty
  MockRecord<T>? get last => records.isNotEmpty ? records.last : null;

  // ~ RECORD ID GETTERS

  // the ID of the first record (or null if empty).
  String? get firstId => records.isNotEmpty ? records.first.id : null;

  // the ID of the last record (or null if empty).
  String? get lastId => records.isNotEmpty ? records.last.id : null;

  // --- CONSTRUCTORS ---

  MockResult(this.records); // ~ standart constructor

  MockResult.empty() : records = []; // ~ empty data constructor

  // --- METHODS ---

  // TODO add filtering methods such as: sortBy, limit etc

  // --- METHOD OVERRIDES ---
  @override
  String toString() => '+ [QueryResult] type: $T, count: $count';
}
