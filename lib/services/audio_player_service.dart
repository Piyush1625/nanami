import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<Track> _queue = [];
  int _currentIndex = -1;
  bool get isPlaying => _player.playing;
  Track? get currentTrack => (_currentIndex >= 0 && _currentIndex < _queue.length) ? _queue[_currentIndex] : null;

  Future<void> setQueue(List<Track> tracks, {int startIndex = 0}) async {
    _queue = tracks;
    _currentIndex = startIndex;
    await _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    if (currentTrack == null) return;
    await _player.setFilePath(currentTrack!.path);
    notifyListeners();
  }

  Future<void> play() async { await _player.play(); notifyListeners(); }
  Future<void> pause() async { await _player.pause(); notifyListeners(); }
  Future<void> next() async { if (_currentIndex < _queue.length - 1) { _currentIndex++; await _loadCurrent(); await _player.play(); notifyListeners(); } }
  Future<void> previous() async { if (_currentIndex > 0) { _currentIndex--; await _loadCurrent(); await _player.play(); notifyListeners(); } }
  @override void dispose() { _player.dispose(); super.dispose(); }
}
