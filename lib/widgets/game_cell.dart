import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_state.dart';

class GameCell extends StatelessWidget {
  final CellState cellState;
  final VoidCallback onTap;
  final bool isNewMove;
  final bool isDisabled;

  const GameCell({
    super.key,
    required this.cellState,
    required this.onTap,
    required this.isNewMove,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.withOpacity(0.2) : (isNewMove ? Colors.amber.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(10),
          border: isNewMove ? Border.all(color: Colors.amber, width: 2) : null,
        ),
        child: Center(
          child: _getCellContent(),
        ),
      ),
    );
  }

  Widget _getCellContent() {
    switch (cellState) {
      case CellState.x:
        return const Text(
          'X',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        );
      case CellState.o:
        return const Text(
          'O',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        );
      case CellState.empty:
        return const SizedBox.shrink();
    }
  }
}
