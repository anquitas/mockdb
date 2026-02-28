// CLASS DEFINITION ---
class MockRecord<T> {
  // PROPERTIES ---
  final String id;
  final T data;
  final DateTime createdAt;

  // CONSTRUCTORS ---
  MockRecord({required this.id, required this.data, required this.createdAt});

  // METHODS ---
  MockRecord<T> copyWith({String? id, T? data, DateTime? createdAt}) {
    return MockRecord(
      id: id ?? this.id,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  } // M: MockRecord<T>
} // Cl: MockRecord<T>
