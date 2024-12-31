// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tic_tac_toe_remaster/providers/game_provider.dart';
// import 'package:tic_tac_toe_remaster/providers/theme_provider.dart';

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final gameProvider = Provider.of<GameProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//         backgroundColor: themeProvider.isDarkMode ? Colors.grey[900] : Colors.orange[300],
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           _buildSettingCard(
//             icon: Icons.palette,
//             title: 'Theme',
//             subtitle: 'Toggle dark/light mode',
//             trailing: Switch(
//               value: themeProvider.isDarkMode,
//               onChanged: (_) => themeProvider.toggleTheme(),
//             ),
//           ),
//           _buildSettingCard(
//             icon: Icons.music_note,
//             title: 'Background Music',
//             subtitle: 'Toggle game music',
//             trailing: Switch(
//               value: gameProvider.isBackgroundMusicPlaying,
//               onChanged: (_) => gameProvider.toggleBackgroundMusic(),
//             ),
//           ),
//           _buildSettingCard(
//             icon: Icons.volume_up,
//             title: 'Sound Effects',
//             subtitle: 'Toggle game sounds',
//             trailing: Switch(
//               value: gameProvider.isSoundEnabled,
//               onChanged: (_) => gameProvider.toggleSound(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Widget trailing,
//   }) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Icon(icon),
//         title: Text(title),
//         subtitle: Text(subtitle),
//         trailing: trailing,
//       ),
//     );
//   }
// }