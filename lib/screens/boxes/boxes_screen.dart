import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/boxes_provider.dart';
import '../../widgets/box_card.dart';

class BoxesScreen extends StatelessWidget {
  const BoxesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Жәшіктер'),
      ),
      body: Column(
        children: [
          // Category Filter
          Consumer<BoxesProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Барлығы',
                      isSelected: provider.selectedCategory == null,
                      onTap: () => provider.setCategory(null),
                    ),
                    const SizedBox(width: 8),
                    ...BoxCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: category.displayName,
                          isSelected: provider.selectedCategory == category,
                          onTap: () => provider.setCategory(category),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),

          // Boxes List
          Expanded(
            child: Consumer<BoxesProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadBoxes(),
                          child: const Text('Қайталау'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.boxes.isEmpty) {
                  return const Center(
                    child: Text('Жәшіктер табылмады'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadBoxes(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.boxes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BoxCard(box: provider.boxes[index]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
