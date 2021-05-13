import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/authService.dart';
import './constants/constantColors.dart';
import './services/firebaseOperations.dart';
import './screens/FeedScreen/feedUtils.dart';
import './screens/FeedScreen/feedWidgets.dart';
import './screens/SplashScreen/splashScreen.dart';
import './screens/ProfileScreen/profileUtils.dart';
import './screens/LandingScreen/landingUtils.dart';
import './screens/HomeScreen/homeScreenHelper.dart';
import './screens/ProfileScreen/profileWidgets.dart';
import './screens/LandingScreen/landingService.dart';
import './screens/LandingScreen/landingHelpers.dart';
import './screens/SearchScreen/searchListProvider.dart';
import './screens/ProfileDetailsScreen/profileDetailsProvider.dart';
import './screens/ProfileDetailsScreen/profileDetailsWidgetsProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ConstantColors _constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LandingHelper()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => HomeScreenHelper()),
        ChangeNotifierProvider(create: (_) => ProfileWidgetsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileUtilsProvider()),
        ChangeNotifierProvider(create: (_) => FeedUtilsProvider()),
        ChangeNotifierProvider(create: (_) => FeedWidgetsProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => SearchListProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDetailsWidgetsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDetailsProvider()),
      ],
      child: MaterialApp(
        title: 'TheSocial',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: _constantColors.blueColor,
          fontFamily: 'Poppins',
          canvasColor: _constantColors.transparent,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
