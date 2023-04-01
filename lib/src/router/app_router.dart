import 'package:ecommerce_app/src/features/account/account_screen.dart';
import 'package:ecommerce_app/src/features/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  cart,
  orders,
  account,
  signIn,
}

final goRouter = GoRouter(
  /// tells GoRouter which location to use when the app starts
  initialLocation: '/',

  /// Enable Debugging Logs for GoRouter [all the navigation events will be logged to the debug console]
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: '/',

        /// Navigating by route name is better than Navigating by route path.
        /// And using this we can use goNamed() instead of go()
        /// To do this we  will create enumeration as we have a lot different paths.
        // name: 'home',
        name: AppRoute.home.name,
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
            name: AppRoute.cart.name,
            // *Since we are using pageBuilder, we don't need builder which
            // *imposes a default behavior i.e transitioning from right to
            // * left and icon as back arrow
            // builder: (context, state) => const ShoppingCartScreen(),
            pageBuilder: (context, state) => MaterialPage(
              child: const ShoppingCartScreen(),
              key: state.pageKey,

              /// This will ensure that the ShoppingCartScreen transitions
              /// from the bottom and also the icon to close the page, changes
              /// from the default behaviour i.e transitioning from right to
              /// left and icon as back arrow
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            path: 'orders',
            name: AppRoute.orders.name,
            // builder: (context, state) => const OrdersListScreen(),
            pageBuilder: (context, state) => MaterialPage(
              child: const OrdersListScreen(),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            // builder: (context, state) => const AccountScreen(),
            pageBuilder: (context, state) => MaterialPage(
              child: const AccountScreen(),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            // builder: (context, state) => const EmailPasswordSignInScreen(formType: EmailPasswordSignInFormType.signIn,),
            pageBuilder: (context, state) => MaterialPage(
              child: const EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
              key: state.pageKey,
              fullscreenDialog: true,
            ),
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
