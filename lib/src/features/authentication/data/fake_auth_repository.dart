import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  final _authstate = InMemoryStore<AppUser?>(null);

  /// Stream to check the authentication state of the user and null here means that the user is not authenticated
  Stream<AppUser?> authStateChanges() => _authstate.stream;
  AppUser? get currentUser =>
      _authstate.value; // used to get the current user synchronously

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (currentUser == null) {
      createNewUser(email);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (currentUser == null) {
      createNewUser(email);
    }
  }

  Future<void> signOut() async {
    _authstate.value = null;
  }

  void createNewUser(String email) {
    _authstate.value =
        AppUser(uid: email.split('').reversed.join(), email: email);
  }

  void dispose() => _authstate.close();
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
