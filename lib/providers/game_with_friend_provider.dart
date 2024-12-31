import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_remaster/providers/stats_provider.dart';
import '../models/game_state.dart';

class GameWithFriendProvider extends ChangeNotifier {
  GameState _gameState = GameState.initial();
  GameState get gameState => _gameState;
  
  List<int> _newMove = [-1, -1];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;

  void makeMove(int row, int col,BuildContext context) {
    if (_gameState.board[row][col] == CellState.empty &&
        _gameState.status == GameStatus.playing) {
      CellState currentPlayer = _gameState.isPlayerTurn ? CellState.x : CellState.o;
      _updateBoard(row, col, currentPlayer);
      if (currentPlayer == CellState.x) {
        _gameState.playerMoves.add([row, col]);
      } else {
        _gameState.aiMoves.add([row, col]); // Renaming this might be better (e.g., `opponentMoves`)
      }
      _newMove = [row, col];
      _playSound('move');
      
      if (_gameState.playerMoves.length == 4 || _gameState.aiMoves.length == 4) {
        _checkGameStatus(currentPlayer,context);
        if (_gameState.status == GameStatus.playing) {
          _removeFirstMove(currentPlayer);
        }
      } else {
        _checkGameStatus(currentPlayer,context);
      }

      if (_gameState.status != GameStatus.playing) {
        _playGameEndSound();
      }
    }
  }

  void _updateBoard(int row, int col, CellState state) {
    final newBoard = List<List<CellState>>.from(_gameState.board);
    newBoard[row][col] = state;
    _gameState = _gameState.copyWith(
      board: newBoard,
      isPlayerTurn: !_gameState.isPlayerTurn,
    );
    notifyListeners();
  }

  void _removeFirstMove(CellState player) {
    List<List<int>> moves = player == CellState.x ? _gameState.playerMoves : _gameState.aiMoves;
    List<int> firstMove = moves.removeAt(0);
    
    final newBoard = List<List<CellState>>.from(_gameState.board);
    newBoard[firstMove[0]][firstMove[1]] = CellState.empty;
    
    _gameState = _gameState.copyWith(
      board: newBoard,
      playerMoves: player == CellState.x ? moves : _gameState.playerMoves,
      aiMoves: player == CellState.o ? moves : _gameState.aiMoves,
    );
    notifyListeners();
  }

  void _checkGameStatus(CellState lastMove, BuildContext context) {
  if (_checkWinner(lastMove)) {
    bool isPlayerWin = lastMove == CellState.x;
    _gameState = _gameState.copyWith(
      status: isPlayerWin ? GameStatus.playerWin : GameStatus.aiWin,
    );
    
    // Update stats
    Provider.of<StatsProvider>(context, listen: false)
        .updateStats(isWin: isPlayerWin);
  }
  notifyListeners();
}

  bool _checkWinner(CellState player) {
    for (int i = 0; i < 3; i++) {
      if (_gameState.board[i][0] == player &&
          _gameState.board[i][1] == player &&
          _gameState.board[i][2] == player) return true;
      if (_gameState.board[0][i] == player &&
          _gameState.board[1][i] == player &&
          _gameState.board[2][i] == player) return true;
    }
    if (_gameState.board[0][0] == player &&
        _gameState.board[1][1] == player &&
        _gameState.board[2][2] == player) return true;
    if (_gameState.board[0][2] == player &&
        _gameState.board[1][1] == player &&
        _gameState.board[2][0] == player) return true;
    return false;
  }

  void resetGame() {
    _gameState = GameState.initial();
    _newMove = [-1, -1];
    _playSound('reset');
    notifyListeners();
  }

  void _playSound(String soundName) {
    if (_isSoundEnabled) {
      _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    }
  }

  void _playGameEndSound() {
    if (_gameState.status == GameStatus.playerWin) {
      _playSound('win');
    } else if (_gameState.status == GameStatus.aiWin) { // This might be better renamed as `opponentWin`
      _playSound('lose');
    }
  }

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }

  bool isNewMove(int row, int col) {
    return _newMove[0] == row && _newMove[1] == col;
  }
}
