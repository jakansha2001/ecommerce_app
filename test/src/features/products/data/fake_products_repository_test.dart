import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductsRepository = FakeProductsRepository(addDelay: false);
  group('Fake Products Repository Tests', () {
    test('getProductsList return global list', () {
      final productsRepository = FakeProductsRepository();
      expect(productsRepository.getProductsList(), kTestProducts);
    });

// Test case where we get the product which has a matching id
    test('getProduct("1") return first product from the list', () {
      //final productsRepository = FakeProductsRepository();
      final productsRepository = makeProductsRepository;
      expect(productsRepository.getProduct('1'), kTestProducts[0]);
    });

// // Test case where there is no match id (should return null)
//   test('getProduct("100") return null: no matching id',
//       // however, the firstwhere method documents that
//       //If no element satisfies [test],
//       //the result of invoking the [orElse] function is returned.
//       //If [orElse] is omitted, it defaults to throwing a [StateError].
//       // Now since our function doesn't have any orElse parameter, it defaults to throw StateError so we need to expect that.
//       () {
//     final productsRepository = FakeProductsRepository();
//     //expect(productsRepository.getProduct('100'), null);
//     expect(
//       // This expresssion [productsRepository.getProduct('100')] is evaluated immediately before passing as an argument to the expect method.
//       // So if there is any method that is expected to throw any error then we should put the method in closure.
//       // Doing this will ensure that getProduct method is only executed when expect meethod is called.
//       // This will give it the chance to catch the error and match it with the expected value.
//       () => productsRepository.getProduct('100'),
//       throwsStateError,
//     );
//   });

    /// Since the above test is not working as it should (i.e. return null), we re-write the getProduct function. Now test function:
    test('getProduct("100") return null', () {
      //final productsRepository = FakeProductsRepository();
      final productsRepository = makeProductsRepository;
      expect(
        // no closure needed as we now have a expected value null rather than exception
        productsRepository.getProduct('100'),
        null,
      );
    });

// We will need to use async and await as the method we are testing returns Future.
    test('fetchProductsList returns global list', () async {
      //final productsRepository = FakeProductsRepository();
      final productsRepository = makeProductsRepository;
      expect(await productsRepository.fetchProductsList(), kTestProducts);
    });

    test('watchProductsList emits global list', () {
      //final productsRepository = FakeProductsRepository();
      final productsRepository = makeProductsRepository;
      expect(
        productsRepository.watchProductsList(),
        // expected values needs to be a stream matcher such as emits()!
        emits(kTestProducts),
      );
    });
    test('watchProduct("1") emits first product from the list', () {
      //final productsRepository = FakeProductsRepository();
      final productsRepository = makeProductsRepository;
      expect(productsRepository.watchProduct('1'), emits(kTestProducts[0]));
    });
    test('watchProduct("100") emits null', () {
      //final productsRepository = FakeProductsRepository();
      final productsRepository = makeProductsRepository;
      expect(productsRepository.watchProduct('100'), emits(null));
    });
  });
}
