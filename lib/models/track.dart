class Track {
  final int? id;
  final String title;
  final String artist;
  final String album;
  final String path;
  final int durationMs;

  Track({this.id, required this.title, required this.artist, required this.album, required this.path, required this.durationMs});

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'artist': artist, 'album': album, 'path': path, 'durationMs': durationMs};
  factory Track.fromMap(Map<String, dynamic> m) => Track(id: m['id'], title: m['title'], artist: m['artist'], album: m['album'], path: m['path'], durationMs: m['durationMs']);
}
