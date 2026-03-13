import 'dart:math';

import 'package:ladderlottery/game_mode.dart';
import 'package:ladderlottery/audio_play.dart';
import 'package:ladderlottery/model.dart';

class Game {
  late AudioPlay _audioPlay;
  int lotteryCount = 3;
  int lastLotteryCount = 3;
  List<int> alphabets = [];
  List<int> numbers = [];
  List<List<int>> ladders = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ];
  GameMode gameMode = GameMode.ready;
  int tick = 0;
  double iconPositionY = 0.0;
  List<double> iconPositionX = [0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0];
  List<int> ladderXs = [0,1,2,3,4,5,6,7,8];
  int ladderY = -1;

  Game() {
    shuffle();
  }
  void setAudioPlay(AudioPlay audioPlay) {
    _audioPlay = audioPlay;
  }
  void shuffle() {
    alphabets = [];
    numbers = [];
    for (int i = 0; i < lotteryCount; i++) {
      alphabets.add(i);
      numbers.add(i);
    }
    alphabets.shuffle();
    numbers.shuffle();
    iconPositionY = 0.0;
    iconPositionX = [0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0];
    ladderY = -1;
    ladderXs = [0,1,2,3,4,5,6,7,8];
    tick = 0;
    gameMode = GameMode.ready;
  }
  void start() {
    for (int x = 0; x < ladders.length; x++) {
      for (int y = 0; y < ladders[0].length; y++) {
        ladders[x][y] = 0;
      }
    }
    final int seed = DateTime.now().millisecondsSinceEpoch;
    Random random = Random(seed);
    for (int x = 0; x < lotteryCount - 1; x++) {
      for (int y = 0; y < 20; y++) {
        final int rnd = (x == 0) ? random.nextInt(2) : random.nextInt(4);
        if (x == 0) {
          ladders[x][y] = (rnd == 0) ? 0 : 1;
        } else {
          if (ladders[x - 1][y] != 1) {
            ladders[x][y] = (rnd == 0) ? 0 : 1;
          }
        }
      }
    }
    iconPositionY = 0.0;
    iconPositionX = [0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0];
    ladderY = -1;
    ladderXs = [0,1,2,3,4,5,6,7,8];
    tick = 0;
    gameMode = GameMode.make;
  }
  void periodic() {
    if (gameMode == GameMode.ready || gameMode == GameMode.end) {
      return;
    }
    if (gameMode == GameMode.make) {
      ladderY = tick ~/ 20;
      if (tick % 20 == 0) {
        _audioPlay.soundVolume = Model.soundVolume;
        _audioPlay.play01();
      }
      if (ladderY >= 20) {
        tick = 0;
        ladderY = -1;
        gameMode = GameMode.action;
      }
    } else {
      if (ladderY >= 20) {
        gameMode = GameMode.end;
        _audioPlay.soundVolume = Model.soundVolume;
        _audioPlay.play03();
        return;
      }
      if (tick % 60 < 30) {
        if (tick % 60 == 0) {
          _audioPlay.soundVolume = Model.soundVolume;
          _audioPlay.play01();
        }
        iconPositionY += 1 / 30;
        if (tick % 60 == 29) {
          ladderY += 1;
          iconPositionY = ladderY.toDouble() + 1;
        }
      } else {
        bool moveFlag = false;
        for (int x = 0; x < lotteryCount; x++) {
          if (ladderXs[x] < lotteryCount - 1 && ladders[ladderXs[x]][ladderY] == 1) {
            iconPositionX[x] += 1 / 30;
            moveFlag = true;
          } else if (ladderXs[x] >= 1 && ladders[ladderXs[x] - 1][ladderY] == 1) {
            iconPositionX[x] -= 1 / 30;
            moveFlag = true;
          }
        }
        if (tick % 60 == 30 && moveFlag) {
          _audioPlay.soundVolume = Model.soundVolume;
          _audioPlay.play02();
        }
        if (tick % 60 == 59) {
          for (int x = 0; x < lotteryCount; x++) {
            iconPositionX[x] = iconPositionX[x].round().toDouble();
            ladderXs[x] = iconPositionX[x].toInt();
          }
        }
      }
    }
    tick += 1;
  }

}
