import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  /// Always declare StateNotifier with a type (in this case, AsyncValue<void>)
  /// Always pass an initial value in the constructor

// AsyncValue<void>.data(null) means not loading
  AccountScreenController({required this.authRepository}) : super(const AsyncValue.data(null));
  // AsyncValue.data() is same as AsyncData

  final FakeAuthRepository authRepository;

  //Future<bool> signOut() async {
  Future<void> signOut() async {
    // try {
    //   // set state to loading
    //   state = const AsyncValue<void>.loading();
    //   // call signOut()
    //   await authRepository.signOut();
    //   // if success, set state to data
    //   state = const AsyncValue<void>.data(null);
    //   return true;
    // } catch (e, st) {
    //   // if error, set state to error
    //   state = AsyncValue<void>.error(e, st);
    //   return false;
    // }

    // AsyncValue.loading() is same as AsyncLoading
    // AsyncValue.error() is same as AsyncError
    // AsyncData, AsyncLoading and AsyncError are all subclasses of AsyncValue
    state = const AsyncValue<void>.loading(); // Because we always need to set the state to Loading
    state = await AsyncValue.guard(() => authRepository
        .signOut()); // The 'state' here will contain data or error depending upon whether this future [authRepository.signOut()] succeeds or not
    //return state.hasError == false; // This should be true is state.hasError == false
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider<AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});
