enum SubscriptionPlan {
  monthly,
  quarterly,
  yearly;

  String get displayName {
    switch (this) {
      case SubscriptionPlan.monthly:
        return 'Айлық';
      case SubscriptionPlan.quarterly:
        return 'Тоқсандық';
      case SubscriptionPlan.yearly:
        return 'Жылдық';
    }
  }

  String get displayNameRu {
    switch (this) {
      case SubscriptionPlan.monthly:
        return 'Ежемесячно';
      case SubscriptionPlan.quarterly:
        return 'Ежеквартально';
      case SubscriptionPlan.yearly:
        return 'Ежегодно';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionPlan.monthly:
        return 'Ай сайын жеткізу';
      case SubscriptionPlan.quarterly:
        return '3 ай сайын жеткізу';
      case SubscriptionPlan.yearly:
        return 'Жыл бойы жеткізу (20% жеңілдік)';
    }
  }

  int get discountPercent {
    switch (this) {
      case SubscriptionPlan.monthly:
        return 0;
      case SubscriptionPlan.quarterly:
        return 10;
      case SubscriptionPlan.yearly:
        return 20;
    }
  }

  int get deliveriesPerYear {
    switch (this) {
      case SubscriptionPlan.monthly:
        return 12;
      case SubscriptionPlan.quarterly:
        return 4;
      case SubscriptionPlan.yearly:
        return 12;
    }
  }
}
