import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// What do we want to test?
/// 1. When we create the controller, the state is AsyncValue.data
/// 2. When sign out succeeds, the state is AsyncValue.data
/// 3. When sign out fails, the state is AsyncValue.error

// By default, mocks implement all methods by returning null.
class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  group('Account Screen Controller Tests', () {
    // test('initial state is AsyncValue.data', () {
    //   final authRepository = FakeAuthRepository();
    //   final controller = AccountScreenController(authRepository: authRepository);
    //   expect(
    //     /// The member 'state' can only be used within instance members of subclasses of 'package:state_notifier/state_notifier.dart'.
    //     /// Instead use debugState.
    //     //controller.state,
    //     controller.debugState,
    //     //const AsyncValue<void>.data(null),
    //     const AsyncData<void>(null),
    //   );
    test('initial state is AsyncValue.data', () {
      final authRepository = MockAuthRepository();
      final controller = AccountScreenController(authRepository: authRepository);
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
    test('sign out successs', () async {
      // setup
      final authRepository = MockAuthRepository();

      /// stubbing the signOut()
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      final controller = AccountScreenController(authRepository: authRepository);
      // run
      await controller.signOut();
      // verify
      verify(authRepository.signOut).called(1);
      expect(
        controller.debugState,
        const AsyncData<void>(null),
      );
    });

    test('sign out failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection Failed!');

      /// stubbing the signOut()
      when(authRepository.signOut).thenThrow(exception);
      final controller = AccountScreenController(authRepository: authRepository);
      // run
      await controller.signOut();
      // verify
      verify(authRepository.signOut).called(1);
      expect(
        controller.debugState.hasError,
        /// Can't  use this  because it also expects stackTrace as an argument which we can't create explicitly
        // const AsyncError<void>(null),
        true,
      );
      /// isA<Type> is a generic type matcher. It is useful to check if a value is of certain type.
      expect(controller.debugState, isA<AsyncError>());
    });
  });
}
