import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 Import para la vibración háptica

class AccessibleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double? width;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor = const Color.fromARGB(255, 0, 173, 156),
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
    this.fontSize = 18,
    this.width,
  });

  void _handlePress() {
    // Vibración corta y suave
    HapticFeedback.selectionClick();

    // Luego ejecuta la acción del botón
    if (onPressed != null) {
      onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: text,
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 48),
        child: ElevatedButton(
          onPressed: _handlePress, // 👈 ahora pasa por la función que vibra
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black87, width: 1.2),
            ),
            shadowColor: Colors.black.withOpacity(0.5),
            elevation: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize + 4, color: textColor),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
