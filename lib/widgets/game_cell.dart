import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_state.dart';

class GameCell extends StatelessWidget {
  final CellState cellState;
  final VoidCallback onTap;
  final bool isNewMove;

  const GameCell({
    Key? key,
    required this.cellState,
    required this.onTap,
    required this.isNewMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white10, Colors.white24],
          ),
        ),
        child: Center(
          child: _buildCellContent(),
        ),
      ),
    );
  }

  Widget _buildCellContent() {
    Widget content;
    switch (cellState) {
      case CellState.x:
        content = Icon(Icons.close, size: 60, color: Color(0xFFFBAB57));
        break;
      case CellState.o:
        content = Icon(Icons.radio_button_unchecked, size: 60, color: Colors.pinkAccent);
        break;
      case CellState.empty:
        content = SizedBox.shrink();
        break;
    }
    
    if (isNewMove && cellState != CellState.empty) {
      return content.animate()
        .scale(duration: 300.ms)
        .then(delay: 100.ms)
        .shake(duration: 300.ms);
    }
    
    return content;
  }
}