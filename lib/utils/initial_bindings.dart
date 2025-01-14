import 'package:get/get.dart';
import 'package:potential_gallery/controller/gallery_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(() => GalleryController());
  }
}
