import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeAuthRepository Tests', () {
    final testEmail = 'test@test.com';
    final testPassword = '1234';
    final testUser = AppUser(uid: testEmail.split('').reversed.join(), email: testEmail);
    FakeAuthRepository makeAuthRepository = FakeAuthRepository(addDelay: false);
    // Test case to check current user is null when we create FakeAuthRepository
    test('current user is null', () {
      //final authRepository = FakeAuthRepository();
      final authRepository = makeAuthRepository;
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('current user is not null after sign in', () async {
      final authRepository = makeAuthRepository;
      // first let's sign in then expect(actual,matcher)
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(
        authRepository.currentUser,
        testUser,
      );
      // The latest  value emitted by authStateChanges() Stream is always te value inside the current user
      expect(
        authRepository.authStateChanges(),
        emits(testUser),
      );
    });

    test('current user is not null after registration', () async {
      final authRepository = makeAuthRepository;
      // first let's sign in then expect(actual,matcher)
      await authRepository.createUserWithEmailAndPassword(testEmail, testPassword);
      expect(
        authRepository.currentUser,
        testUser,
      );
      // The latest  value emitted by authStateChanges() stream is always te value inside the current user
      expect(
        authRepository.authStateChanges(),
        emits(testUser),
      );
    });

    // test('current user is null after sign out', () async {
    //   final authRepository = makeAuthRepository;
    //   //  Signing in the user to  make sure we  get a non null user
    //   await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
    //   // Calling this first as the authhStateChanges takes the latest value then after sign in we will be expecting testUser
    //   // and after sign out we will expect null.
    //   // REMEBER: STREAMS EMIT VALUES OVER TIME
    //   expect(
    //     authRepository.authStateChanges(),
    //     //emits(null),
    //     emitsInOrder([
    //       testUser, // expects  to emit after signin
    //       null, // expects  to emit after sign out
    //     ]),
    //   );
    //   // Signing out
    //   await authRepository.signOut();
    //   expect(
    //     authRepository.currentUser,
    //     null,
    //   );
    // });
    test('current user is null after sign out', () async {
      final authRepository = makeAuthRepository;
      //  Signing in the user to  make sure we  get a non null user
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(
        authRepository.currentUser,
        testUser,
      );
      // The latest value emitted by authStateChanges() stream is always the value inside the current user
      expect(
        authRepository.authStateChanges(),
        emits(testUser),
      );
      // Signing out
      await authRepository.signOut();
      expect(
        authRepository.currentUser,
        null,
      );
      expect(
        authRepository.authStateChanges(),
        emits(null),
      );
    });

    test('sign in after dispose throws error', () {
      final authRepository = makeAuthRepository;
      authRepository.dispose();
      expect(
        () => authRepository.signInWithEmailAndPassword(testEmail, testPassword),
        throwsStateError,
      );
    });
  });
}
