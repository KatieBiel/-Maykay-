import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _startAnimation = false;
  double _quoteOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _startAnimation = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _quoteOpacity = 1.0);

    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final bool welcomeShown = prefs.getBool('welcomeShown') ?? false;

    if (!mounted) return;

    if (!welcomeShown) {
      Navigator.of(context).pushReplacementNamed('/welcome');
    } else {
      Navigator.of(context).pushReplacementNamed('/promo');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: screenWidth * 0.2,
                end: _startAnimation ? screenWidth * 0.65 : screenWidth * 0.2,
              ),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOut,
              builder:
                  (context, size, child) =>
                      SizedBox(width: size, height: size, child: child),
              child: Semantics(
                label: 'splash.logo_alt'.tr(),
                image: true,
                child: Image.asset(
                  'assets/images/logo.webp',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.08),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _quoteOpacity,
                child: Text(
                  'splash.splash_quote'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
