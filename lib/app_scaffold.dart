import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maykay/loyalty.dart';
import 'package:maykay/rezerwacja.dart';
import 'screens/contact_screen.dart';
import 'menu.dart';

/// 🔹 przykładowe strony – podmień na swoje

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? drawer;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.scaffoldKey,
    this.drawer,
  });

  /// 🔹 Funkcja ustala aktywny index na podstawie trasy
  int _getSelectedIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '';

    if (route.contains('rezerwacja')) return 2;
    if (route.contains('loyalty')) return 3;
    if (route.contains('contact')) return 1;
    if (route.contains('menu')) return 0;
    return 0; // domyślnie home
  }

  void _onItemTapped(BuildContext context, int index) {
    final currentIndex = _getSelectedIndex(context);
    if (index == currentIndex) return;

    Widget page;
    String routeName;

    switch (index) {
      case 0:
        page = const MenuPage();
        routeName = '/menu';
        break;
      case 1:
        page = const ContactScreen();
        routeName = '/contact';
        break;
      case 2:
        page = const RezerwacjaPage(); // 🔹 Twoja strona z rezerwacja.dart
        routeName = '/rezerwacja';
        break;
      case 3:
        page = const LoyaltyPage(); // 🔹 Twoja strona z loyalty.dart
        routeName = '/loyalty';
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => page,
        settings: RouteSettings(name: routeName),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: appBar,
      drawer: drawer,
      body: SafeArea(child: body),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.8)),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          indicatorColor: Colors.white,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(context, index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_rounded, color: Colors.grey),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              label: 'navigation.home'.tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.phone_rounded, color: Colors.grey),
              selectedIcon: Icon(
                Icons.phone_rounded,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              label: 'navigation.contact'.tr(),
            ),
            NavigationDestination(
              icon: const Icon(
                FontAwesomeIcons.calendarCheck,
                color: Colors.grey,
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.calendarCheck,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              label: 'navigation.booking'.tr(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.card_giftcard, color: Colors.grey),
              selectedIcon: Icon(
                Icons.card_giftcard,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              label: 'navigation.loyalty'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
