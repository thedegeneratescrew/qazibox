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
    testWidgets('should display box information', (tester) async {
      final box = MeatBox(
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
        isAvailable: true,
        weightGrams: 500,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => CartProvider()),
              ],
              child: SingleChildScrollView(child: BoxCard(box: box)),
            ),
          ),
        ),
      );

      expect(find.text('Қазы Премиум'), findsOneWidget);
      expect(find.text('35 000 ₸'), findsOneWidget);
      expect(find.text('Қосу'), findsOneWidget);
    });

    testWidgets('should add box to cart when tapped', (tester) async {
      final cartProvider = CartProvider();
      final box = MeatBox(
        id: 'test_box',
        name: 'Test Box',
        nameKz: 'Тест жәшігі',
        nameRu: 'Тестовый набор',
        description: 'Test',
        descriptionKz: 'Тест',
        descriptionRu: 'Тест',
        priceKzt: 25000,
        items: [],
        category: BoxCategory.mixed,
        isAvailable: true,
        weightGrams: 1000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: cartProvider,
              child: SingleChildScrollView(child: BoxCard(box: box)),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Қосу'));
      await tester.pump();

      expect(cartProvider.hasItems, true);
      expect(cartProvider.selectedBox?.id, 'test_box');
    });

    testWidgets('should show unavailable badge when box is not available', (tester) async {
      final box = MeatBox(
        id: 'test_box',
        name: 'Test Box',
        nameKz: 'Тест жәшігі',
        nameRu: 'Тестовый набор',
        description: 'Test',
        descriptionKz: 'Тест',
        descriptionRu: 'Тест',
        priceKzt: 25000,
        items: [],
        category: BoxCategory.mixed,
        isAvailable: false,
        weightGrams: 1000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider(
              create: (_) => CartProvider(),
              child: SingleChildScrollView(child: BoxCard(box: box)),
            ),
          ),
        ),
      );

      expect(find.text('Қолжетімсіз'), findsOneWidget);
    });
  });
}
