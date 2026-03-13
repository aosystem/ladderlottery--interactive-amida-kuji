import 'package:just_audio/just_audio.dart';

import 'package:ladderlottery/const_value.dart';

class AudioPlay {
  static final List<AudioPlayer> _player01 = [
    AudioPlayer(),
    AudioPlayer(),
    AudioPlayer(),
  ];
  static final List<AudioPlayer> _player02 = [
    AudioPlayer(),
    AudioPlayer(),
    AudioPlayer(),
  ];
  static final List<AudioPlayer> _player03 = [
    AudioPlayer(),
    AudioPlayer(),
    AudioPlayer(),
  ];
  int _player01Ptr = 0;
  int _player02Ptr = 0;
  int _player03Ptr = 0;

  double _soundVolume = 0.0;

  AudioPlay() {
    constructor();
  }
  void constructor() async {
    for (int i = 0; i < _player01.length; i++) {
      await _player01[i].setVolume(0);
      await _player01[i].setAsset(ConstValue.audioSlide);
    }
    for (int i = 0; i < _player02.length; i++) {
      await _player02[i].setVolume(0);
      await _player02[i].setAsset(ConstValue.audioSet);
    }
    for (int i = 0; i < _player03.length; i++) {
      await _player03[i].setVolume(0);
      await _player03[i].setAsset(ConstValue.audioFinish);
    }
    playZero();
  }
  void dispose() {
    for (int i = 0; i < _player01.length; i++) {
      _player01[i].dispose();
    }
    for (int i = 0; i < _player02.length; i++) {
      _player02[i].dispose();
    }
    for (int i = 0; i < _player03.length; i++) {
      _player03[i].dispose();
    }
  }
  double get soundVolume {
    return _soundVolume;
  }
  set soundVolume(double vol) {
    _soundVolume = vol;
  }
  void playZero() async {
    AudioPlayer ap = AudioPlayer();
    await ap.setAsset(ConstValue.audioZero);
    await ap.load();
    await ap.play();
  }
  //
  void play01() async {
    if (_soundVolume == 0) {
      return;
    }
    _player01Ptr += 1;
    if (_player01Ptr >= _player01.length) {
      _player01Ptr = 0;
    }
    await _player01[_player01Ptr].setVolume(_soundVolume);
    await _player01[_player01Ptr].pause();
    await _player01[_player01Ptr].seek(Duration.zero);
    await _player01[_player01Ptr].play();
  }
  void play02() async {
    if (_soundVolume == 0) {
      return;
    }
    _player02Ptr += 1;
    if (_player02Ptr >= _player02.length) {
      _player02Ptr = 0;
    }
    await _player02[_player02Ptr].setVolume(_soundVolume);
    await _player02[_player02Ptr].pause();
    await _player02[_player02Ptr].seek(Duration.zero);
    await _player02[_player02Ptr].play();
  }
  void play03() async {
    if (_soundVolume == 0) {
      return;
    }
    _player03Ptr += 1;
    if (_player03Ptr >= _player03.length) {
      _player03Ptr = 0;
    }
    await _player03[_player03Ptr].setVolume(_soundVolume);
    await _player03[_player03Ptr].pause();
    await _player03[_player03Ptr].seek(Duration.zero);
    await _player03[_player03Ptr].play();
  }
}
