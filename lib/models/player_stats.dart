class PlayerStats {
  int wins;
  int losses;
  int draws;
  int totalGames;
  double winRate;

  PlayerStats({
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.totalGames = 0,
    this.winRate = 0.0,
  });

  void updateStats({bool isWin = false, bool isDraw = false}) {
    totalGames++;
    if (isWin) wins++;
    else if (isDraw) draws++;
    else losses++;
    winRate = (wins / totalGames) * 100;
  }

  Map<String, dynamic> toJson() => {
    'wins': wins,
    'losses': losses,
    'draws': draws,
    'totalGames': totalGames,
    'winRate': winRate,
  };

  factory PlayerStats.fromJson(Map<String, dynamic> json) => PlayerStats(
    wins: json['wins'] ?? 0,
    losses: json['losses'] ?? 0,
    draws: json['draws'] ?? 0,
    totalGames: json['totalGames'] ?? 0,
    winRate: json['winRate'] ?? 0.0,
  );
}