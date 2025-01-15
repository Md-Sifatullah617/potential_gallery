import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:potential_gallery/model/picture_model.dart';
import 'package:potential_gallery/utils/custom_widget/custom_notification.dart';
import 'package:share_plus/share_plus.dart';

class GalleryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs;
  Rxn<List<PictureModel>> pictureList = Rxn<List<PictureModel>>();
  RxInt pageNo = 1.obs;
  final ScrollController scrollController = ScrollController();
  Rxn<PictureModel> selectedPicture = Rxn<PictureModel>();

  final Box cacheBox = Hive.box('cacheBox');

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    getCuratedPhotos(1);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isFetchingMore.value) {
          pageNo++;
          getCuratedPhotos(pageNo.value, isLoadMore: true);
        }
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void loadCachedData() {
    if (cacheBox.containsKey('pictureList')) {
      var cachedData = cacheBox.get('pictureList');
      var data = pictureModelListFromJson(cachedData);
      pictureList.value = data;
    }
  }

  Future<void> getCuratedPhotos(int pageNo, {bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isFetchingMore.value = true;
      } else {
        isLoading.value = true;
      }

      if (!isLoadMore && cacheBox.containsKey('page_$pageNo')) {
        var cachedData = cacheBox.get('page_$pageNo');
        var data = pictureModelFromJson(cachedData);
        pictureList.value = data.photos;
        isLoading.value = false;
        return;
      }

      var response = await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/curated?per_page=20&page=$pageNo'),
          headers: {
            "Authorization": dotenv.env["PEXEL_API_KEY"].toString(),
          });
      var resultCode = response.statusCode;
      if (resultCode == 200) {
        var data = pictureModelFromJson(response.body);
        if (isLoadMore) {
          pictureList.value!.addAll(data.photos!);
        } else {
          pictureList.value = data.photos;
        }
        cacheOriginalPictureUrl(pictureList.value!);
        cacheBox.put('pictureList', pictureModelListToJson(pictureList.value!));
      } else {
        toastMessage(
          msg: "Picture Loading Failed! Try Again.",
          isError: true,
        );
      }
    } catch (e) {
      printError(info: "Error in getCuratedPhotos: $e");
    } finally {
      if (isLoadMore) {
        isFetchingMore.value = false;
      } else {
        isLoading.value = false;
      }
    }
  }

  void sharePicture() {
    if (selectedPicture.value != null) {
      Share.share(
        selectedPicture.value!.src!.original!,
        subject: selectedPicture.value!.alt,
      );
    }
  }

  Future<void> downloadPicture() async {
    if (selectedPicture.value != null) {
      final picture = selectedPicture.value!;
      final url = picture.src?.original ?? 'no_name';
      final fileName = url.split('/').last;

      try {
        var status = await Permission.storage.status;
        if (status.isDenied || status.isRestricted || status.isLimited) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          Directory? directory;
          if (Platform.isAndroid) {
            directory = await getExternalStorageDirectory();
          } else if (Platform.isIOS) {
            directory = await getApplicationDocumentsDirectory();
          }

          final filePath = '${directory!.path}/$fileName';
          final response = await Dio().download(url, filePath);
          if (response.statusCode == 200) {
            toastMessage(msg: 'Picture downloaded successfully to $filePath!');
          } else {
            toastMessage(msg: 'Failed to download picture!', isError: true);
          }
        } else if (status.isPermanentlyDenied) {
          Get.dialog(
            AlertDialog(
              title: const Text('Storage Permission Required'),
              content: const Text(
                  'Please allow storage permission to download the picture.'),
              actions: [
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Get.back();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        } else {
          toastMessage(msg: 'Storage permission denied!', isError: true);
        }
      } catch (e) {
        toastMessage(msg: 'Error in downloadPicture: $e', isError: true);
        printError(info: "Error in downloadPicture: $e");
      }
    }
  }

  cacheOriginalPictureUrl(List<PictureModel> pictureList) {
    for (var picture in pictureList) {
      CachedNetworkImageProvider(picture.src!.original!);
    }
  }
}
