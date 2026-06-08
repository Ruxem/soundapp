import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryButton({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: SizedBox(
        width: double.infinity,
        height: 80,

        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isSelected ? Colors.orange : Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}