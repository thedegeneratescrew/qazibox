import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class BoxesProvider extends ChangeNotifier {
  List<MeatBox> _boxes = [];
  bool _isLoading = false;
  String? _errorMessage;
  BoxCategory? _selectedCategory;

  List<MeatBox> get boxes => _selectedCategory == null
      ? _boxes
      : _boxes.where((b) => b.category == _selectedCategory).toList();
  
  List<MeatBox> get allBoxes => _boxes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BoxCategory? get selectedCategory => _selectedCategory;

  final ApiService _apiService = ApiService();

  Future<void> loadBoxes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _boxes = await _apiService.getBoxes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(BoxCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  MeatBox? getBoxById(String id) {
    try {
      return _boxes.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MeatBox> getBoxesByCategory(BoxCategory category) {
    return _boxes.where((b) => b.category == category).toList();
  }
}
