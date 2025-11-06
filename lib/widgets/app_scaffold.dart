import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maykay/loyalty.dart';
import 'package:maykay/rezerwacja.dart';
import '../screens/contact_screen.dart';
import '../menu.dart';

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

  int _getSelectedIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '';
    if (route.contains('rezerwacja')) return 2;
    if (route.contains('loyalty')) return 3;
    if (route.contains('contact')) return 1;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    final currentIndex = _getSelectedIndex(context);
    if (index == currentIndex) return;

    final destinations = [
      {'page': const MenuPage(), 'route': '/menu'},
      {'page': const ContactScreen(), 'route': '/contact'},
      {'page': const RezerwacjaPage(), 'route': '/rezerwacja'},
      {'page': const LoyaltyPage(), 'route': '/loyalty'},
    ];

    final target = destinations[index];
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => target['page'] as Widget,
        settings: RouteSettings(name: target['route'] as String),
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
      extendBody: true,
      body: SafeArea(top: true, bottom: false, child: body),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 75),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.black, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 65,
              indicatorColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _onItemTapped(context, index),
              destinations: [
                _navItem(
                  context,
                  icon: Icons.home_rounded,
                  label: 'navigation.home',
                  isSelected: selectedIndex == 0,
                ),
                _navItem(
                  context,
                  icon: Icons.phone_rounded,
                  label: 'navigation.contact',
                  isSelected: selectedIndex == 1,
                ),
                _navItem(
                  context,
                  icon: FontAwesomeIcons.calendarCheck,
                  label: 'navigation.booking',
                  size: 21,
                  isSelected: selectedIndex == 2,
                ),
                _navItem(
                  context,
                  icon: Icons.card_giftcard,
                  label: 'navigation.loyalty',
                  isSelected: selectedIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _navItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isSelected = false,
    double size = 23,
  }) {
    final iconWidget = Icon(
      icon,
      color: isSelected ? Colors.black : Colors.grey,
      size: size,
      shadows: isSelected
          ? [
              const Shadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ]
          : [],
    );

    return NavigationDestination(
      icon: iconWidget,
      selectedIcon: iconWidget,
      label: label.tr(),
    );
  }
}
