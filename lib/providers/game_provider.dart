import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_state.dart';
import '../utils/ai_logic.dart';

class GameProvider extends ChangeNotifier {
 

final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _isBackgroundMusicPlaying = false;

  bool get isBackgroundMusicPlaying => _isBackgroundMusicPlaying;
  

  void toggleBackgroundMusic() async {
    if (_isBackgroundMusicPlaying) {
      await _backgroundMusicPlayer.pause();
    } else {
      await _backgroundMusicPlayer.play(AssetSource('sounds/win.mp3'));
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    }
    _isBackgroundMusicPlaying = !_isBackgroundMusicPlaying;
    notifyListeners();
  }


  GameState _gameState = GameState.initial();
  GameState get gameState => _gameState;
  void resetGame() {
    _gameState = GameState.initial();
    notifyListeners();
  }
  List<int> _newMove = [-1, -1];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;


  void makeMove(int row, int col) {
    if (_gameState.board[row][col] == CellState.empty &&
        _gameState.isPlayerTurn &&
        _gameState.status == GameStatus.playing) {
      _updateBoard(row, col, CellState.x);
      _gameState.playerMoves.add([row, col]);
      _newMove = [row, col];
      _playSound('move');
      
      if (_gameState.playerMoves.length == 4) {
        _checkGameStatus(CellState.x);
        if (_gameState.status == GameStatus.playing) {
          _removeFirstMove(CellState.x);
        }
      } else {
        _checkGameStatus(CellState.x);
      }
      
      if (_gameState.status == GameStatus.playing) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _makeAIMove();
        });
      } else {
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

  void _makeAIMove() {
    final aiMove = findBestMove(_gameState.board);
    _updateBoard(aiMove.row, aiMove.col, CellState.o);
    _gameState.aiMoves.add([aiMove.row, aiMove.col]);
    _newMove = [aiMove.row, aiMove.col];
    _playSound('move');
    
    if (_gameState.aiMoves.length == 4) {
      _checkGameStatus(CellState.o);
      if (_gameState.status == GameStatus.playing) {
        _removeFirstMove(CellState.o);
      }
    } else {
      _checkGameStatus(CellState.o);
    }

    if (_gameState.status != GameStatus.playing) {
      _playGameEndSound();
    }
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

  void _checkGameStatus(CellState lastMove) {
    if (_checkWinner(lastMove)) {
      _gameState = _gameState.copyWith(
        status: lastMove == CellState.x ? GameStatus.playerWin : GameStatus.aiWin,
      );
      
    }
    notifyListeners();
  }

  bool _checkWinner(CellState player) {
    // Check rows, columns, and diagonals
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

 

  void _playSound(String soundName) {
    if (_isSoundEnabled) {
      _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    }
  }

  void _playGameEndSound() {
    if (_gameState.status == GameStatus.playerWin) {
      _playSound('win');
    } else if (_gameState.status == GameStatus.aiWin) {
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
