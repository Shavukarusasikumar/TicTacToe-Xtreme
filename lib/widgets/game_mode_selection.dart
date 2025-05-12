import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_remaster/screens/game_screen.dart';
import '../providers/game_provider.dart';
import '../providers/game_with_friend_provider.dart';
import '../providers/theme_provider.dart';

class GameModeSelectionDialog extends StatelessWidget {
  final bool isAIGame;

  const GameModeSelectionDialog({super.key, required this.isAIGame});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = themeProvider.customPrimaryColor;

    return Dialog(
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2D2D3A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isAIGame ? Icons.smart_toy : Icons.people,
                    color: isDarkMode ? Colors.black87 : Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Play vs ${isAIGame ? 'AI' : 'Friend'}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.black87 : Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Game Mode Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  _buildGameModeOption(
                    context: context,
                    title: 'Normal Mode',
                    subtitle: 'Classic Tic Tac Toe rules',
                    icon: Icons.grid_3x3,
                    iconColor: isDarkMode ? primaryColor : Colors.black87,
                    bgColor: isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                    onTap: () {
                      _setGameMode(context, GameMode.normal);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(isAIGame: isAIGame),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildGameModeOption(
                    context: context,
                    title: 'Xtreme Mode',
                    subtitle: 'Limited moves - remove first move after 3',
                    icon: Icons.bolt,
                    iconColor: Colors.white,
                    bgColor: isDarkMode ? Colors.deepPurple.withOpacity(0.3) : primaryColor.withOpacity(0.2),
                    borderColor: isDarkMode ? Colors.deepPurple : primaryColor,
                    onTap: () {
                      _setGameMode(context, GameMode.xtreme);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(isAIGame: isAIGame),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: primaryColor),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setGameMode(BuildContext context, GameMode mode) {
    if (isAIGame) {
      Provider.of<GameProvider>(context, listen: false).setGameMode(mode);
    } else {
      Provider.of<GameWithFriendProvider>(context, listen: false).setGameMode(mode);
    }
  }

  Widget _buildGameModeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: themeProvider.customPrimaryColor.withOpacity(0.2),
        highlightColor: themeProvider.customPrimaryColor.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: borderColor ?? (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
