import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../menu.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _imageOpacity;
  late final Animation<double> _textOpacity;
  late final Animation<double> _buttonOpacity;

  static const String _promoAssetPath = 'assets/images/october.webp';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _imageOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeInOut),
    );

    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.50, curve: Curves.easeInOut),
    );

    _buttonOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.50, 1.0, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(_promoAssetPath), context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imageHeight = size.height * 0.3;
    final textScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 1.2);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              FadeTransition(
                opacity: _imageOpacity,
                child: Semantics(
                  label: 'promo.title'.tr(),
                  image: true,
                  child: Image.asset(
                    _promoAssetPath,
                    width: size.width,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'promo.title'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'promo.text'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.048,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 36),
                        _buildStartButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return FadeTransition(
      opacity: _buttonOpacity,
      child: Semantics(
        button: true,
        child: SizedBox(
          width: 200,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(_createFadeRoute());
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'promo.button'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  PageRouteBuilder<void> _createFadeRoute() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => const MenuPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }
}
