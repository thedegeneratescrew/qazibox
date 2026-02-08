import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  // TODO: Replace with actual backend URL
  static const String baseUrl = 'https://api.qazibox.kz';
  
  // For development/testing, use mock data
  static const bool useMockData = true;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_1',
          'email': email,
          'name': 'Test User',
          'phone': '+7 777 123 4567',
          'created_at': DateTime.now().toIso8601String(),
        },
      };
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException('Кіру сәтсіз аяқталды', statusCode: response.statusCode);
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'email': email,
          'name': name,
          'phone': phone,
          'created_at': DateTime.now().toIso8601String(),
        },
      };
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw ApiException('Тіркелу сәтсіз аяқталды', statusCode: response.statusCode);
    }
  }

  Future<User?> getCurrentUser(String token) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return User(
        id: 'user_1',
        email: 'test@qazibox.kz',
        name: 'Test User',
        phone: '+7 777 123 4567',
        createdAt: DateTime.now(),
      );
    }

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<User> updateProfile({
    required String token,
    String? name,
    String? phone,
    Address? address,
  }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return User(
        id: 'user_1',
        email: 'test@qazibox.kz',
        name: name ?? 'Test User',
        phone: phone ?? '+7 777 123 4567',
        address: address,
        createdAt: DateTime.now(),
      );
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address.toJson(),
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('Профильді жаңарту сәтсіз', statusCode: response.statusCode);
    }
  }

  Future<List<MeatBox>> getBoxes() async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockBoxes();
    }

    final response = await http.get(
      Uri.parse('$baseUrl/boxes'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MeatBox.fromJson(json)).toList();
    } else {
      throw ApiException('Жәшіктерді жүктеу сәтсіз', statusCode: response.statusCode);
    }
  }

  Future<Order> createOrder({
    required String token,
    required String boxId,
    required Address address,
    required SubscriptionPlan plan,
    required int quantity,
    required int totalPrice,
    String? notes,
  }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));
      return Order(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_1',
        boxId: boxId,
        status: OrderStatus.pending,
        deliveryAddress: address,
        totalPriceKzt: totalPrice,
        createdAt: DateTime.now(),
        scheduledDelivery: DateTime.now().add(const Duration(days: 3)),
        notes: notes,
      );
    }

    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'box_id': boxId,
        'delivery_address': address.toJson(),
        'subscription_plan': plan.name,
        'quantity': quantity,
        'total_price_kzt': totalPrice,
        'notes': notes,
      }),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException('Тапсырыс жасау сәтсіз', statusCode: response.statusCode);
    }
  }

  Future<List<Order>> getOrders(String token) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        Order(
          id: 'order_1',
          userId: 'user_1',
          boxId: 'box_1',
          boxName: 'Қазы Премиум',
          status: OrderStatus.delivered,
          deliveryAddress: Address(street: 'Мәңгілік Ел 1', city: 'Астана'),
          totalPriceKzt: 25000,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Order(
          id: 'order_2',
          userId: 'user_1',
          boxId: 'box_2',
          boxName: 'Аралас жәшік',
          status: OrderStatus.shipped,
          deliveryAddress: Address(street: 'Мәңгілік Ел 1', city: 'Астана'),
          totalPriceKzt: 35000,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
    }

    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw ApiException('Тапсырыстарды жүктеу сәтсіз', statusCode: response.statusCode);
    }
  }

  List<MeatBox> _getMockBoxes() {
    return [
      MeatBox(
        id: 'box_1',
        name: 'Qazi Premium',
        nameKz: 'Қазы Премиум',
        nameRu: 'Казы Премиум',
        description: 'Traditional Kazakh horse meat sausage, premium selection',
        descriptionKz: 'Дәстүрлі қазақ қазысы, премиум таңдау. Таза жылқы етінен жасалған.',
        descriptionRu: 'Традиционная казахская конская колбаса, премиум выбор',
        priceKzt: 35000,
        imageUrl: null,
        items: [
          BoxItem(id: 'item_1', name: 'Qazi', nameKz: 'Қазы', nameRu: 'Казы', weightGrams: 500),
          BoxItem(id: 'item_2', name: 'Qarta', nameKz: 'Қарта', nameRu: 'Карта', weightGrams: 300),
          BoxItem(id: 'item_3', name: 'Shuzhuk', nameKz: 'Шұжық', nameRu: 'Шужук', weightGrams: 400),
        ],
        category: BoxCategory.qazi,
        isAvailable: true,
        weightGrams: 1200,
      ),
      MeatBox(
        id: 'box_2',
        name: 'Premium Beef',
        nameKz: 'Премиум сиыр еті',
        nameRu: 'Премиум говядина',
        description: 'Premium beef cuts selection',
        descriptionKz: 'Премиум сиыр еті таңдамасы. Үздік кесімдер.',
        descriptionRu: 'Подборка премиум говядины',
        priceKzt: 28000,
        imageUrl: null,
        items: [
          BoxItem(id: 'item_4', name: 'Ribeye', nameKz: 'Рибай', nameRu: 'Рибай', weightGrams: 400),
          BoxItem(id: 'item_5', name: 'Tenderloin', nameKz: 'Тендерлойн', nameRu: 'Тендерлойн', weightGrams: 300),
          BoxItem(id: 'item_6', name: 'Striploin', nameKz: 'Стриплойн', nameRu: 'Стриплойн', weightGrams: 400),
        ],
        category: BoxCategory.premium,
        isAvailable: true,
        weightGrams: 1100,
      ),
      MeatBox(
        id: 'box_3',
        name: 'Mixed Box',
        nameKz: 'Аралас жәшік',
        nameRu: 'Смешанный набор',
        description: 'A mix of premium meats and traditional products',
        descriptionKz: 'Премиум ет пен дәстүрлі өнімдердің қоспасы.',
        descriptionRu: 'Микс премиум мяса и традиционных продуктов',
        priceKzt: 32000,
        imageUrl: null,
        items: [
          BoxItem(id: 'item_7', name: 'Qazi', nameKz: 'Қазы', nameRu: 'Казы', weightGrams: 300),
          BoxItem(id: 'item_8', name: 'Beef Steak', nameKz: 'Сиыр стейк', nameRu: 'Стейк из говядины', weightGrams: 400),
          BoxItem(id: 'item_9', name: 'Lamb Chops', nameKz: 'Қой қабырғасы', nameRu: 'Бараньи ребрышки', weightGrams: 400),
        ],
        category: BoxCategory.mixed,
        isAvailable: true,
        weightGrams: 1100,
      ),
      MeatBox(
        id: 'box_4',
        name: 'Offal Selection',
        nameKz: 'Субөнімдер жиынтығы',
        nameRu: 'Набор субпродуктов',
        description: 'Traditional organ meats',
        descriptionKz: 'Дәстүрлі субөнімдер жиынтығы.',
        descriptionRu: 'Традиционные субпродукты',
        priceKzt: 18000,
        imageUrl: null,
        items: [
          BoxItem(id: 'item_10', name: 'Liver', nameKz: 'Бауыр', nameRu: 'Печень', weightGrams: 400),
          BoxItem(id: 'item_11', name: 'Heart', nameKz: 'Жүрек', nameRu: 'Сердце', weightGrams: 300),
          BoxItem(id: 'item_12', name: 'Tongue', nameKz: 'Тіл', nameRu: 'Язык', weightGrams: 400),
        ],
        category: BoxCategory.organs,
        isAvailable: true,
        weightGrams: 1100,
      ),
    ];
  }
}
