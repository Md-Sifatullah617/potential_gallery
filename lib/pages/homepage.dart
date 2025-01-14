import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:potential_gallery/controller/gallery_controller.dart';
import 'package:potential_gallery/utils/app_assets.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final GalleryController galleryController = Get.find<GalleryController>();
  Homepage({super.key});

  final GalleryController galleryController = Get.find<GalleryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potential Gallery'),
      ),
      body: Obx(() {
        bool isLoading = galleryController.isLoading.value;
        var pictureList = galleryController.pictureList.value ?? [];
        if (isLoading) {
          return MasonryGridView.count(
            padding: EdgeInsets.all(16.w),
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 200.h,
                    color: Colors.white,
                  ),
                ),
              );
            },
          );
        }

        if (pictureList.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10.h,
            children: [
              Image.asset(
                AppAssets.noData,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
              Text(
                'No Data Found',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ));
        }

        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: pictureList.length + (isLoading ? 4 : 0),
          itemBuilder: (context, index) {
            final picture = pictureList[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: picture.src!.medium!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
