enum BoxCategory {
  premium,
  qazi,
  organs,
  mixed,
  custom;

  String get displayName {
    switch (this) {
      case BoxCategory.premium:
        return 'Премиум ет';
      case BoxCategory.qazi:
        return 'Қазы';
      case BoxCategory.organs:
        return 'Субөнімдер';
      case BoxCategory.mixed:
        return 'Аралас';
      case BoxCategory.custom:
        return 'Таңдамалы';
    }
  }

  String get displayNameRu {
    switch (this) {
      case BoxCategory.premium:
        return 'Премиум мясо';
      case BoxCategory.qazi:
        return 'Казы';
      case BoxCategory.organs:
        return 'Субпродукты';
      case BoxCategory.mixed:
        return 'Смешанный';
      case BoxCategory.custom:
        return 'На выбор';
    }
  }

  String get icon {
    switch (this) {
      case BoxCategory.premium:
        return '⭐';
      case BoxCategory.qazi:
        return '🏆';
      case BoxCategory.organs:
        return '❤️';
      case BoxCategory.mixed:
        return '📦';
      case BoxCategory.custom:
        return '🎛️';
    }
  }
}

class MeatBox {
  final String id;
  final String name;
  final String nameKz;
  final String nameRu;
  final String description;
  final String descriptionKz;
  final String descriptionRu;
  final int priceKzt;
  final String? imageUrl;
  final List<BoxItem> items;
  final BoxCategory category;
  final bool isAvailable;
  final int weightGrams;

  MeatBox({
    required this.id,
    required this.name,
    required this.nameKz,
    required this.nameRu,
    required this.description,
    required this.descriptionKz,
    required this.descriptionRu,
    required this.priceKzt,
    this.imageUrl,
    required this.items,
    required this.category,
    required this.isAvailable,
    required this.weightGrams,
  });

  factory MeatBox.fromJson(Map<String, dynamic> json) {
    return MeatBox(
      id: json['id'],
      name: json['name'],
      nameKz: json['name_kz'],
      nameRu: json['name_ru'],
      description: json['description'],
      descriptionKz: json['description_kz'],
      descriptionRu: json['description_ru'],
      priceKzt: json['price_kzt'],
      imageUrl: json['image_url'],
      items: (json['items'] as List).map((e) => BoxItem.fromJson(e)).toList(),
      category: BoxCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => BoxCategory.mixed,
      ),
      isAvailable: json['is_available'] ?? true,
      weightGrams: json['weight_grams'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_kz': nameKz,
      'name_ru': nameRu,
      'description': description,
      'description_kz': descriptionKz,
      'description_ru': descriptionRu,
      'price_kzt': priceKzt,
      'image_url': imageUrl,
      'items': items.map((e) => e.toJson()).toList(),
      'category': category.name,
      'is_available': isAvailable,
      'weight_grams': weightGrams,
    };
  }

  String get formattedPrice => '${priceKzt.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      )} ₸';
}

class BoxItem {
  final String id;
  final String name;
  final String nameKz;
  final String nameRu;
  final int weightGrams;
  final String? description;

  BoxItem({
    required this.id,
    required this.name,
    required this.nameKz,
    required this.nameRu,
    required this.weightGrams,
    this.description,
  });

  factory BoxItem.fromJson(Map<String, dynamic> json) {
    return BoxItem(
      id: json['id'],
      name: json['name'],
      nameKz: json['name_kz'] ?? json['name'],
      nameRu: json['name_ru'] ?? json['name'],
      weightGrams: json['weight_grams'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_kz': nameKz,
      'name_ru': nameRu,
      'weight_grams': weightGrams,
      'description': description,
    };
  }
}
