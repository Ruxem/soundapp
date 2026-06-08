import 'package:flutter/material.dart';
import 'category_button.dart';

class CategoryList extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ["Home", "City", "Walk", "Sports"];

    return Column(
      children: categories.map((category) {
        return CategoryButton(
          category: category,
          isSelected: selectedCategory == category,
          onPressed: () => onCategorySelected(category),
        );
      }).toList(),
    );
  }
}