import 'package:interleave_iterator/interleave_iterator.dart';

void main() {
  // interleave: insert the same separator value between every pair of elements.
  final numbers = [1, 2, 3, 4, 5].interleave(0).toList();
  print('Numbers with 0 separator: $numbers');
  // [1, 0, 2, 0, 3, 0, 4, 0, 5]

  final words = ['one', 'two', 'three'].interleave('|').toList();
  print('Words with | separator:   $words');
  // [one, |, two, |, three]

  // Edge cases: empty and single-element iterables produce no separator.
  print('Empty list:               ${[].interleave(0).toList()}');
  print('Single element:           ${[42].interleave(0).toList()}');

  // interleaveFactory: the factory is called once per gap, so each separator
  // is a distinct object — handy for Flutter widgets that must not be reused.
  var separatorCount = 0;
  final counted = ['a', 'b', 'c'].interleaveFactory(() {
    separatorCount++;
    return 'sep$separatorCount';
  }).toList();
  print('Unique separators:        $counted');
  // [a, sep1, b, sep2, c]
}
