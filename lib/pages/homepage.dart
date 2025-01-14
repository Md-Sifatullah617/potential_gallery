import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:potential_gallery/controller/gallery_controller.dart';

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
        if (galleryController.pictureList.value == null ||
            galleryController.pictureList.value!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: galleryController.pictureList.value!.length,
            itemBuilder: (context, index) {
              final picture = galleryController.pictureList.value![index];
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
