import 'package:flutter/material.dart';

class EmptySlotButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EmptySlotButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(double.infinity, 80),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.black),
            SizedBox(height: 5),
            Text("Add", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}