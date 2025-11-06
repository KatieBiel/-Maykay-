import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/app_scaffold.dart';

/// 🖼️ Galeria zdjęć — miniatury + podgląd w trybie pełnoekranowym
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  /// Lista ścieżek do obrazów w folderze assets/images
  final List<String> imagePaths = const [
    'assets/images/gallery/gal1.webp',
    'assets/images/gallery/gal2.webp',
    'assets/images/gallery/gal3.webp',
    'assets/images/gallery/gal4.webp',
    'assets/images/gallery/gal5.webp',
    'assets/images/gallery/gal6.webp',
    'assets/images/gallery/gal7.webp',
    'assets/images/gallery/gal8.webp',
  ];

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'gallery.drawer_galery'.tr(),
          style: TextStyle(fontSize: scaler.scale(20), color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: imagePaths.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder:
              (context, index) => _GalleryTile(
                imagePath: imagePaths[index],
                allImages: imagePaths,
                index: index,
              ),
        ),
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final String imagePath;
  final List<String> allImages;
  final int index;

  const _GalleryTile({
    required this.imagePath,
    required this.allImages,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => PhotoViewScreen(
                    imagePaths: allImages,
                    initialIndex: index,
                  ),
            ),
          ),
      child: Semantics(
        container: false,
        excludeSemantics: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

/// 🔹 Pełnoekranowy podgląd zdjęć
class PhotoViewScreen extends StatelessWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const PhotoViewScreen({
    super.key,
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imagePaths.length,
            pageController: pageController,
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            builder:
                (context, index) => PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(imagePaths[index]),
                  heroAttributes: PhotoViewHeroAttributes(
                    tag: imagePaths[index],
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 3,
                  basePosition: Alignment.center,
                  tightMode: true,
                ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
              tooltip: 'close'.tr(),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
