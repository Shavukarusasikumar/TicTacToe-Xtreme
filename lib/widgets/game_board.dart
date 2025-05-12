import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tic_tac_toe_remaster/models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/game_with_friend_provider.dart';
import '../providers/theme_provider.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final bool isAIGame;

  const GameBoard({super.key, required this.isAIGame});

  @override
  Widget build(BuildContext context) {
    final gameState = isAIGame ? Provider.of<GameProvider>(context).gameState : Provider.of<GameWithFriendProvider>(context).gameState;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.customPrimaryColor;

    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.deepPurple.withOpacity(0.3) : primaryColor.withOpacity(0.4),
          width: 1.5,
        ),
        color: isDarkMode ? Colors.black.withOpacity(0.25) : Colors.white.withOpacity(0.6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(300, 300),
                painter: GridPainter(
                  isDarkMode: isDarkMode,
                  primaryColor: primaryColor,
                ),
              ),

              // Game cells
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final row = index ~/ 3;
                  final col = index % 3;
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GameCell(
                      cellState: gameState.board[row][col],
                      onTap: () {
                        // Only allow moves if game is still playing
                        if (gameState.status == GameStatus.playing) {
                          if (isAIGame) {
                            Provider.of<GameProvider>(context, listen: false).makeMove(row, col);
                          } else {
                            Provider.of<GameWithFriendProvider>(context, listen: false).makeMove(row, col, context);
                          }
                        }
                      },
                      isNewMove: isAIGame
                          ? Provider.of<GameProvider>(context, listen: false).isNewMove(row, col)
                          : Provider.of<GameWithFriendProvider>(context, listen: false).isNewMove(row, col),
                      isDisabled: gameState.status != GameStatus.playing,
                    ).animate().fade(duration: 300.ms).scale(delay: 300.ms),
                  );
                },
              ),

              // Game over overlay
              if (gameState.status != GameStatus.playing)
                GestureDetector(
                  onTap: () {
                    // To handle taps on the overlay
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isDarkMode ? Colors.deepPurple.withOpacity(0.7) : primaryColor.withOpacity(0.7),
                          isDarkMode ? Colors.black.withOpacity(0.8) : Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getGameStatusText(gameState.status, isAIGame),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 10,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 400.ms).scale(),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (isAIGame) {
                                  Provider.of<GameProvider>(context, listen: false).resetGame();
                                } else {
                                  Provider.of<GameWithFriendProvider>(context, listen: false).resetGame();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? Colors.deepPurple : primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                                shadowColor: isDarkMode ? Colors.deepPurple.withOpacity(0.6) : primaryColor.withOpacity(0.6),
                              ),
                              child: const Text(
                                'Play Again',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.5, end: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 600.ms).scale(delay: 300.ms).shimmer(delay: 600.ms, duration: 1800.ms);
  }

  String _getGameStatusText(GameStatus status, bool isAIGame) {
    switch (status) {
      case GameStatus.playerWin:
        return isAIGame ? 'You Win!' : 'Player 1 Wins!';
      case GameStatus.aiWin:
        return isAIGame ? 'AI Wins!' : 'Player 2 Wins!';
      case GameStatus.draw:
        return 'Draw!';
      case GameStatus.playing:
        return '';
    }
  }
}

// Custom painter for drawing the grid lines
class GridPainter extends CustomPainter {
  final bool isDarkMode;
  final Color primaryColor;

  GridPainter({required this.isDarkMode, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final lineColor = isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.15);

    final accentColor = isDarkMode ? Colors.deepPurple.withOpacity(0.3) : primaryColor.withOpacity(0.3);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = accentColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    // Cell width and height
    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;

    // Draw vertical lines
    for (int i = 1; i < 3; i++) {
      // Main line
      canvas.drawLine(
        Offset(cellWidth * i, 0),
        Offset(cellWidth * i, size.height),
        paint,
      );

      // Accent glow line
      canvas.drawLine(
        Offset(cellWidth * i, 0),
        Offset(cellWidth * i, size.height),
        accentPaint,
      );
    }

    // Draw horizontal lines
    for (int i = 1; i < 3; i++) {
      // Main line
      canvas.drawLine(
        Offset(0, cellHeight * i),
        Offset(size.width, cellHeight * i),
        paint,
      );

      // Accent glow line
      canvas.drawLine(
        Offset(0, cellHeight * i),
        Offset(size.width, cellHeight * i),
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
