import 'package:flutter/material.dart';

class PlayerIcon extends StatelessWidget {
  final bool isAI;

  const PlayerIcon({super.key, required this.isAI});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isAI ? Colors.pinkAccent : Colors.amber,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        isAI ? Icons.computer : Icons.person,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}