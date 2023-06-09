import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:go_router/go_router.dart';

/// Shopping cart icon with items count badge
class ShoppingCartIcon extends StatelessWidget {
  const ShoppingCartIcon({super.key});

  // * Keys for testing using find.byKey()
  static const shoppingCartIconKey = Key('shopping-cart');

  @override
  Widget build(BuildContext context) {
    // TODO: Read from data source
    const cartItemsCount = 3;
    return Stack(
      children: [
        Center(
          child: IconButton(
            key: shoppingCartIconKey,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.pushNamed(AppRoute.cart.name),

            /// This will add Shopping Cart Page in the stack rather than going to it so if we hit the
            /// back arrow key then we will be able to see the previous page and not the home page.
            /// With goNamed we were sent back to home page only.
            ///
            //onPressed: () => context.goNamed(AppRoute.cart.name),

            ///
            //onPressed: () => GoRouter.of(context).go('/cart'),
            // *GoRouter introduces a BuildContext Extension.
            // *If we cmd+click on [go] function below, we will be able to see that
            // *we have a GoRouter Helper extension on BuildContext and that
            // *defines all the different methods such as go, goNamed, push, pushNamed and pop.
            /// To save time, we will use this extension
            //onPressed: () => context.go('/cart'),
            // onPressed: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     fullscreenDialog: true,
            //     builder: (_) => const ShoppingCartScreen(),
            //   ),
            // ),
          ),
        ),
        if (cartItemsCount > 0)
          const Positioned(
            top: Sizes.p4,
            right: Sizes.p4,
            child: ShoppingCartIconBadge(itemsCount: cartItemsCount),
          ),
      ],
    );
  }
}

/// Icon badge showing the items count
class ShoppingCartIconBadge extends StatelessWidget {
  const ShoppingCartIconBadge({super.key, required this.itemsCount});
  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.p16,
      height: Sizes.p16,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$itemsCount',
          textAlign: TextAlign.center,
          // * Force textScaleFactor to 1.0 irrespective of the device's
          // * textScaleFactor. This is to prevent the text from growing bigger
          // * than the available space.
          textScaleFactor: 1.0,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
