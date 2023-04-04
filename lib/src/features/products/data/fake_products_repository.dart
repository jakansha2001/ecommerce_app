import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Singleton Class (Should not use it a lot as it makes our widgets hard to test)
class FakeProductsRepository {
  // FakeProductsRepository._(); //private constructor (Can have only 1 instance throughout)
  // static FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _products = kTestProducts;
  // synchronous method
  List<Product> getProductsList() {
    return _products;
  }

// synchronous method
  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  /// Backend is REST API? Method should return a Future.
  Future<List<Product>> fetchProductsList() async {
    // Methods returning a Future will begin with fetch
    await Future.delayed(
      const Duration(
        seconds:
            1, // Adding delay to test the loading state in products_grid.dart
      ),
    );
    // throw Exception('Connection Failed'); // Throwing Exception to test the error state in products_grid.dart
    return Future.value(_products); // Future that returns value immediately.
  }

  // Backend supports REALTIME updates e.g. FIREBASE? Method should return a Stream. Streams can emit multiple data over time.
  /// watchProductsList is not an async method. So we will convert this into a stream generator by using async*
  Stream<List<Product>> watchProductsList() async* {
    // Methods returning a Stream will begin with watch
    await Future.delayed(
      const Duration(
        seconds:
            1, // Adding delay to test the loading state in products_grid.dart
      ),
    );
    yield _products; // This is done because this method is not an asynchronous method
    // return Stream.value(_products); //  Stream that returns only 1 value
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList()
        .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
  // return FakeProductsRepository.instance;
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  // debugPrint('Created productsListStreamProvider');
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductsList();
});

/// family modifier (used to pass a runtime argument to a provider)

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  // debugPrint('Created productProvider with id: $id');
  // ref.onDispose(() => debugPrint('disposed productProvider'));
  // final link = ref.keepAlive();
  // Timer(
  //     const Duration(seconds: 10),
  //     () => link
  //         .close()); //KeepAliveLink + Timer allow us to implement a "cache with timeout" policy
  // useful when we have a list of items that we want to cache for a certain period of time.
  /// autoDispose will dispose the provider immediately but this should not be the case, everytime new stream connection will be established
  /// and will cost us so daata caching option will help

  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
});
