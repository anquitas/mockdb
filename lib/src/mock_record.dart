



// CLASS DEFINITION ---
class MockRecord<T> {

  // PROPERTIES ---
  final String id;
  final T data;


  // CONSTRUCTORS ---
  MockRecord({required this.id, required this.data});


  // METHODS ---
  MockRecord<T> copyWith({String? id, T? data}) {
    return MockRecord(
      id: id ?? this.id,
      data: data ?? this.data,
    );
  } // M: MockRecord<T>


} // Cl: MockRecord<T>
