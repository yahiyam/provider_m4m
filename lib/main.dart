import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m_app/pages/home_page.dart';
import 'package:m4m_app/pages/splash_screen.dart';
import 'package:m4m_app/provider/dark_mode.dart';
import 'package:provider/provider.dart';

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
  ]).then((value) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => DarkModeState(),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DarkModeState>(context, listen: false)
          .initializeDarkMode(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<DarkModeState>(
            builder: (context, darkModeState, _) {
              return MaterialApp(
                title: 'Audio Player',
                debugShowCheckedModeBanner: false,
                themeMode:
                    darkModeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                darkTheme: ThemeData.dark(useMaterial3: true),
                theme: ThemeData(useMaterial3: true),
                home: const HomePage(),
              );
            },
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
