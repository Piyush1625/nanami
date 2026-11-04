import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/audio_player_service.dart';
import '../../services/library_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lib = context.watch<LibraryService>();
    final audio = context.watch<AudioPlayerService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nanami'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () async {
              final dir = await FilePicker.platform.getDirectoryPath();
              if (dir != null) {
                final n = await lib.scanDirectory(dir);
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Indexed $n tracks')));
              }
            },
          ),
        ],
      ),
      body: lib.tracks.isEmpty
          ? const Center(child: Text('No tracks yet. Tap the folder icon.'))
          : ListView.builder(
              itemCount: lib.tracks.length,
              itemBuilder: (_, i) {
                final t = lib.tracks[i];
                return ListTile(
                  leading: const Icon(Icons.audiotrack),
                  title: Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(t.artist),
                  onTap: () async {
                    await audio.setQueue(lib.tracks, startIndex: i);
                    await audio.play();
                  },
                );
              },
            ),
      bottomNavigationBar: audio.currentTrack == null ? null : Material(
        elevation: 8,
        child: SafeArea(
          top: false,
          child: ListTile(
            leading: IconButton(
              icon: Icon(audio.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () => audio.isPlaying ? audio.pause() : audio.play(),
            ),
            title: Text(audio.currentTrack!.title, maxLines: 1),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.skip_previous), onPressed: audio.previous),
              IconButton(icon: const Icon(Icons.skip_next), onPressed: audio.next),
            ]),
          ),
        ),
      ),
    );
  }
}
