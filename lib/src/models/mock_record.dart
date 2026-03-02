// * USE -- a wrapper around data, data item for collections in DBS

// --- IMPORTS ---

// --- CLASS DEFINITION ---

class MockRecord<T> {
  // --- PROPS ---

  final String id;
  final T data;
  final DateTime createrAt;
  final DateTime updatedAt;

  // --- CONSTRUCTORS ---

  MockRecord({
    required this.id,
    required this.data,
    required this.createrAt,
    required this.updatedAt,
  });

  // --- METHODS ---

  // allow for easy updating of data while keeping same ID.
  MockRecord<T> copyWith({T? data}) {
    return MockRecord<T>(
      id: id,
      data: data ?? this.data,
      createrAt: createrAt,
      updatedAt: updatedAt,
    );
  }

  // --- METHOD OVERRIDES ---

  @override
  String toString() => 'Record(id: $id, data: $data)';
}
