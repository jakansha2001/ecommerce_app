import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// we should include any parent widgets (usually MaterialApp and ProviderScope for Riverpod-based apps)
  /// that are needed for the widget to work correctly.
  testWidgets('Cancel logout', (tester) async {
    // Render Account Screen programatically
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
    // Find logout text in Account Screen
    final logoutButton = find.text('Logout');
    // expected to find one logout text
    expect(logoutButton, findsOneWidget);
    // tap on Logout button/text
    await tester.tap(logoutButton);
    // This will pump a new frame/screen
    await tester.pump();
    // The new frame is the dialog now so find the dialog title, 'Are you sure?'
    final dialogTitle = find.text('Are you sure?');
    // expected to find one dialog title text
    expect(dialogTitle, findsOneWidget);
    // Find cancel text
    final cancelButton = find.text('Cancel');
    //expected to  find one cancel text
    expect(cancelButton, findsOneWidget);
    // tap on Cancel button
    await tester.tap(cancelButton);
    // render a new frame i.e. dismiss the dialog
    await tester.pump();
    // No dialog expected
    expect(dialogTitle, findsNothing);
    // REMEMBER: Always call 'await tester.pump();' to render a new frame/screen
    // Also, while using tester always use await as this is waiting for user interaction (future)
  });
}
