// * USE -- mixin part for the read operation to search for records

// --- IMPORTS ---
part of 'collection_base.dart';

// --- CLASS DEFINITION ---

mixin CollectionRead<T> on CollectionBase<T> {
  // // --- PROPS ---
  // // --- GETTERS ---
  // // --- CONSTRUCTORS ---
  // --- READ METHODS ---

  // ? a question about multiple conditions on search
  // TODO search about implementing query methods
  // ~ GENERAL MULTI SEARCH via boolean callback
  Future<MockResult<T>> findMany([MockCriteria? criteria]) async {
    // if there is store the filtering function,if not a totology funciton
    final filter = criteria ?? (data) => true;
    // TODO look into if this is the most efficient
    // * value returns just the right side of the map
    final results = _store.values
        .where((record) => filter(record.data))
        .toList();
    // return the results // ? what would it return if no result found
    return MockResult(results);
  } // * findMany()

  // ~ SINGLE SEARCH via record id
  Future<MockResult<T>> findById(String id) async {
    final record = _store[id];
    // ? this return seems to keep in mind to return empty list
    return MockResult(record != null ? [record] : []);
    // ? might be a better and cleaner return
    // return record != null ? MockResult([record]): MockResult.empty();
  } // * findById()

  // ~  SEARCH MULTIPLE via

  // Future<MockResult<T>> findOne(MockCriteria criteria) async {
  //   // ? what is cast?
  //   final record = _store.values.cast<MockRecord<T>?>().firstWhere(
  //     (r) => r != null && criteria(r.data),
  //     orElse: () => null,
  //   );

  //   if (record == null) {
  //     return MockResult.empty();
  //   }

  //   return MockResult([record]);
  // } // * findOne()

  Future<MockResult<T>> findOne(MockCriteria criteria) async {
    try {
      // search for the record by condition callback fucntion
      final record = _store.values.firstWhere((record) => criteria(record.data));
      // if found return the record
      return MockResult([record]);
    } on StateError {
      // if not found return empty record
      return MockResult.empty();
    } catch (e) {
      rethrow; // for other kind of errors
    }
  } // * findOne()

}
