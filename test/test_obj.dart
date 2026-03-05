class TestObj {
  static int _counter = 0;

  final String text;
  final int num;

  // Standard constructor with defaults
  TestObj({
    this.text = '',
    this.num = 0,
  });

  /// Static getter that returns current count and then increments it
  static int get nextCount => _counter++;

  /// Named constructor: Uses the static counter for 'num'
  TestObj.inc({this.text = ''}) : num = nextCount;

  static List<TestObj> generate(int count, {String prefix = 'Item'}) {
    return List.generate(
      count, 
      (i) => TestObj.inc(text: '$prefix $i')
    );
  }

  // To reset the counter between tests
  static void reset() => _counter = 0;

  @override
  String toString() => "TEXT: $text -- NUM: $num";
}

