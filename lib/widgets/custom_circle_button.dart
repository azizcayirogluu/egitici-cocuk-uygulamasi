import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color? shadowColor;
  final double iconSize;

  const CustomCircleButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.blueGrey,
    this.shadowColor,
    this.iconSize = 28,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
