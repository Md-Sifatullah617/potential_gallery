import 'package:get/get.dart';
import 'package:potential_gallery/pages/details_page.dart';
import 'package:potential_gallery/pages/homepage.dart';

class Routes {
  static const String homePage = "/home-page";
  static const String detailsPage = "/details-page";

  static List<GetPage<dynamic>> getPages = [
    GetPage(
      name: homePage,
      page: () => Homepage(),
    ),
    GetPage(
      name: detailsPage,
      page: () => DetailsPage(),
    ),
  ];
}
