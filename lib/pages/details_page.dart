import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:potential_gallery/controller/gallery_controller.dart';
import 'package:potential_gallery/utils/app_assets.dart';
import 'package:shimmer/shimmer.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});
  final GalleryController galleryController = Get.find<GalleryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(galleryController.selectedPicture.value!.alt!),
      ),
      body: Column(
        spacing: 10.h,
        children: [
          InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: galleryController.selectedPicture.value!.src!.original!,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 300.h,
              width: 1.sw,
              fit: BoxFit.contain,
            ),
          ),
          ListTile(
            title: Text('Photographer'),
            subtitle:
                Text(galleryController.selectedPicture.value!.photographer!),
          ),
          ListTile(
            title: Text('Photographer URL'),
            subtitle:
                Text(galleryController.selectedPicture.value!.photographerUrl!),
          ),
          ListTile(
            title: Text('Photographer ID'),
            subtitle: Text(galleryController
                .selectedPicture.value!.photographerId
                .toString()),
          ),
          ListTile(
            title: Text('Average Color'),
            subtitle: Text(galleryController.selectedPicture.value!.avgColor!),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        children: [
          FloatingActionButton(
            onPressed: () {
              galleryController.downloadPicture();
            },
            heroTag: 'download',
            backgroundColor: Colors.white,
            child: Image.asset(
              AppAssets.download,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              galleryController.sharePicture();
            },
            heroTag: 'share',
            backgroundColor: Colors.white,
            child: Image.asset(
              AppAssets.share,
              width: 20.w,
              height: 20.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
