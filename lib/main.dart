import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:pan_pocket/controller/home_controller.dart';
import 'package:pan_pocket/pages/home_page.dart';
import 'package:pan_pocket/pages/login_page.dart';
import 'package:pan_pocket/pages/splash_page.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controller/api_controller.dart';
import 'models/links.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(    url: 'https://hitzvatlzhtqvmliqlna.supabase.co',
                                anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhpdHp2YXRsemh0cXZtbGlxbG5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2MDM3ODAsImV4cCI6MjA2OTE3OTc4MH0.q_dVD4w4oa8xZM99OwmMSV73a6WEBGKE9188m5Bt0n4',  );
  GetIt.I.registerSingleton<ApiController>(ApiController());
  GetIt.I.registerSingleton<HomeController>(HomeController());

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
List<Links> linksList = [];



class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  _refresh(){
    setState(() {

    });
  }

  static ThemeData lightTheme = ThemeData(
      fontFamily: GoogleFonts.notoSans().fontFamily,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          foregroundColor: Colors.black),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF4D4DFF), // Your primary color for dark mode
      canvasColor: const Color.fromARGB(255, 179, 179, 179),
      focusColor: const Color(0xFF884DFF),
      inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.black,
          )
      ),
      colorScheme: ColorScheme.fromSwatch(
        // Use your primary color here
        accentColor: const Color.fromARGB(255, 69, 69, 69),
        backgroundColor:
        const Color.fromARGB(255, 204, 204, 204), // Your secondary color
      ), // Your accent color for dark mode
      cardTheme: CardThemeData(
        color: Colors.white70.withAlpha(220),
      ),
      listTileTheme: const ListTileThemeData(
          textColor: Colors.black,
          iconColor: Colors.black
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white70.withAlpha(220),
      ),
      textTheme: const TextTheme(
          labelLarge: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600), // Text color for dark theme
          bodyMedium: TextStyle(color: Colors.black, backgroundColor: Colors.transparent, fontSize: 18),
          bodySmall: TextStyle(color: Colors.black, fontSize: 16),
          labelSmall: TextStyle(color: Colors.black, fontSize: 11)),
      textButtonTheme:  const TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF884DFF)),
              textStyle:
              WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 17, color: Colors.white)),
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.white)))
    // Add other dark theme properties here
  );

  static ThemeData darkTheme = ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C1B1B),
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF1C1B1B),
          )),
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.teal, // Your primary color for dark mode
      canvasColor: const Color.fromARGB(255, 37, 37, 37),
      focusColor: Colors.red,
      inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.white,
          )
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xFF1C1B1B),
      ),
      cardTheme: const CardThemeData(
          color: Color(0xFF1C1B1B)
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.grey, // Use your primary color here
        accentColor: Colors.blueGrey,
        errorColor: Colors.blueGrey,
        backgroundColor: const Color(0xFF1C1B1B), // Your secondary color
      ), // Your accent color for dark mode
      textTheme: const TextTheme(
          labelLarge: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600), // Text color for dark theme
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
          bodySmall: TextStyle(color: Colors.white, fontSize: 16),
          labelSmall: TextStyle(color: Colors.white, fontSize: 11)),
      iconTheme: const IconThemeData(color: Colors.blueGrey),
      listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white
      ),
      textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFF884DFF)),
              textStyle:
              WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 20)),
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.white)))
    // Add other dark theme properties here
  );



  @override
  Widget build(BuildContext context) {

    return Sizer(builder: (context, orientation, deviceType) {
      return AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pan Invoice',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (_) => const SplashPage(),
            '/login': (_) => const LoginPage(),
           // '/account': (_) => const AccountPage(),
            '/home': (_) => const MyHomePage(),
          },
        ),
      );
    });
  }
}