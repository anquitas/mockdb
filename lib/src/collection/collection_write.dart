// * USE --  mixin part for the write operation to change record or collection

// --- IMPORTS ---
part of 'collection_base.dart';

// --- CLASS DEFINITION ---

mixin CollectionWrite<T> on CollectionBase<T>  {
  // // --- PROPS ---
  // // --- GETTERS ---
  // // --- CONSTRUCTORS ---
  // --- CREATE METHODS ---
  Future<MockResult<T>> create (T data) async {
    // create record meta info
    final now = DateTime.now();
    final id = generateId();
    // create the record object itself
    final record = MockRecord(id: id, data: data, createdAt: now, updatedAt: now);
    // store the record object inside collection
    _store[id] = record;
    // ? sth to with stream
    notify();
    // return the record wraped with result data
    return MockResult([record]);
  } // * create()

  // --- UPDATE METHODS ---

  // ~ update by id
  Future<MockResult<T>> updateById (String id, T newData) async {
    // get the record that ll be updated
    final existing = _store[id];
    // check if it exists, if not return empty result
    if (existing == null) return MockResult.empty();
    // update the result
    final updated = existing.copyWith(
      data: newData,
      updatedAt: DateTime.now()
    );
    // add the updated result back in the store to same place
    _store[id] = updated;
    // do this thing for some reason
    notify();
    // return the updated result
    return MockResult([updated]);
  }

  // ~ update one by callback
  Future<MockResult> updateOne (MockCriteria criteria, T newData) async {
    try {
      // find the first entry that maches 
      // * entry returns both left & right side of the map 
      // ! can be changed to value but to use update by id whole entry is chosen
      final entry = _store.entries.firstWhere( (entry) => criteria(entry.value.data));
      // update the record
      return await updateById(entry.key, newData);
    } catch (_) {
      // if no record matches criteria return an empty record
      return MockResult.empty();
    }
  }

  // ~ update many by callback
  Future<MockResult> updateMany (MockCriteria criteria, T newData) async {

      // temp list to hold records to be updated
      final List<MockRecord<T>> updatedRecords = [];
      // get the update time
      final now = DateTime.now();

      // 1. get matching targets
      final targets = _store.values.where((record) => criteria(record.data)).toList();
      
      if (targets.isEmpty) return MockResult.empty();

      // 2. process the updates
      for (var record in targets) {
        final updated = record.copyWith(data: newData, updatedAt: now);

        // save back
        _store[record.id] = updated;
        updatedRecords.add(updated);
      }

      // 3. notify the listenerts // ! sth to do with streams and reactivity
      notify();

      // return the updated records
      return MockResult(updatedRecords); 
  }


  // --- DELETE METHODS ---

  // ~ delete by id
  Future<MockResult<T>> deleteById (String id) async {
    // remove the item by key from the map
    final removed = _store.remove(id);

    // if element is removed return the removed record
    if (removed != null) {
      notify();
      return MockResult([removed]);
    }
    // if no element found and removed return empty record
    return MockResult.empty();
  }
  // ~ delete one by callback
  Future<MockResult<T>> deleteOne (MockCriteria criteria) async {
    try {
      final entry = _store.entries.firstWhere((e) => criteria(e.value.data));
      return await deleteById(entry.key);
    } catch (_) {
      return MockResult.empty();
    }
  }
  // ~ delete many by callback
  Future<MockResult<T>> deleteMany (MockCriteria criteria) async {
    final targets = _store.entries.where((entry) => criteria(entry.value.data)).toList();

    for (var entry in targets) {
      _store.remove(entry.key);
    }

    if (targets.isNotEmpty) notify();
    return MockResult(targets.map((entry) => entry.value).toList());
  }
}