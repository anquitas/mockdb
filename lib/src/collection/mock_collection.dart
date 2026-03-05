// --- IMPORTS ---
import 'collection_base.dart';

// actual class -- combines Base storage & Read, Write
// --- CLASS DEFINITION ---
class MockCollection<T> extends CollectionBase<T>
    with CollectionRead<T>, CollectionWrite<T> {
  // --- PROPS ---

  final String name;

  // --- CONSTRUCTORS ---

  MockCollection(this.name);

  // // --- METHODS ---
  // can add collection-specific logic -- logging coll access
}
