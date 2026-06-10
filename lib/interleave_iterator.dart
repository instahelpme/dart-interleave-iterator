/// Provides the [Interleaver] extension, which adds [Interleaver.interleave]
/// and [Interleaver.interleaveFactory] methods to any [Iterable].
///
/// Interleaving inserts a separator element between every pair of adjacent
/// elements, without adding one before the first or after the last element.
///
/// Use [Interleaver.interleave] when a single shared separator value is enough:
/// ```dart
/// import 'package:interleave_iterator/interleave_iterator.dart';
///
/// [1, 2, 3].interleave(0).toList(); // [1, 0, 2, 0, 3]
/// ```
///
/// Use [Interleaver.interleaveFactory] when each separator must be a distinct
/// instance (e.g. a Flutter widget that cannot be reused):
/// ```dart
/// tiles.interleaveFactory(() => const Divider()).toList();
/// ```
library;

export 'src/interleave_iterator_base.dart';
