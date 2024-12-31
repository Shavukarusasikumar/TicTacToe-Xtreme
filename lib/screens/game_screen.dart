import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/game_with_friend_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/game_board.dart';
import '../widgets/player_icon.dart';
import '../utils/quotes.dart';

class GameScreen extends StatelessWidget {
  final bool isAIGame;

  GameScreen({required this.isAIGame});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final gameStatus = isAIGame
        ? Provider.of<GameProvider>(context).gameState.status
        : Provider.of<GameWithFriendProvider>(context).gameState.status;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Color.fromARGB(111, 255, 243, 226), Color.fromARGB(179, 255, 243, 226)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isAIGame ? 'AI Tic Tac Toe' : 'Friend Tic Tac Toe',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : Color(0xFFFBAB57),
                    shadows: [
                      Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black38),
                    ],
                  ),
                ),
              ),
              GameBoard(isAIGame: isAIGame),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _getStatusText(gameStatus),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : Color(0xFFFBAB57),
                    shadows: [
                      Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black38),
                    ],
                  ),
                ).animate().fade().scale(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerIcon(isAI: false),
                  ElevatedButton(
                    onPressed: () {
                      if (isAIGame) {
                        Provider.of<GameProvider>(context, listen: false).resetGame();
                      } else {
                        Provider.of<GameWithFriendProvider>(context, listen: false).resetGame();
                      }
                    },
                    child: Text('Restart', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.amber,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  PlayerIcon(isAI: isAIGame),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.playing:
        return 'Game in progress';
      case GameStatus.playerWin:
        return isAIGame ? 'You win! 🎉' : 'Player 1 wins! 🎉';
      case GameStatus.aiWin:
        return isAIGame ? getRandomQuote() : 'Player 2 wins! 🎉';
      default:
        return '';
    }
  }
}