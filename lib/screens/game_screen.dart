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

  const GameScreen({super.key, required this.isAIGame});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final gameStatus = isAIGame ? Provider.of<GameProvider>(context).gameState.status : Provider.of<GameWithFriendProvider>(context).gameState.status;

    final gameMode = isAIGame ? Provider.of<GameProvider>(context).gameMode : Provider.of<GameWithFriendProvider>(context).gameMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [const Color.fromARGB(111, 255, 243, 226), const Color.fromARGB(179, 255, 243, 226)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      isAIGame ? 'AI Tic Tac Toe' : 'Friend Tic Tac Toe',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkMode ? Colors.white : const Color(0xFFFBAB57),
                        shadows: const [
                          Shadow(offset: Offset(2, 2), blurRadius: 3, color: Colors.black38),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                             color: gameMode == GameMode.xtreme
                                ? Colors.orange
                                : gameMode == GameMode.ultraXtreme
                                    ? Colors.red
                                    : Colors.green,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          gameMode == GameMode.xtreme ? 'XTREME MODE' :gameMode == GameMode.ultraXtreme ? 'ULTRA XTREME MODE' : 'NORMAL MODE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: gameMode == GameMode.xtreme ? Colors.orange:gameMode == GameMode.ultraXtreme ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GameBoard(isAIGame: isAIGame),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _getStatusText(gameStatus, isAIGame, gameMode),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : const Color(0xFFFBAB57),
                    shadows: const [
                      Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black38),
                    ],
                  ),
                ).animate().fade().scale(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerIcon(
                    isAI: false,
                    isCurrentTurn: isAIGame
                        ? Provider.of<GameProvider>(context).gameState.isPlayerTurn
                        : Provider.of<GameWithFriendProvider>(context).gameState.isPlayerTurn,
                    label: isAIGame ? 'You' : 'Player 1',
                  ),
                  ElevatedButton(
                     onPressed: () {
                      if (isAIGame) {
                        Provider.of<GameProvider>(context, listen: false).resetGame();
                      } else {
                        Provider.of<GameWithFriendProvider>(context, listen: false).resetGame();
                      }
                   
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(isAIGame: isAIGame),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Restart', style: TextStyle(fontSize: 18)),
                  ),
                  PlayerIcon(
                 
                    isAI: true,
                    isCurrentTurn: isAIGame
                        ? !Provider.of<GameProvider>(context).gameState.isPlayerTurn
                        : !Provider.of<GameWithFriendProvider>(context).gameState.isPlayerTurn,
                    label: isAIGame ? 'AI' : 'Player 2',
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(GameStatus status, bool isAIGame, GameMode mode) {
    switch (status) {
      case GameStatus.playing:
        if (mode == GameMode.xtreme) {
          return isAIGame ? 'First moves disappear after 3!' : 'First move will disappear after 3!';
        }
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


class PlayerIcon extends StatelessWidget {
  final bool isAI;
  final bool isCurrentTurn;
  final String label;

  const PlayerIcon({
    super.key,
    required this.isAI,
    required this.isCurrentTurn,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentTurn
            ? (themeProvider.isDarkMode 
                ? Colors.grey[700] 
                : Colors.amber.withOpacity(0.2))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            isAI ? Icons.smart_toy : Icons.person,
            size: 30,
            color: isAI 
                ? Colors.red 
                : const Color(0xFFFBAB57),
          ),
          Text(
            label,
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}