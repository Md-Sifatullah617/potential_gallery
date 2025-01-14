import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:potential_gallery/model/picture_model.dart';
import 'package:potential_gallery/utils/custom_widget/custom_notification.dart';

class GalleryController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<List<PictureModel>> pictureList = Rxn<List<PictureModel>>();
  RxInt pageNo = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getCuratedPhotos(1);
  }

  Future<void> getCuratedPhotos(pageNo) async {
    try {
      isLoading.value = true;
      var response = await http.get(
          Uri.parse(
              'https://api.pexels.com/v1/curated?per_page=20&page=$pageNo'),
          headers: {
            "Authorization": dotenv.env["PEXEL_API_KEY"].toString(),
          });
      var resultCode = response.statusCode;
      if (resultCode == 200) {
        var data = pictureModelFromJson(response.body);
        pictureList.value = data.photos;
      } else {
        toastMessage(
          msg: "Picture Loading Failed ! Try Again.",
          isError: true,
        );
      }
    } catch (e) {
      printError(info: "Error in getCuratedPhotos : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
