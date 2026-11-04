import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/audio_player_service.dart';
import 'services/extension_service.dart';
import 'services/library_service.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final library = LibraryService();
  await library.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: library),
      ChangeNotifierProvider(create: (_) => AudioPlayerService()),
      ChangeNotifierProvider(create: (_) => ExtensionService()),
    ],
    child: const NanamiApp(),
  ));
}

class NanamiApp extends StatelessWidget {
  const NanamiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanami',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true, brightness: Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
