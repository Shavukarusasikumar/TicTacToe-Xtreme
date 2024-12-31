// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/stats_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final gameProvider = Provider.of<GameProvider>(context);
    final stats = Provider.of<StatsProvider>(context).stats;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Color(0xFFFFF3E2), Color(0xFFFFF3E2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with Settings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TicTacToe Xtreme',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w500,
                          color: themeProvider.isDarkMode ? Colors.white : Color(0xFFFBAB57),
                        ),
                      ).animate().fade().scale(),
                    
                    ],
                  ),
                  SizedBox(height: 20),

                  // Stats Cards Row
                  Container(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildStatCard(
                          'Wins',
                          stats.wins.toString(),
                          Colors.green,
                          Icons.emoji_events,
                          context,
                        ),
                        _buildStatCard(
                          'Win Rate',
                          '${stats.winRate.toStringAsFixed(1)}%',
                          Colors.blue,
                          Icons.analytics,
                          context,
                        ),
                        _buildStatCard(
                          'Total Games',
                          stats.totalGames.toString(),
                          Colors.orange,
                          Icons.games,
                          context,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Game Mode Cards
                  _buildGameModeCard(
                    context,
                    'Play vs AI',
                    'Challenge our unbeatable AI!',
                    Icons.smart_toy,
                    () {
                      gameProvider.resetGame();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(isAIGame: true),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildGameModeCard(
                    context,
                    'Play with Friend',
                    'Challenge a friend locally',
                    Icons.people,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(isAIGame: false),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),

                  
                  Card(
                    elevation: 8,
                    color: themeProvider.isDarkMode ? Colors.grey[850] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildQuickSettingTile(
                            'Theme',
                            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,

                            Switch(
                              activeColor: Color(0xFFFBAB57),
                              inactiveThumbColor: Color(0xFFFBAB57),
                              inactiveTrackColor: Color(0xFFFBAB57).withOpacity(0.2),
                              
                              value: themeProvider.isDarkMode,
                              onChanged: (_) => themeProvider.toggleTheme(),
                            ),
                            themeProvider.isDarkMode ? Colors.white : Color(0xFFFBAB57),
                          ),
                          _buildQuickSettingTile(
                            'Sound',
                            Icons.volume_up,
                            Switch(
                              activeColor: Color(0xFFFBAB57),
                              inactiveThumbColor: Color(0xFFFBAB57),
                              inactiveTrackColor: Color(0xFFFBAB57).withOpacity(0.2),
                              value: gameProvider.isSoundEnabled,
                              onChanged: (_) => gameProvider.toggleSound(),
                            ),
                            themeProvider.isDarkMode ? Colors.white : Color(0xFFFBAB57),
                          ),
                          _buildQuickSettingTile(
                            'Music',
                            Icons.music_note,
                            Switch(
                              activeColor: Color(0xFFFBAB57),
                              inactiveThumbColor: Color(0xFFFBAB57),
                              inactiveTrackColor: Color(0xFFFBAB57).withOpacity(0.2),
                              value: gameProvider.isBackgroundMusicPlaying,
                              onChanged: (_) => gameProvider.toggleBackgroundMusic(),
                            ),
                            themeProvider.isDarkMode ? Colors.white : Color(0xFFFBAB57),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
     width: 110,
     
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: themeProvider.isDarkMode ? Colors.grey[850] : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: themeProvider.isDarkMode ? Colors.white70 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),color: themeProvider.isDarkMode ? Colors.grey[850] : Colors.white,
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFBAB57).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Color(0xFFFBAB57),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: 200)).scale();
  }

  Widget _buildQuickSettingTile(String title, IconData icon, Widget trailing,Color color) {
    return ListTile(
      leading: Icon(icon,color: color,),
      title: Text(title),
      trailing: trailing,
    );
  }
}