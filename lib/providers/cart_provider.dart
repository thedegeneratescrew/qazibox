import 'package:flutter/foundation.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  MeatBox? _selectedBox;
  SubscriptionPlan _subscriptionPlan = SubscriptionPlan.monthly;
  Address? _deliveryAddress;
  int _quantity = 1;

  MeatBox? get selectedBox => _selectedBox;
  SubscriptionPlan get subscriptionPlan => _subscriptionPlan;
  Address? get deliveryAddress => _deliveryAddress;
  int get quantity => _quantity;

  bool get hasItems => _selectedBox != null;

  int get subtotal {
    if (_selectedBox == null) return 0;
    return _selectedBox!.priceKzt * _quantity;
  }

  int get discount {
    return (subtotal * _subscriptionPlan.discountPercent / 100).round();
  }

  int get total => subtotal - discount;

  String get formattedTotal => '${total.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      )} ₸';

  void selectBox(MeatBox box) {
    _selectedBox = box;
    _quantity = 1;
    notifyListeners();
  }

  void setSubscriptionPlan(SubscriptionPlan plan) {
    _subscriptionPlan = plan;
    notifyListeners();
  }

  void setDeliveryAddress(Address address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  void setQuantity(int qty) {
    if (qty > 0 && qty <= 10) {
      _quantity = qty;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    if (_quantity < 10) {
      _quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void clear() {
    _selectedBox = null;
    _quantity = 1;
    _subscriptionPlan = SubscriptionPlan.monthly;
    notifyListeners();
  }
}
