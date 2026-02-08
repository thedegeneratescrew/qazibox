import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qazibox/models/models.dart';
import 'package:qazibox/providers/auth_provider.dart';
import 'package:qazibox/providers/cart_provider.dart';
import 'package:qazibox/screens/auth/auth_screen.dart';
import 'package:qazibox/widgets/box_card.dart';

void main() {
  group('AuthScreen', () {
    testWidgets('should show login form by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: const AuthScreen(),
          ),
        ),
      );

      expect(find.text('QaziBox'), findsOneWidget);
      expect(find.text('Қош келдіңіз!'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Құпия сөз'), findsOneWidget);
    });

    testWidgets('should have toggle signup link', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: const AuthScreen(),
          ),
        ),
      );

      expect(find.text('Аккаунт жоқ па? Тіркелу'), findsOneWidget);
    });
  });

  group('BoxCard Widget', () {
    MeatBox createTestBox({bool isAvailable = true}) {
      return MeatBox(
        id: 'test_box',
        name: 'Test Box',
        nameKz: 'Қазы Премиум',
        nameRu: 'Казы Премиум',
        description: 'Test description',
        descriptionKz: 'Премиум қазы таңдамасы',
        descriptionRu: 'Премиум выбор казы',
        priceKzt: 35000,
        items: [
          BoxItem(
            id: 'item_1',
            name: 'Qazi',
            nameKz: 'Қазы',
            nameRu: 'Казы',
            weightGrams: 500,
          ),
        ],
        category: BoxCategory.qazi,
        isAvailable: isAvailable,
        weightGrams: 500,
      );
    }

    testWidgets('should display box name and price', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => CartProvider()),
              ],
              child: SingleChildScrollView(child: BoxCard(box: createTestBox(), index: 0)),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Қазы Премиум'), findsOneWidget);
      expect(find.text('35 000 ₸'), findsOneWidget);
    });

    testWidgets('cart provider can add box directly', (tester) async {
      // Test the provider directly instead of through widget
      final cartProvider = CartProvider();
      final box = createTestBox();
      
      expect(cartProvider.hasItems, false);
      cartProvider.selectBox(box);
      expect(cartProvider.hasItems, true);
      expect(cartProvider.selectedBox?.id, 'test_box');
    });

    testWidgets('should show unavailable status when box is not available', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider(
              create: (_) => CartProvider(),
              child: SingleChildScrollView(
                child: BoxCard(box: createTestBox(isAvailable: false), index: 0),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Қолжетімсіз'), findsOneWidget);
    });
  });
}
