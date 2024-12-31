import '../models/game_state.dart';

class Move {
  int row;
  int col;
  int score;

  Move({required this.row, required this.col, required this.score});
 }

Move findBestMove(List<List<CellState>> board) {
  int bestScore = -1000;
  Move bestMove = Move(row: -1, col: -1, score: 0);

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == CellState.empty) {
        board[i][j] = CellState.o;
        int moveScore = minimax(board, 0, false, -1000, 1000);
        board[i][j] = CellState.empty;

        if (moveScore > bestScore) {
          bestScore = moveScore;
          bestMove = Move(row: i, col: j, score: bestScore);
        }
      }
    }
  }

  return bestMove;
}

int minimax(List<List<CellState>> board, int depth, bool isMaximizing, int alpha, int beta) {
  int score = evaluate(board);

  if (score == 10) return score - depth;
  if (score == -10) return score + depth;
  if (!board.any((row) => row.contains(CellState.empty))) return 0;

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == CellState.empty) {
          board[i][j] = CellState.o;
          int eval = minimax(board, depth + 1, false, alpha, beta);
          bestScore = maxNumber(bestScore, eval);
          board[i][j] = CellState.empty;
          alpha = maxNumber(alpha, eval);
          if (beta <= alpha) break;
        }
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == CellState.empty) {
          board[i][j] = CellState.x;
          int eval = minimax(board, depth + 1, true, alpha, beta);
          bestScore = minNumber(bestScore, eval);
          board[i][j] = CellState.empty;
          beta = minNumber(beta, eval);
          if (beta <= alpha) break;
        }
      }
    }
    return bestScore;
  }
}

int evaluate(List<List<CellState>> board) {
  // Check rows, columns, and diagonals
  for (int i = 0; i < 3; i++) {
    if (board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
      if (board[i][0] == CellState.o) return 10;
      if (board[i][0] == CellState.x) return -10;
    }
    if (board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
      if (board[0][i] == CellState.o) return 10;
      if (board[0][i] == CellState.x) return -10;
    }
  }
  if (board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    if (board[0][0] == CellState.o) return 10;
    if (board[0][0] == CellState.x) return -10;
  }
  if (board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
    if (board[0][2] == CellState.o) return 10;
    if (board[0][2] == CellState.x) return -10;
  }
  return 0;
}

int maxNumber(int a, int b) => (a > b) ? a : b;
int minNumber(int a, int b) => (a < b) ? a : b;
