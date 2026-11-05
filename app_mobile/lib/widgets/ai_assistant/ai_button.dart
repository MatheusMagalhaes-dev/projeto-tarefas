import 'package:flutter/material.dart';

class AiButton extends StatelessWidget {
  const AiButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF21134A),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/amve_flow_icon.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
