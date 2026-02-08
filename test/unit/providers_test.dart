import 'package:flutter_test/flutter_test.dart';
import 'package:qazibox/models/models.dart';
import 'package:qazibox/providers/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('should start with empty cart', () {
      expect(cartProvider.hasItems, false);
      expect(cartProvider.selectedBox, null);
      expect(cartProvider.quantity, 1);
    });

    test('should add box to cart', () {
      final box = _createTestBox();
      cartProvider.selectBox(box);

      expect(cartProvider.hasItems, true);
      expect(cartProvider.selectedBox, box);
    });

    test('should calculate subtotal correctly', () {
      final box = _createTestBox(price: 25000);
      cartProvider.selectBox(box);

      expect(cartProvider.subtotal, 25000);

      cartProvider.setQuantity(2);
      expect(cartProvider.subtotal, 50000);
    });

    test('should apply discount for quarterly plan', () {
      final box = _createTestBox(price: 100000);
      cartProvider.selectBox(box);
      cartProvider.setSubscriptionPlan(SubscriptionPlan.quarterly);

      expect(cartProvider.discount, 10000); // 10% of 100000
      expect(cartProvider.total, 90000);
    });

    test('should apply discount for yearly plan', () {
      final box = _createTestBox(price: 100000);
      cartProvider.selectBox(box);
      cartProvider.setSubscriptionPlan(SubscriptionPlan.yearly);

      expect(cartProvider.discount, 20000); // 20% of 100000
      expect(cartProvider.total, 80000);
    });

    test('should increment quantity', () {
      final box = _createTestBox();
      cartProvider.selectBox(box);

      cartProvider.incrementQuantity();
      expect(cartProvider.quantity, 2);

      cartProvider.incrementQuantity();
      expect(cartProvider.quantity, 3);
    });

    test('should not exceed max quantity of 10', () {
      final box = _createTestBox();
      cartProvider.selectBox(box);
      cartProvider.setQuantity(10);

      cartProvider.incrementQuantity();
      expect(cartProvider.quantity, 10);
    });

    test('should decrement quantity', () {
      final box = _createTestBox();
      cartProvider.selectBox(box);
      cartProvider.setQuantity(3);

      cartProvider.decrementQuantity();
      expect(cartProvider.quantity, 2);
    });

    test('should not go below 1 quantity', () {
      final box = _createTestBox();
      cartProvider.selectBox(box);

      cartProvider.decrementQuantity();
      expect(cartProvider.quantity, 1);
    });

    test('should clear cart', () {
      final box = _createTestBox();
      cartProvider.selectBox(box);
      cartProvider.setQuantity(3);
      cartProvider.setSubscriptionPlan(SubscriptionPlan.yearly);

      cartProvider.clear();

      expect(cartProvider.hasItems, false);
      expect(cartProvider.selectedBox, null);
      expect(cartProvider.quantity, 1);
      expect(cartProvider.subscriptionPlan, SubscriptionPlan.monthly);
    });

    test('should format total price correctly', () {
      final box = _createTestBox(price: 35000);
      cartProvider.selectBox(box);

      expect(cartProvider.formattedTotal, '35 000 ₸');
    });
  });
}

MeatBox _createTestBox({int price = 35000}) {
  return MeatBox(
    id: 'test_box',
    name: 'Test Box',
    nameKz: 'Тест жәшігі',
    nameRu: 'Тестовый набор',
    description: 'Test description',
    descriptionKz: 'Тест сипаттамасы',
    descriptionRu: 'Тестовое описание',
    priceKzt: price,
    items: [],
    category: BoxCategory.mixed,
    isAvailable: true,
    weightGrams: 1000,
  );
}
