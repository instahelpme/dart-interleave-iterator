# interleave_iterator

A Dart package that adds `interleave` and `interleaveFactory` extensions method to any `Iterable`.
Interleaving inserts a separator element between every pair of adjacent elements,
without adding one before the first or after the last.

## Usage

```dart
import 'package:interleave_iterator/interleave_iterator.dart';

// interleave: insert the same separator value between every pair of elements.
[1, 2, 3].interleave(0).toList(); // [1, 0, 2, 0, 3]

// interleaveFactory: the factory is called once per gap, producing a fresh
// instance each time — useful for Flutter widgets that must not be reused.
final widgets = tiles.interleaveFactory(() => const Divider()).toList();
```

The returned iterable is lazy: the factory is not called until the iterable
is consumed. If the source has fewer than two elements, no separator is produced.

## Edge cases

| Input        | Output       |
|--------------|--------------|
| `[]`         | `[]`         |
| `[x]`        | `[x]`        |
| `[x, y]`     | `[x, sep, y]`|
| `[x, y, z]`  | `[x, sep, y, sep, z]` |

## Installing

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  interleave_iterator: ^0.1.0
```
