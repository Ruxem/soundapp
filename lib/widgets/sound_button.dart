import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sound_app/providers/command.dart';

class SoundButton extends StatelessWidget {
  final Command command;
  final Color color;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final VoidCallback? onRightClick;

  const SoundButton({
    super.key,
    required this.command,
    required this.color,
    required this.onPressed,
    this.onLongPress,
    this.onRightClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
            if (onRightClick != null) {
              onRightClick!();
            }
          }
        },

        child: GestureDetector(
          onLongPress: onLongPress,

          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(double.infinity, 80),
            ),
            child: Center(
              child: Text(
                command.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}