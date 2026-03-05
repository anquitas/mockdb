// * USE -- base file for the mixin class partition

// --- IMPORTS ---
import 'dart:async';
import 'package:uuid/uuid.dart';
// ~ INTERNAL IMPORTS
import '../models/mock_record.dart';
import '../models/mock_result.dart';

// --- PARTS ---
part 'collection_read.dart';
part 'collection_write.dart';

// ---  TYPE DEFINITIONS ---
typedef MockCriteria<T> = bool Function(T data);

// --- CLASS DEFINITION ---

abstract class CollectionBase<T> {
  // --- PROPS ---

  // ~ PRIVATE DATA STORE
  final Map<String, MockRecord<T>> _store = {};

  // ~ STREAM SYSTEM
  final StreamController<List<MockRecord<T>>> _controller =
      StreamController<List<MockRecord<T>>>.broadcast();

  // ~ UTIL
  final _uuid = const Uuid(); // Shared id generator

  // --- METHODS ---

  // ? still not sure what this does tho lol
  void notify() => _controller.add(_store.values.toList());

  String generateId() => _uuid.v4();
}
