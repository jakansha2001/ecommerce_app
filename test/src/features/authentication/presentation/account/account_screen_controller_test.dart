import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

/// What do we want to test?
/// 1. When we create the controller, the state is AsyncValue.data
/// 2. When sign out succeeds, the state is AsyncValue.data
/// 3. When sign out fails, the state is AsyncValue.error

// By default, mocks implement all methods by returning null.

void main() {
  // use setup() inside main() to run for all tests inside main
  late MockAuthRepository authRepository;
  late AccountScreenController controller;

  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });
  group('Account Screen Controller Tests', () {
    // use setup() inside group() to run for all tests inside group
    // test('initial state is AsyncValue.data', () {
    //   final authRepository = FakeAuthRepository();
    //   final controller = AccountScreenController(authRepository: authRepository);
    //   expect(
    //     /// The member 'state' can only be used within instance members of subclasses of 'package:state_notifier/state_notifier.dart'.
    //     /// Instead use debugState. It gives the value that  was last set.
    //     //controller.state,
    //     controller.debugState,
    //     //const AsyncValue<void>.data(null),
    //     const AsyncData<void>(null),
    //   );
    test('initial state is AsyncValue.data', () {
      // final authRepository = MockAuthRepository();
      // final controller = AccountScreenController(authRepository: authRepository);
      verifyNever(authRepository.signOut);
      expect(
        /// The member 'state' can only be used within instance members of subclasses of 'package:state_notifier/state_notifier.dart'.
        /// Instead use debugState.
        //controller.state,
        controller.debugState,
        //const AsyncValue<void>.data(null),
        const AsyncData<void>(null),
      );
    });

    /// A mock auth repository will let us:
    /// - decide if the signOut() method should succeed or throw an exception
    /// - check if signOut() is actually called
    test(
      'sign out successs',
      () async {
        // setup
        //final authRepository = MockAuthRepository();

        /// stubbing the signOut()
        when(authRepository.signOut).thenAnswer((_) => Future.value());
        //final controller = AccountScreenController(authRepository: authRepository);

        /// Since emitsInOder() is an asynchronous stream matcher we should use expectLater().
        /// It is same as expect but returns a Future.
        expectLater(
            controller.stream,
            emitsInOrder(const [
              AsyncLoading<void>(),
              AsyncData<void>(null),
            ]));

        // run
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
        // expect(
        //   controller.debugState,
        //   const AsyncData<void>(null),
        // );
        /// We want to test how state changes over time (loading, success, failure)
        /// But this can't be accomplished by checking the debugState
        /// Solution: contoller.stream (defined by StateNotifier class)
        ///
        // expect(
        //     controller.stream,
        //     emitsInOrder(const [
        //       AsyncLoading<void>(),
        //       AsyncData<void>(null),
        //     ]));
      },

      /// A shorter test timeout ensures that when our tests hang, they fail quickly.
      timeout: const Timeout(Duration(milliseconds: 500)),
    );

    test(
      'sign out failure',
      () async {
        // setup
        //final authRepository = MockAuthRepository();
        final exception = Exception('Connection Failed!');

        /// stubbing the signOut()
        when(authRepository.signOut).thenThrow(exception);
        //final controller = AccountScreenController(authRepository: authRepository);

        expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),

              /// The below can't work because we need a stacktrace so to use .hasError we need to use a predicate as we are inside expectLater()
              // AsyncError<void>(exception),
              /// Predicates give us a fine grained contol over the values we want to test
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              })
            ]));
        // run
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
  });
}
