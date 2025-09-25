import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../app_scaffold.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;

    final categories = _categoriesData();

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'cennik.title'.tr(),
          style: TextStyle(
            fontSize: scaler.scale(20),
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.fromSTEB(
            horizontalPadding,
            20,
            horizontalPadding,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final c in categories)
                _CategorySection(
                  icon: c.icon,
                  titleKey: c.titleKey,
                  itemKeys: c.itemKeys,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<_CategoryData> _categoriesData() => const [
    _CategoryData(
      icon: Icons.healing,
      titleKey: 'cennik.lecznicze',
      itemKeys: ['cennik.lecz1', 'cennik.lecz2', 'cennik.lecz4'],
    ),
    _CategoryData(
      icon: Icons.nature,
      titleKey: 'cennik.terapie',
      itemKeys: ['cennik.ter1', 'cennik.ter2'],
    ),
    _CategoryData(
      icon: Icons.spa,
      titleKey: 'cennik.relaksacyjne',
      itemKeys: [
        'cennik.rel1',
        'cennik.rel2',
        'cennik.rel3',
        'cennik.rel4',
        'cennik.rel5',
        'cennik.rel6',
        'cennik.rel7',
        'cennik.rel8',
        'cennik.rel9',
      ],
    ),
    _CategoryData(
      icon: Icons.fitness_center,
      titleKey: 'cennik.wyszczuplajace',
      itemKeys: [
        'cennik.wysz1',
        'cennik.wysz2',
        'cennik.wysz3',
        'cennik.wysz4',
      ],
    ),
    _CategoryData(
      icon: Icons.face_retouching_natural,
      titleKey: 'cennik.pielegnacyjne',
      itemKeys: ['cennik.piel1', 'cennik.piel2'],
    ),
  ];
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.icon,
    required this.titleKey,
    required this.itemKeys,
  });

  final IconData icon;
  final String titleKey;
  final List<String> itemKeys;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Semantics(
        container: true,
        header: true,
        label: titleKey.tr(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryHeader(icon: icon, title: titleKey.tr()),
            const SizedBox(height: 12),
            ListView.separated(
              itemCount: itemKeys.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final fullText = itemKeys[index].tr();
                final parsed = _PriceLineParsed.fromLocalizedLine(fullText);
                return _PriceLine(
                  nameAndTime: parsed.nameAndTime,
                  price: parsed.price,
                  textStyle: TextStyle(
                    fontSize: scaler.scale(16),
                    color: theme.colorScheme.onSurface,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9F5D9),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: scaler.scale(20),
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.nameAndTime,
    required this.price,
    required this.textStyle,
  });

  final String nameAndTime;
  final String price;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final priceStyle = textStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.green,
    );

    return Semantics(
      label: '$nameAndTime, $price',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '• ',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(nameAndTime, style: textStyle)),
                  Text(
                    price,
                    style: priceStyle.copyWith(fontSize: scaler.scale(16)),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceLineParsed {
  final String nameAndTime;
  final String price;

  const _PriceLineParsed(this.nameAndTime, this.price);

  static _PriceLineParsed fromLocalizedLine(String fullText) {
    final text = fullText.trim();

    int idx = text.lastIndexOf('–');
    if (idx == -1) idx = text.lastIndexOf('-');

    if (idx <= 0 || idx >= text.length - 1) {
      return _PriceLineParsed(text, '');
    }

    final left = text.substring(0, idx).trim();
    final right = text.substring(idx + 1).trim();

    if (right.isEmpty) {
      return _PriceLineParsed(text, '');
    }

    return _PriceLineParsed(left, right);
  }
}

class _CategoryData {
  final IconData icon;
  final String titleKey;
  final List<String> itemKeys;

  const _CategoryData({
    required this.icon,
    required this.titleKey,
    required this.itemKeys,
  });
}
