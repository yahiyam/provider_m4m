import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m_app/dataBase/functions/playlist_functions.dart';
import 'package:m4m_app/dataBase/functions/recently_played.dart';
import 'package:m4m_app/dataBase/functions/song_access.dart';
import 'package:m4m_app/pages/splash_screen.dart';
import 'package:m4m_app/provider/dark_mode.dart';
import 'package:m4m_app/provider/song_access.dart';
import 'package:provider/provider.dart';

import 'dataBase/functions/liked_song.dart';
import 'dataBase/functions/most_played.dart';
import 'dataBase/models/songdb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(SongsAdapter().typeId)) {
    Hive.registerAdapter(SongsAdapter());
  }
  await Hive.openBox<Songs>('Songs');
  await Hive.openBox<List>('Playlist');
  await Hive.openBox('isdarkmode');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ViewModeState()),
      ChangeNotifierProvider(create: (context) => DarkModeState()),
      ChangeNotifierProvider(create: (context) => RecentSongs()),
      ChangeNotifierProvider(create: (context) => MostPlayedSongs()),
      ChangeNotifierProvider(create: (context) => PlaylistSong()),
      ChangeNotifierProvider(create: (context) => PlaylistFunctions()),
      ChangeNotifierProvider(create: (context) => SongAccess()),
      ChangeNotifierProvider(create: (context) => SongAccessProvider()),
    ], child: const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('isdarkmode').listenable(),
      builder: (context, box, _) {
        var darkMode = box.get('isDarkMode', defaultValue: false);
        return MaterialApp(
          title: 'Audio Player',
          debugShowCheckedModeBanner: false,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(useMaterial3: true),
          theme: ThemeData(useMaterial3: true),
          home: const SplashScreen(),
        );
      },
    );
  }
}
