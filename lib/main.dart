import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:riskmanagement/modular/app_module.dart';
import 'package:riskmanagement/provider/data_provider.dart';
import 'package:riskmanagement/provider/input_provider.dart';

import 'Login/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ModularApp(
      module: AppModule(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>.value(
            value: AuthenticationProvider(),
          ),
          ChangeNotifierProvider<DataProvider>.value(
            value: DataProvider(),
          ),
          ChangeNotifierProvider<InputProvider>.value(
            value: InputProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Risk Management',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF5658dd),
            appBarTheme: AppBarTheme(
              elevation: 0,
            ),
            scaffoldBackgroundColor: const Color(0xFF202020),
            brightness: Brightness.dark,
            accentColor: Colors.deepPurpleAccent,
            primarySwatch: Colors.deepPurple,
            primaryColorBrightness: Brightness.dark,
            fontFamily: 'Helvetica Neue',
            textTheme: TextTheme().copyWith(
              bodyText1: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              bodyText2: TextStyle(
                fontSize: 16.0,
              ),
              headline1: TextStyle(
                fontFamily: 'Futura',
                color: Colors.white,
              ),
              headline2: TextStyle(
                fontFamily: 'Futura',
                color: Colors.white,
              ),
              headline6: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ).modular());
  }
}
