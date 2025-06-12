import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/ai_logic.dart';
import 'stats_provider.dart';

class GameProvider extends ChangeNotifier {
  GameState _gameState = GameState.initial();
  GameMode _gameMode = GameMode.normal;
  bool _isSoundEnabled = true;
  bool _isBackgroundMusicPlaying = false;
  List<List<int>> _newMoves = [];

  GameState get gameState => _gameState;
  GameMode get gameMode => _gameMode;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isBackgroundMusicPlaying => _isBackgroundMusicPlaying;

  void setGameMode(GameMode mode) {
    _gameMode = mode;
    notifyListeners();
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  void toggleBackgroundMusic() {
    _isBackgroundMusicPlaying = !_isBackgroundMusicPlaying;
    notifyListeners();
  }

  bool isNewMove(int row, int col) {
    return _newMoves.any((move) => move[0] == row && move[1] == col);
  }

  void makeMove(int row, int col) {
    if (_gameState.status != GameStatus.playing || _gameState.board[row][col] != CellState.empty) {
      return;
    }

    // Clear previous new moves
    _newMoves.clear();

    // Make player move
    _gameState.board[row][col] = CellState.x;
    _gameState.playerMoves.add([row, col]);
    _newMoves.add([row, col]);

    // Check for win after player move
    _checkGameStatus();
    if (_gameState.status != GameStatus.playing) {
      notifyListeners();
      return;
    }

    // Handle special game modes for player moves
    _handleGameModeLogic(isPlayerMove: true);

    // Check again after potential move removal
    _checkGameStatus();
    if (_gameState.status != GameStatus.playing) {
      notifyListeners();
      return;
    }

    // AI's turn
    _gameState.isPlayerTurn = false;
    notifyListeners();

    // Delay AI move for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      _makeAIMove();
    });
  }

  void _makeAIMove() {
    final bestMove = findBestMove(_gameState.board);
    if (bestMove.row != -1 && bestMove.col != -1) {
      _gameState.board[bestMove.row][bestMove.col] = CellState.o;
      _gameState.aiMoves.add([bestMove.row, bestMove.col]);
      _newMoves.add([bestMove.row, bestMove.col]);

      // Check for win after AI move
      _checkGameStatus();
      if (_gameState.status != GameStatus.playing) {
        notifyListeners();
        return;
      }

      // Handle special game modes for AI moves
      _handleGameModeLogic(isPlayerMove: false);

      // Check again after potential move removal
      _checkGameStatus();
    }

    _gameState.isPlayerTurn = true;
    notifyListeners();
  }

  void _handleGameModeLogic({required bool isPlayerMove}) {
    switch (_gameMode) {
      case GameMode.xtreme:
        _handleXtremeMode(isPlayerMove: isPlayerMove);
        break;
      case GameMode.ultraXtreme:
        _handleUltraXtremeMode(isPlayerMove: isPlayerMove);
        break;
      case GameMode.normal:
        break;
    }
  }

  void _handleXtremeMode({required bool isPlayerMove}) {
    if (isPlayerMove && _gameState.playerMoves.length > 3) {
      // Remove first player move
      final firstMove = _gameState.playerMoves.removeAt(0);
      _gameState.board[firstMove[0]][firstMove[1]] = CellState.empty;
    } else if (!isPlayerMove && _gameState.aiMoves.length > 3) {
      // Remove first AI move
      final firstMove = _gameState.aiMoves.removeAt(0);
      _gameState.board[firstMove[0]][firstMove[1]] = CellState.empty;
    }
  }

  void _handleUltraXtremeMode({required bool isPlayerMove}) {
    if (isPlayerMove && _gameState.playerMoves.length >= 4) {
      // Remove a random player move (not the most recent one)
      final random = Random();
      final availableMoves = _gameState.playerMoves.sublist(0, _gameState.playerMoves.length - 1);

      if (availableMoves.isNotEmpty) {
        final randomIndex = random.nextInt(availableMoves.length);
        final moveToRemove = availableMoves[randomIndex];

        // Remove from board
        _gameState.board[moveToRemove[0]][moveToRemove[1]] = CellState.empty;

        // Remove from moves list
        _gameState.playerMoves.removeWhere((move) => move[0] == moveToRemove[0] && move[1] == moveToRemove[1]);
      }
    } else if (!isPlayerMove && _gameState.aiMoves.length >= 4) {
      // Remove a random AI move (not the most recent one)
      final random = Random();
      final availableMoves = _gameState.aiMoves.sublist(0, _gameState.aiMoves.length - 1);

      if (availableMoves.isNotEmpty) {
        final randomIndex = random.nextInt(availableMoves.length);
        final moveToRemove = availableMoves[randomIndex];

        // Remove from board
        _gameState.board[moveToRemove[0]][moveToRemove[1]] = CellState.empty;

        // Remove from moves list
        _gameState.aiMoves.removeWhere((move) => move[0] == moveToRemove[0] && move[1] == moveToRemove[1]);
      }
    }
  }

  void _checkGameStatus() {
    // Check for wins
    if (_checkWin(CellState.x)) {
      _gameState.status = GameStatus.playerWin;
      return;
    } else if (_checkWin(CellState.o)) {
      _gameState.status = GameStatus.aiWin;
      return;
    }

    // Check for draw
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_gameState.board[i][j] == CellState.empty) {
          isDraw = false;
          break;
        }
      }
      if (!isDraw) break;
    }

    if (isDraw) {
      _gameState.status = GameStatus.draw;
    }
  }

  bool _checkWin(CellState player) {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_gameState.board[i][0] == player && _gameState.board[i][1] == player && _gameState.board[i][2] == player) {
        return true;
      }
    }

    // Check columns
    for (int j = 0; j < 3; j++) {
      if (_gameState.board[0][j] == player && _gameState.board[1][j] == player && _gameState.board[2][j] == player) {
        return true;
      }
    }

    // Check diagonals
    if (_gameState.board[0][0] == player && _gameState.board[1][1] == player && _gameState.board[2][2] == player) {
      return true;
    }

    if (_gameState.board[0][2] == player && _gameState.board[1][1] == player && _gameState.board[2][0] == player) {
      return true;
    }

    return false;
  }

  void resetGame() {
    _gameState = GameState.initial();
    _newMoves.clear();
    notifyListeners();
  }
}
