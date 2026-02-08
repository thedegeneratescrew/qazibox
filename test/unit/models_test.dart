import 'package:flutter_test/flutter_test.dart';
import 'package:qazibox/models/models.dart';

void main() {
  group('User Model', () {
    test('should create user from JSON', () {
      final json = {
        'id': 'user_1',
        'email': 'test@qazibox.kz',
        'name': 'Test User',
        'phone': '+7 777 123 4567',
        'created_at': '2024-01-01T00:00:00Z',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user_1');
      expect(user.email, 'test@qazibox.kz');
      expect(user.name, 'Test User');
      expect(user.phone, '+7 777 123 4567');
    });

    test('should convert user to JSON', () {
      final user = User(
        id: 'user_1',
        email: 'test@qazibox.kz',
        name: 'Test User',
        phone: '+7 777 123 4567',
        createdAt: DateTime(2024, 1, 1),
      );

      final json = user.toJson();

      expect(json['id'], 'user_1');
      expect(json['email'], 'test@qazibox.kz');
      expect(json['name'], 'Test User');
    });
  });

  group('MeatBox Model', () {
    test('should create meat box from JSON', () {
      final json = {
        'id': 'box_1',
        'name': 'Qazi Premium',
        'name_kz': 'Қазы Премиум',
        'name_ru': 'Казы Премиум',
        'description': 'Premium qazi',
        'description_kz': 'Премиум қазы',
        'description_ru': 'Премиум казы',
        'price_kzt': 35000,
        'items': [
          {'id': 'item_1', 'name': 'Qazi', 'name_kz': 'Қазы', 'name_ru': 'Казы', 'weight_grams': 500},
        ],
        'category': 'qazi',
        'is_available': true,
        'weight_grams': 500,
      };

      final box = MeatBox.fromJson(json);

      expect(box.id, 'box_1');
      expect(box.nameKz, 'Қазы Премиум');
      expect(box.priceKzt, 35000);
      expect(box.category, BoxCategory.qazi);
      expect(box.items.length, 1);
    });

    test('should format price correctly', () {
      final box = MeatBox(
        id: 'box_1',
        name: 'Test',
        nameKz: 'Тест',
        nameRu: 'Тест',
        description: 'Test',
        descriptionKz: 'Тест',
        descriptionRu: 'Тест',
        priceKzt: 35000,
        items: [],
        category: BoxCategory.premium,
        isAvailable: true,
        weightGrams: 1000,
      );

      expect(box.formattedPrice, '35 000 ₸');
    });
  });

  group('BoxCategory', () {
    test('should have correct display names', () {
      expect(BoxCategory.qazi.displayName, 'Қазы');
      expect(BoxCategory.premium.displayName, 'Премиум ет');
      expect(BoxCategory.organs.displayName, 'Субөнімдер');
    });

    test('should have icons', () {
      expect(BoxCategory.qazi.icon, isNotEmpty);
      expect(BoxCategory.premium.icon, isNotEmpty);
    });
  });

  group('SubscriptionPlan', () {
    test('should have correct discount percentages', () {
      expect(SubscriptionPlan.monthly.discountPercent, 0);
      expect(SubscriptionPlan.quarterly.discountPercent, 10);
      expect(SubscriptionPlan.yearly.discountPercent, 20);
    });

    test('should have display names in Kazakh', () {
      expect(SubscriptionPlan.monthly.displayName, 'Айлық');
      expect(SubscriptionPlan.quarterly.displayName, 'Тоқсандық');
      expect(SubscriptionPlan.yearly.displayName, 'Жылдық');
    });
  });

  group('Order Model', () {
    test('should create order from JSON', () {
      final json = {
        'id': 'order_1',
        'user_id': 'user_1',
        'box_id': 'box_1',
        'status': 'pending',
        'delivery_address': {
          'street': 'Test Street',
          'city': 'Астана',
        },
        'total_price_kzt': 35000,
        'created_at': '2024-01-01T00:00:00Z',
      };

      final order = Order.fromJson(json);

      expect(order.id, 'order_1');
      expect(order.status, OrderStatus.pending);
      expect(order.totalPriceKzt, 35000);
    });

    test('OrderStatus should have correct display names', () {
      expect(OrderStatus.pending.displayName, 'Күтуде');
      expect(OrderStatus.delivered.displayName, 'Жеткізілді');
      expect(OrderStatus.cancelled.displayName, 'Бас тартылды');
    });
  });
}
