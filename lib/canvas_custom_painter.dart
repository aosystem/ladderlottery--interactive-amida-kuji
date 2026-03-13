import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ladderlottery/const_value.dart';
import 'package:ladderlottery/game.dart';
import 'package:ladderlottery/game_mode.dart';

class CanvasCustomPainter extends CustomPainter {
  final Game game;
  CanvasCustomPainter({required this.game});

  @override
  void paint(Canvas canvas, Size size) async {
    const double strokeWidth = 10.0;
    final Paint paint = Paint()
      ..color = const Color.fromRGBO(150,150,230,1)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.src;
    final double iconSize = size.width * 0.08;
    final double gapX = size.width / (game.lotteryCount + 1);
    final double gapY = (size.height - (iconSize * 4)) / 20;
    if (game.gameMode == GameMode.ready) {
      _drawHeaderFooterLine(canvas,size,paint,gapX,iconSize);
    } else if (game.gameMode == GameMode.make) {
      _drawVerticalLine(canvas,size,paint,gapX,iconSize);
      _drawHorizontalLine(canvas,paint,gapX,gapY,iconSize,strokeWidth,game.ladderY);
    } else {
      _drawVerticalLine(canvas,size,paint,gapX,iconSize);
      _drawHorizontalLine(canvas,paint,gapX,gapY,iconSize,strokeWidth,20);
      _drawIcon(canvas,gapX,gapY,iconSize,strokeWidth);
    }
    _drawFixedIcon(canvas,size,iconSize);
  }
  void _drawHeaderFooterLine(Canvas canvas, Size size, Paint paint, double gapX, double iconSize) {
    for (int i = 0; i < game.lotteryCount; i++) {
      canvas.drawLine(Offset(gapX * i + gapX, iconSize), Offset(gapX * i + gapX, iconSize * 2), paint);
      canvas.drawLine(Offset(gapX * i + gapX, size.height - iconSize * 2),Offset(gapX * i + gapX, size.height - iconSize), paint);
    }
  }
  void _drawVerticalLine(Canvas canvas, Size size, Paint paint, double gapX, double iconSize) {
    for (int i = 0; i < game.lotteryCount; i++) {
      canvas.drawLine(Offset(gapX * i + gapX, iconSize), Offset(gapX * i + gapX, size.height - iconSize), paint);
    }
  }
  void _drawHorizontalLine(Canvas canvas, Paint paint, double gapX, double gapY, double iconSize, double strokeWidth, int countY) {
    for (int x = 0; x < game.lotteryCount - 1; x++) {
      final double x1 = gapX * x + gapX;
      final double x2 = gapX * (x + 1) + gapX;
      for (int y = 0; y < countY; y++) {
        if (game.ladders[x][y] == 1) {
          final double y1 = gapY * y + (iconSize * 2) + (strokeWidth);
          canvas.drawLine(Offset(x1, y1), Offset(x2, y1), paint);
        }
      }
    }
  }
  void _drawIcon(Canvas canvas, double gapX, double gapY, double iconSize, double strokeWidth) {
    final double y = gapY * game.iconPositionY + iconSize + (strokeWidth / 2);
    for (int i = 0; i < game.lotteryCount; i++) {
      final double x = gapX * game.iconPositionX[i] + gapX - (iconSize / 2);
      _imageAlphabetDraw(canvas, iconSize, x, y, game.alphabets[i]);
    }
  }
  void _drawFixedIcon(Canvas canvas, Size size, double iconSize) {
    for (int i = 0; i < game.lotteryCount; i++) {
      double gapX = size.width / (game.lotteryCount + 1);
      double x = gapX * i + gapX - (iconSize / 2);
      _imageAlphabetDraw(canvas, iconSize, x, iconSize * 0.2, game.alphabets[i]);
      _imageNumberDraw(canvas, iconSize, x, size.height - (iconSize * 1.2), game.numbers[i]);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Future<void> _imageAlphabetDraw(Canvas canvas, double iconSize, double x, double y, int index) async {
    final Completer<void> completer = Completer<void>();
    final ImageStream stream = AssetImage(ConstValue.imageIconAlphabets[index]).resolve(ImageConfiguration.empty);
    void listener(ImageInfo info, bool synchronousCall) {
      final img = info.image;
      try {
        canvas.drawImageRect(
          img,
          Rect.fromPoints(const Offset(0, 0), Offset(img.width.toDouble(), img.height.toDouble())),
          Rect.fromPoints(Offset(x, y), Offset(x + iconSize, y + iconSize)),
          Paint(),
        );
      } catch(e) {
      }
      completer.complete();
    }
    stream.addListener(ImageStreamListener(listener));
    await completer.future;
  }

  Future<void> _imageNumberDraw(Canvas canvas, double iconSize, double x, double y, int index) async {
    final Completer<void> completer = Completer<void>();
    final ImageStream stream = AssetImage(ConstValue.imageIconNumbers[index]).resolve(ImageConfiguration.empty);
    void listener(ImageInfo info, bool synchronousCall) {
      final img = info.image;
      try {
        canvas.drawImageRect(
          img,
          Rect.fromPoints(const Offset(0, 0), Offset(img.width.toDouble(), img.height.toDouble())),
          Rect.fromPoints(Offset(x, y), Offset(x + iconSize, y + iconSize)),
          Paint(),
        );
      } catch(e) {
      }
      completer.complete();
    }
    stream.addListener(ImageStreamListener(listener));
    await completer.future;
  }

}
