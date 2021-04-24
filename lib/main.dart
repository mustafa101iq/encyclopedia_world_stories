import 'package:admob_flutter/admob_flutter.dart';
import 'package:encyclopedia_world_stories/Pages/HomePage.dart';
import 'package:encyclopedia_world_stories/providers/AuthenticationsProvider.dart';
import 'package:encyclopedia_world_stories/providers/SettingsProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'utils/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
            create: (_) => SettingsProvider()),
        ChangeNotifierProvider<AuthenticationsProvider>(
          create: (_) => AuthenticationsProvider.instance(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        themeMode: ThemeMode.dark,
        darkTheme: Constants.darkTheme,
        debugShowCheckedModeBanner: false,
        title: 'encyclopedia_world_stories',
        theme: Constants.lightTheme,
        home: HomePage(),
      ),
    );
  }
}
