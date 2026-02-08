class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final Address? address;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address?.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Address {
  final String street;
  final String city;
  final String? postalCode;
  final String? notes;

  Address({
    required this.street,
    required this.city,
    this.postalCode,
    this.notes,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      postalCode: json['postal_code'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postal_code': postalCode,
      'notes': notes,
    };
  }
}
