// * USE -- a wrapper around data, data item for collections in DBS

// // --- IMPORTS ---

// --- CLASS DEFINITION ---

class MockRecord<T> {
  // --- PROPS ---

  final String id;
  final T data;
  final DateTime createdAt;
  final DateTime updatedAt;

  // --- CONSTRUCTORS ---

  MockRecord({
    required this.id,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  // --- METHODS ---

  // allow for easy updating of data while keeping same ID.
  MockRecord<T> copyWith({T? data, required DateTime updatedAt}) {
    return MockRecord<T>(
      id: id,
      data: data ?? this.data,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // --- METHOD OVERRIDES ---

  @override
  String toString() => 'Record(id: $id, data: $data)';
}
