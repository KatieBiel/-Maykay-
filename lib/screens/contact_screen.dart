import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maykay/app_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactScreen> {
  static const _whatsappUrl = 'https://wa.me/31615943839';
  static const _telUrl = 'tel:+31615943839';
  static const _emailUrl = 'mailto:info@maykay.nl';

  bool _imagePrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage wywołujemy tylko raz
    if (!_imagePrecached) {
      precacheImage(
        const AssetImage('assets/images/besia_welcome.webp'),
        context,
      );
      _imagePrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);

    final items = [
      ContactItem(
        icon: FontAwesomeIcons.whatsapp,
        label: 'WhatsApp',
        action:
            () => _launchUrl(
              context,
              _whatsappUrl,
              errorMessage: 'contact.whatsapp_error'.tr(),
              external: true,
            ),
      ),
      ContactItem(
        icon: FontAwesomeIcons.phone,
        label: 'contact.phone'.tr(),
        action:
            () => _launchUrl(
              context,
              _telUrl,
              errorMessage: 'contact.phone_error'.tr(),
            ),
      ),
      ContactItem(
        icon: FontAwesomeIcons.envelope,
        label: 'contact.email'.tr(),
        action:
            () => _launchUrl(
              context,
              _emailUrl,
              errorMessage: 'contact.email_error'.tr(),
            ),
      ),
      ContactItem(
        icon: FontAwesomeIcons.calendarCheck,
        label: 'contact.booking'.tr(),
        action: () => Navigator.pushNamed(context, '/rezerwacja'),
      ),
    ];

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'contact.contact'.tr(),
          style: TextStyle(color: Colors.black, fontSize: textScaler.scale(20)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Obrazek z fade-in
            Image.asset(
              'assets/images/besia_welcome.webp',
              fit: BoxFit.cover,
              width: double.infinity,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child:
                      frame == null
                          ? Container(
                            key: const ValueKey('placeholder'),
                            width: double.infinity,
                            color: Colors.grey[200],
                          )
                          : child,
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    items
                        .map((item) => ContactActionButton(item: item))
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchUrl(
    BuildContext context,
    String url, {
    required String errorMessage,
    bool external = false,
  }) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode:
            external
                ? LaunchMode.externalApplication
                : LaunchMode.platformDefault,
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}

class ContactItem {
  final IconData icon;
  final String label;
  final VoidCallback action;

  const ContactItem({
    required this.icon,
    required this.label,
    required this.action,
  });
}

class ContactActionButton extends StatelessWidget {
  final ContactItem item;
  const ContactActionButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);

    return GestureDetector(
      onTap: item.action,
      child: Semantics(
        button: true,
        label: item.label,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 50, color: const Color(0xFF00B400)),
            const SizedBox(height: 4),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textScaler.scale(18),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
