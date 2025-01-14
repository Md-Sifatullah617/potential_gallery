import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:potential_gallery/controller/gallery_controller.dart';
import 'package:potential_gallery/utils/app_assets.dart';
import 'package:potential_gallery/utils/custom_widget/custom_shimmer.dart';
import 'package:potential_gallery/utils/routes.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatelessWidget {
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
        bool isFetchingMore = galleryController.isFetchingMore.value;
        var pictureList = galleryController.pictureList.value ?? [];

        if (isLoading && pictureList.isEmpty) {
          return MasonryGridView.count(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: 4,
            itemBuilder: (context, index) {
              return CustomShimmer();
            },
          );
        }

        if (pictureList.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.noData,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.h),
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
          controller: galleryController.scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: pictureList.length + (isFetchingMore ? 4 : 0),
          itemBuilder: (context, index) {
            if (index >= pictureList.length) {
              return CustomShimmer();
            } else {
              final picture = pictureList[index];
              return GestureDetector(
                onTap: () {
                  galleryController.selectedPicture.value = picture;
                  Get.toNamed(Routes.detailsPage);
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: picture.src!.medium!,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
          },
        );
      }),
    );
  }
}
