import 'package:rxdart/rxdart.dart';

/// An in-memory store backed by BehaviorSubject that can be used to
/// store the data for all the fake repositories in the app.
class InMemoryStore<T> {
  //InMemoryStore(this._subject);
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  /// The BehaviorSubject that holds the data
  final BehaviorSubject<T> _subject;

  /// The output stream that can be used to listen to the data
  Stream<T> get stream => _subject.stream;

  /// A synchronous getter for the current value
  T get value => _subject.value;

  /// A setter for updating the value
  set value(T value) => _subject.add(value);

  /// Don't forget to call this when done
  void close() => _subject.close();
}

/// One alternative that can be considered is to use the StateNotifier class 
/// that is included with the Riverpod package.

/// By using this, the InMemoryStore class could be implemented as:

// class InMemoryStoreR<T> extends StateNotifier<T> {
//   InMemoryStoreR(T initial) : super(initial);
  /// * StateNotifier already has a `stream` property that can be accessed directly

   // A synchronous getter for the current value
//   T get value => state;
   // A setter for updating the data
//   set value(T value) => state = value;
// }


/// However, this does not work as intended in practice because when you access a 
/// StateNotifier’s stream, it won’t remember the last value, and this causes 
/// the app to hang on a loading UI when widgets register to the corresponding StreamProvider.

/// In other words:

/// a BehaviorSubject’ s stream will remember the last value
/// a StateNotifier’s stream wont