import 'user.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Күтуде';
      case OrderStatus.confirmed:
        return 'Расталды';
      case OrderStatus.preparing:
        return 'Дайындалуда';
      case OrderStatus.shipped:
        return 'Жолда';
      case OrderStatus.delivered:
        return 'Жеткізілді';
      case OrderStatus.cancelled:
        return 'Бас тартылды';
    }
  }

  String get displayNameRu {
    switch (this) {
      case OrderStatus.pending:
        return 'В ожидании';
      case OrderStatus.confirmed:
        return 'Подтвержден';
      case OrderStatus.preparing:
        return 'Готовится';
      case OrderStatus.shipped:
        return 'В пути';
      case OrderStatus.delivered:
        return 'Доставлен';
      case OrderStatus.cancelled:
        return 'Отменен';
    }
  }
}

class Order {
  final String id;
  final String userId;
  final String boxId;
  final String? boxName;
  final OrderStatus status;
  final Address deliveryAddress;
  final int totalPriceKzt;
  final DateTime createdAt;
  final DateTime? scheduledDelivery;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.boxId,
    this.boxName,
    required this.status,
    required this.deliveryAddress,
    required this.totalPriceKzt,
    required this.createdAt,
    this.scheduledDelivery,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      boxId: json['box_id'],
      boxName: json['box_name'],
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      deliveryAddress: Address.fromJson(json['delivery_address']),
      totalPriceKzt: json['total_price_kzt'],
      createdAt: DateTime.parse(json['created_at']),
      scheduledDelivery: json['scheduled_delivery'] != null
          ? DateTime.parse(json['scheduled_delivery'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'box_id': boxId,
      'box_name': boxName,
      'status': status.name,
      'delivery_address': deliveryAddress.toJson(),
      'total_price_kzt': totalPriceKzt,
      'created_at': createdAt.toIso8601String(),
      'scheduled_delivery': scheduledDelivery?.toIso8601String(),
      'notes': notes,
    };
  }

  String get formattedPrice => '${totalPriceKzt.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      )} ₸';
}
