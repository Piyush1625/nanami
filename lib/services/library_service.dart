import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/track.dart';

class LibraryService extends ChangeNotifier {
  Database? _db;
  List<Track> _tracks = [];
  List<Track> get tracks => List.unmodifiable(_tracks);

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'nanami_library.db');
    _db = await openDatabase(dbPath, version: 1, onCreate: (db, _) async {
      await db.execute('CREATE TABLE tracks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, artist TEXT, album TEXT, path TEXT UNIQUE, durationMs INTEGER)');
    });
    await reload();
  }

  Future<void> reload() async {
    if (_db == null) return;
    final rows = await _db!.query('tracks', orderBy: 'title COLLATE NOCASE');
    _tracks = rows.map(Track.fromMap).toList();
    notifyListeners();
  }

  Future<int> scanDirectory(String rootPath) async {
    if (_db == null) return 0;
    const exts = {'.mp3', '.flac', '.m4a', '.wav', '.ogg', '.opus', '.aac'};
    final dir = Directory(rootPath);
    if (!await dir.exists()) return 0;
    int added = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File || !exts.contains(p.extension(entity.path).toLowerCase())) continue;
      final title = p.basenameWithoutExtension(entity.path);
      try {
        await _db!.insert('tracks', {'title': title, 'artist': 'Unknown', 'album': p.basename(entity.parent.path), 'path': entity.path, 'durationMs': 0}, conflictAlgorithm: ConflictAlgorithm.ignore);
        added++;
      } catch (_) {}
    }
    await reload();
    return added;
  }
}
