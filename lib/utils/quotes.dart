import 'dart:math';

final List<String> _quotes = [
  "Don't give up! You're improving with each game.",
  "The AI may have won, but your skills are growing!",
  "Remember, even grandmasters lose sometimes. Keep playing!",
  "That was a close one! You're getting better.",
  "Great effort! The more you play, the stronger you become.",
  "You're learning from each game. That's the path to mastery!",
  "The AI had to work hard for that win. You're a tough opponent!",
  "Every loss is a lesson. What can you learn from this game?",
  "You're developing great strategies. Keep it up!",
  "That was an exciting game! Ready for a rematch?",
  "Your moves are becoming more strategic. Well played!",
  "The AI is sweating! You're becoming a formidable player.",
  "You're making the AI earn its victories. Great job!",
  "Your gameplay is evolving. The AI better watch out!",
  "Close match! Your skills are clearly improving.",
  "You're thinking several moves ahead now. Impressive!",
  "The AI won this time, but your progress is undeniable.",
  "Your tactical thinking is sharper with each game. Keep it up!",
  "You're mastering the art of Tic Tac Toe. Well done!",
  "The AI may have won, but you're the one truly leveling up here."
];

String getRandomQuote() {
  final random = Random();
  return _quotes[random.nextInt(_quotes.length)];
}