enum CellState { empty, x, o }
enum GameStatus { playing, playerWin, aiWin }

class GameState {
  List<List<CellState>> board;
  bool isPlayerTurn;
  GameStatus status;
  List<List<int>> playerMoves;
  List<List<int>> aiMoves;

  GameState({
    required this.board,
    required this.isPlayerTurn,
    required this.status,
    required this.playerMoves,
    required this.aiMoves,
  });

  GameState.initial()
      : board = List.generate(3, (_) => List.filled(3, CellState.empty)),
        isPlayerTurn = true,
        status = GameStatus.playing,
        playerMoves = [],
        aiMoves = [];

  GameState copyWith({
    List<List<CellState>>? board,
    bool? isPlayerTurn,
    GameStatus? status,
    List<List<int>>? playerMoves,
    List<List<int>>? aiMoves,
  }) {
    return GameState(
      board: board ?? this.board,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      status: status ?? this.status,
      playerMoves: playerMoves ?? this.playerMoves,
      aiMoves: aiMoves ?? this.aiMoves,
    );
  }
}