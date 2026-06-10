/// Extension that adds [Interleaver.interleave] and
/// [Interleaver.interleaveFactory] to any [Iterable].
///
/// Interleaving inserts a separator element between every pair of adjacent
/// elements, without adding one before the first or after the last element.
/// The resulting sequence for `[a, b, c]` is `[a, sep, b, sep, c]`.
extension Interleaver<T> on Iterable<T> {
  /// Returns a lazy iterable that inserts [separator] between every pair of
  /// adjacent elements.
  ///
  /// The same [separator] value is reused for every gap. If you need a
  /// distinct instance per gap (e.g. a Flutter widget that must not be
  /// reused), use [interleaveFactory] instead.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].interleave(0).toList(); // [1, 0, 2, 0, 3]
  /// ```
  ///
  /// The returned iterable is lazy. If the source contains fewer than two
  /// elements, no separator is produced.
  Iterable<T> interleave(T separator) => interleaveFactory(() => separator);

  /// Returns a lazy iterable that inserts a separator between every pair of
  /// adjacent elements, using [separatorFactory] to produce each one.
  ///
  /// [separatorFactory] is called once per gap, so it can return a fresh
  /// instance each time — useful when the separator is a widget that must not
  /// be reused.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].interleaveFactory(() => 0).toList(); // [1, 0, 2, 0, 3]
  /// ```
  ///
  /// The returned iterable is lazy: [separatorFactory] is not invoked until
  /// the iterable is consumed. If the source contains fewer than two elements,
  /// no separator is produced.
  Iterable<T> interleaveFactory(T Function() separatorFactory) {
    return Iterable.withIterator(
      () => _InterleaveIterator(iterator, separatorFactory),
    );
  }
}

/// Iterator that drives the interleaving logic for [Interleaver.interleave].
///
/// The iterator alternates between yielding elements from [_input] and
/// yielding values produced by [_separator]. It tracks which kind is due next
/// via [_currentIsSeparator] and pre-fetches the upcoming input element into
/// [_current] so that separator calls remain independent of the underlying
/// iterator position.
class _InterleaveIterator<T> implements Iterator<T> {
  final Iterator<T> _input;
  final T Function() _separator;

  /// Whether the value for the current iteration step should come from
  /// [_separator] (`true`) or [_current] (`false`).
  bool _currentIsSeparator;

  /// Whether the underlying [_input] iterator still has an unconsumed element.
  bool _inputHasNext;

  /// The pre-fetched element from [_input] to be yielded on the next
  /// non-separator step.
  late T _current;

  _InterleaveIterator(this._input, this._separator)
    : _currentIsSeparator = true,
      _inputHasNext = _input.moveNext() {
    if (_inputHasNext) {
      _current = _input.current;
    }
  }

  @override
  T get current {
    final current = switch (_currentIsSeparator) {
      true => _separator(),
      false => _current,
    };
    return current;
  }

  /// Advances the iterator to the next element.
  ///
  /// On a separator step: flips to element mode and advances [_input] so the
  /// next input value is ready, then returns `true` unconditionally (a
  /// separator is always followed by at least one more element).
  ///
  /// On an element step: stores [_input.current] into [_current], flips to
  /// separator mode, and returns `false` only when [_input] is exhausted
  /// (i.e. the element just yielded was the last one and no separator follows).
  @override
  bool moveNext() {
    switch (_currentIsSeparator) {
      case true:
        if (!_inputHasNext) {
          // empty input list
          return false;
        }
        _currentIsSeparator = false;
        _inputHasNext = _input.moveNext();
        return true;
      case false:
        _currentIsSeparator = true;
        if (_inputHasNext) {
          _current = _input.current;
        }
        return _inputHasNext;
    }
  }
}
