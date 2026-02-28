
import 'package:mockdb/mockdb.dart';

class MockQueryResult<T> {
  final List<MockRecord<T>> records;

  MockQueryResult(this.records);

  /// Get ONLY the raw data (unpacked from the MockRecord)
  List<T> get data => records.map((r) => r.data).toList();

  /// Simple Sort helper
  MockQueryResult<T> sortBy(int Function(MockRecord<T> a, MockRecord<T> b) compare) {
    final sorted = List<MockRecord<T>>.from(records)..sort(compare);
    return MockQueryResult(sorted);
  }

  /// Limit helper
  MockQueryResult<T> limit(int count) {
    return MockQueryResult(records.take(count).toList());
  }

  /// Convenience for getting the first item
  T? get firstData => records.isNotEmpty ? records.first.data : null;

  int get count => records.length;
}