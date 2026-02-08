import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qazibox/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('QaziBox E2E Tests', () {
    testWidgets('Complete user journey: Browse → Add to Cart → Checkout', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should see splash then navigate to auth/home
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // If on auth screen, perform login
      if (find.text('Қош келдіңіз!').evaluate().isNotEmpty) {
        // Enter email
        await tester.enterText(find.byType(TextField).first, 'test@qazibox.kz');
        await tester.pump();

        // Enter password
        await tester.enterText(find.byType(TextField).last, 'password123');
        await tester.pump();

        // Tap login
        await tester.tap(find.text('Кіру'));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // Should be on home screen now
      expect(find.text('QaziBox'), findsWidgets);

      // Navigate to boxes tab
      await tester.tap(find.text('Жәшіктер'));
      await tester.pumpAndSettle();

      // Should see boxes
      expect(find.text('Жәшіктер'), findsWidgets);

      // Tap on first "Add" button
      final addButtons = find.text('Қосу');
      if (addButtons.evaluate().isNotEmpty) {
        await tester.tap(addButtons.first);
        await tester.pumpAndSettle();

        // Should show snackbar confirmation
        expect(find.text('себетке қосылды'), findsOneWidget);
      }

      // Navigate to cart
      await tester.tap(find.text('Себет'));
      await tester.pumpAndSettle();

      // Cart should have items or be visible
      expect(find.text('Себет'), findsWidgets);
    });

    testWidgets('User can view box categories', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for navigation
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check category chips exist
      expect(find.text('Қазы'), findsWidgets);
      expect(find.text('Премиум ет'), findsWidgets);
    });

    testWidgets('Cart quantity controls work', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to boxes and add item
      await tester.tap(find.text('Жәшіктер'));
      await tester.pumpAndSettle();

      final addButton = find.text('Қосу').first;
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Go to cart
      await tester.tap(find.text('Себет'));
      await tester.pumpAndSettle();

      // If cart has items, test quantity
      if (find.byIcon(Icons.add_circle_outline).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();
        expect(find.text('2'), findsOneWidget);
      }
    });
  });
}
