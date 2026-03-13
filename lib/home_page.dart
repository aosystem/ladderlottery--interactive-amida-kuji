import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:ladderlottery/l10n/app_localizations.dart';
import 'package:ladderlottery/ad_banner_widget.dart';
import 'package:ladderlottery/ad_manager.dart';
import 'package:ladderlottery/const_value.dart';
import 'package:ladderlottery/parse_locale_tag.dart';
import 'package:ladderlottery/setting_page.dart';
import 'package:ladderlottery/model.dart';
import 'package:ladderlottery/audio_play.dart';
import 'package:ladderlottery/canvas_custom_painter.dart';
import 'package:ladderlottery/game.dart';
import 'package:ladderlottery/game_mode.dart';
import 'package:ladderlottery/theme_mode_number.dart';
import 'package:ladderlottery/theme_color.dart';
import 'package:ladderlottery/loading_screen.dart';
import 'package:ladderlottery/main.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> with SingleTickerProviderStateMixin {
  late AdManager _adManager;
  final AudioPlay _audioPlay = AudioPlay();
  final Game _game = Game();
  Timer? _timer;
  double _screenWidth = 0;
  double _screenHeight = 0;
  double _bgImageSize = 0;
  double _bgImageAngle = 0;
  late ThemeColor _themeColor;
  bool _isReady = false;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    _adManager = AdManager();
    _audioPlay.playZero();
    _game.setAudioPlay(_audioPlay);
    _audioPlay.soundVolume = Model.soundVolume;
    _game.lotteryCount = Model.lotteryCount;
    _game.shuffle();
    _setSpeed();
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  void dispose() {
    _adManager.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _setSpeed() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: (1000 ~/ Model.lotterySpeed)), (timer) {
      setState(() {
        _game.periodic();
        _bgImageAngle -= 0.001;
        if (_bgImageAngle < -314159265) {
          _bgImageAngle = 0;
        }
      });
    });
  }

  Future<void> _onOpenSetting() async {
    final updated = await Navigator.push<bool>(context,MaterialPageRoute(builder: (_) => const SettingPage()));
    if (!mounted) {
      return;
    }
    if (updated == true) {
      final mainState = context.findAncestorStateOfType<MainAppState>();
      if (mainState != null) {
        mainState
          ..themeMode = ThemeModeNumber.numberToThemeMode(Model.themeNumber)
          ..locale = parseLocaleTag(Model.languageCode)
          ..setState(() {});
      }
      _game.lotteryCount = Model.lotteryCount;
      if (_game.lastLotteryCount != _game.lotteryCount) {
        _game.lastLotteryCount = _game.lotteryCount;
        _game.shuffle();
      }
      _audioPlay.soundVolume = Model.soundVolume;
      _setSpeed();
      _isFirst = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady == false) {
      return const LoadingScreen();
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(context: context);
    }
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _bgImageSize = max(_screenWidth,_screenHeight);
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: _decoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Opacity(
              opacity: (_game.gameMode == GameMode.make || _game.gameMode == GameMode.action) ? 0.1 : 1,
              child: IconButton(
                icon: const Icon(Icons.settings),
                color: _themeColor.mainForeColor,
                tooltip: l.setting,
                onPressed: _onOpenSetting,
              ),
            ),
            const SizedBox(width:10),
          ],
        ),
        body: SafeArea(
          child: Stack(children:[
            _background(),
            Column(children:[
              Expanded(
                child: Column(children:[
                  CustomPaint(
                    painter: CanvasCustomPainter(game: _game),
                    size: Size(_screenWidth, _screenHeight - 290),
                  ),
                  Row(children:[
                    _shuffleButton(l),
                    _startButton(l),
                  ])
                ]),
              ),
            ])
          ])
        ),
        bottomNavigationBar: AdBannerWidget(adManager: _adManager),
      )
    );
  }

  Decoration _decoration() {
    if (Model.backgroundImageNumber == 0) {
      return BoxDecoration(
        color: _themeColor.mainBackColor,
      );
    } else {
      return const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ConstValue.imageSpace1),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _background() {
    if (Model.backgroundImageNumber == 0) {
      return Container(
        color: _themeColor.mainBackColor,
      );
    } else {
      return Transform.rotate(
        angle: _bgImageAngle,
        child: Transform.scale(
          scale: 2.6,
          child: Image.asset(
            ConstValue.imageBackGrounds[Model.backgroundImageNumber],
            width: _bgImageSize,
            height: _bgImageSize,
          ),
        ),
      );
    }
  }

  Widget _shuffleButton(AppLocalizations l) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            if (_game.gameMode != GameMode.make && _game.gameMode != GameMode.action) {
              _audioPlay.soundVolume = Model.soundVolume;
              _audioPlay.play01();
              _game.shuffle();
            }
          },
          child: Opacity(
            opacity: (_game.gameMode == GameMode.make || _game.gameMode == GameMode.action) ? 0.1 : 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              decoration: BoxDecoration(
                color: _themeColor.mainButtonBackColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(l.shuffle,
                  style: TextStyle(
                    color: _themeColor.mainButtonForeColor,
                    fontSize: 20.0,
                  )
                )
              )
            )
          )
        )
      )
    );
  }

  Widget _startButton(AppLocalizations l) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(3,0,3,0),
        child: GestureDetector(
          onTap: () {
            if (_game.gameMode != GameMode.make && _game.gameMode != GameMode.action) {
              _audioPlay.soundVolume = Model.soundVolume;
              _audioPlay.play02();
              _game.start();
            }
          },
          child: Opacity(
            opacity: (_game.gameMode == GameMode.make || _game.gameMode == GameMode.action) ? 0.1 : 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              decoration: BoxDecoration(
                color: _themeColor.mainButtonBackColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(l.start,
                  style: TextStyle(
                    color: _themeColor.mainButtonForeColor,
                    fontSize: 20.0,
                  )
                )
              )
            )
          )
        )
      )
    );
  }

}
