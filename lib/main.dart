// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maykay/screens/promo_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'logger.dart';
import 'push_service.dart';

import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'menu.dart';
import 'screens/contact_screen.dart';
import 'screens/about_screen.dart';
import 'galery.dart';
import 'szkolenia.dart';
import 'zablecz.dart';
import 'zabrel.dart';
import 'masazlecz.dart';
import 'masazrel.dart';
import 'maderoterapia.dart';
import 'screens/pricing_screen.dart';
import 'loyalty.dart';
import 'rezerwacja.dart';
import 'login.dart';

const Color designColor = Color(0xFF00B400);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  try {
    await dotenv.load(fileName: 'assets/maykay.env');
    log.i('✅ Załadowano .env z assets!');
  } catch (e) {
    log.e('❌ Nie udało się załadować .env z assets: $e');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await EasyLocalization.ensureInitialized();
  await PushNotificationService().initialize();

  await Permission.camera.request();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pl'), Locale('en'), Locale('nl')],
      path: 'assets/translations',
      fallbackLocale: const Locale('pl'),
      child: const MaykayApp(),
    ),
  );
}

class MaykayApp extends StatelessWidget {
  const MaykayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.quicksandTextTheme();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: designColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: baseTextTheme,
        appBarTheme: AppBarTheme(
          elevation: 4,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          toolbarHeight: 56,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: designColor,
          linearTrackColor: Color(0xFFD9F5D9),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: designColor,
            foregroundColor: Colors.white,
            overlayColor: designColor.withOpacity(0.8),
            side: const BorderSide(color: designColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
        ),
        tooltipTheme: TooltipThemeData(
          textStyle: const TextStyle(fontSize: 14, color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
      ),

      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomePage(),
        '/menu': (context) => const MenuPage(),
        '/contact': (context) => const ContactScreen(),
        '/about': (context) => const AboutPage(),
        '/galery': (context) => GalleryPage(),
        '/szkolenia': (context) => const SzkoleniaPage(),
        '/zablecz': (context) => const ZableczPage(),
        '/zabrel': (context) => const ZabrelPage(),
        '/masazlecz': (context) => const MasazleczPage(),
        '/masazrel': (context) => const MasazRelPage(),
        '/maderoterapia': (context) => const MaderoterapiaPage(),
        '/cennik': (context) => const PricingScreen(),
        '/rezerwacja': (context) => const RezerwacjaPage(),
        '/loyalty': (context) => const LoyaltyPage(),
        '/login': (context) => const LogowaniePage(),
        '/promo': (context) => const PromoScreen(),
      },
    );
  }
}
