import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController(text: 'Астана');
  final _notesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final cart = context.read<CartProvider>();
      final auth = context.read<AuthProvider>();
      final token = await StorageService().getToken();

      if (token == null) {
        throw Exception('Жүйеге кіріңіз');
      }

      final address = Address(
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      final order = await ApiService().createOrder(
        token: token,
        boxId: cart.selectedBox!.id,
        address: address,
        plan: cart.subscriptionPlan,
        quantity: cart.quantity,
        totalPrice: cart.total,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      cart.clear();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Тапсырыс қабылданды!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Тапсырыс нөмірі: ${order.id.substring(0, 8)}'),
                const SizedBox(height: 8),
                const Text('Жеткізу күні: 3-5 жұмыс күні'),
                const SizedBox(height: 8),
                const Text('Сізге SMS хабарлама жіберіледі.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Жақсы'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Қате: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Тапсырыс беру'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Тапсырыс',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(cart.selectedBox?.nameKz ?? ''),
                                Text('x${cart.quantity}'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Жазылым: ${cart.subscriptionPlan.displayName}'),
                                if (cart.discount > 0)
                                  Text(
                                    '-${cart.discount} ₸',
                                    style: TextStyle(color: Colors.green[600]),
                                  ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Барлығы:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  cart.formattedTotal,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Delivery Address
                    const Text(
                      'Жеткізу мекенжайы',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Қала',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Қаланы енгізіңіз';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        labelText: 'Көше, үй, пәтер',
                        prefixIcon: Icon(Icons.home),
                        hintText: 'Мысалы: Мәңгілік Ел 1, пәтер 25',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Мекенжайды енгізіңіз';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Қосымша ақпарат (міндетті емес)',
                        prefixIcon: Icon(Icons.note),
                        hintText: 'Домофон коды, қоңырау шалу уақыты',
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Place Order Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _placeOrder,
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Тапсырысты растау'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
