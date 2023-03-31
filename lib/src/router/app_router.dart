import 'package:ecommerce_app/src/features/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  /// tells GoRouter which location to use when the app starts
  initialLocation: '/',

  /// Enable Debugging Logs for GoRouter [all the navigation events will be logged to the debug console]
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const ProductsListScreen(),

        /// Nested routes will work
        routes: [
          GoRoute(
            /// using "/cart" will throw error as the path that GoRouter will
            /// now understand is '/' + '/cart' = '//cart' which is not available.
            ///
            /// Instead the path should be '/' +  'cart' = '/cart'
            ///
            //path: '/cart',
            path: 'cart',
            builder: (context, state) => const ShoppingCartScreen(),
          )
        ]),

    /// This approach will disable going back (icon) from /cart screen to / (home).
    /// However you can go back by changing the path from /cart screen to / (home).
    // GoRoute(
    //   path: '/cart',
    //   builder: (context, state) => const ShoppingCartScreen(),
    // ),
  ],
);
