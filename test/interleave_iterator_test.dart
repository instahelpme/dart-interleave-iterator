import 'package:interleave_iterator/interleave_iterator.dart';
import 'package:test/test.dart';

void main() {
  group('interleave', () {
    test('inserts separator between elements', () {
      expect([1, 2, 3].interleave(5).toList(), [1, 5, 2, 5, 3]);
    });

    test('reuses the same separator instance', () {
      final sep = Object();
      final result = <Object>[1, 2, 3].interleave(sep).toList();
      expect(identical(result[1], result[3]), true);
    });

    test('empty list produces no output', () {
      expect([].interleave(0).toList(), isEmpty);
    });

    test('single element produces no separator', () {
      expect([42].interleave(0).toList(), [42]);
    });
  });

  group('interleaveFactory', () {
    test('inserts separator between elements', () {
      expect([1, 2, 3].interleaveFactory(() => 5).toList(), [1, 5, 2, 5, 3]);
    });

    // Factory should be called once per gap, never reusing objects.
    test('calls factory once per gap with distinct instances', () {
      final input = <Object>[1, 2, 3];
      int called = 0;
      final result = input.interleaveFactory(() {
        called += 1;
        return Object();
      }).toList();

      expect(called, 2);
      expect(result.length, 5);
      expect(result[0], 1);
      expect(result[1] is int, false);
      expect(result[2], 2);
      expect(result[3] is int, false);
      expect(result[4], 3);
      expect(identical(result[1], result[3]), false);
    });

    test('empty list produces no output', () {
      expect([].interleaveFactory(() => 0).toList(), isEmpty);
    });

    test('single element produces no separator', () {
      expect([42].interleaveFactory(() => 0).toList(), [42]);
    });
  });
}
