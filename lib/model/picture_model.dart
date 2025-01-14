// To parse this JSON data, do
//
//     final pictureModel = pictureModelFromJson(jsonString);

import 'dart:convert';

RpPictureModel pictureModelFromJson(String str) =>
    RpPictureModel.fromJson(json.decode(str));

PictureModel pictureModelFromJsonSingle(String str) =>
    PictureModel.fromJson(json.decode(str));

String pictureModelToJson(PictureModel data) => json.encode(data.toJson());

List<PictureModel> pictureModelListFromJson(String str) =>
    List<PictureModel>.from(
        json.decode(str).map((x) => PictureModel.fromJson(x)));

String pictureModelListToJson(List<PictureModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RpPictureModel {
  final int? totalResults;
  final int? page;
  final int? perPage;
  final List<PictureModel>? photos;
  final String? nextPage;

  RpPictureModel({
    this.totalResults,
    this.page,
    this.perPage,
    this.photos,
    this.nextPage,
  });

  factory RpPictureModel.fromJson(Map<String, dynamic> json) => RpPictureModel(
        totalResults: json["total_results"],
        page: json["page"],
        perPage: json["per_page"],
        photos: List<PictureModel>.from(
            json["photos"].map((x) => PictureModel.fromJson(x))),
        nextPage: json["next_page"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "photos": List<dynamic>.from(photos!.map((x) => x.toJson())),
        "next_page": nextPage,
      };
}

class PictureModel {
  final int? id;
  final int? width;
  final int? height;
  final String? url;
  final String? photographer;
  final String? photographerUrl;
  final int? photographerId;
  final String? avgColor;
  final Src? src;
  final bool? liked;
  final String? alt;

  PictureModel({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.src,
    this.liked,
    this.alt,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        photographer: json["photographer"],
        photographerUrl: json["photographer_url"],
        photographerId: json["photographer_id"],
        avgColor: json["avg_color"],
        src: json["src"] == null ? null : Src.fromJson(json["src"]),
        liked: json["liked"],
        alt: json["alt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "photographer_id": photographerId,
        "avg_color": avgColor,
        "src": src?.toJson(),
        "liked": liked,
        "alt": alt,
      };
}

class Src {
  final String? original;
  final String? large2X;
  final String? large;
  final String? medium;
  final String? small;
  final String? portrait;
  final String? landscape;
  final String? tiny;

  Src({
    this.original,
    this.large2X,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  factory Src.fromJson(Map<String, dynamic> json) => Src(
        original: json["original"],
        large2X: json["large2x"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
        portrait: json["portrait"],
        landscape: json["landscape"],
        tiny: json["tiny"],
      );

  Map<String, dynamic> toJson() => {
        "original": original,
        "large2x": large2X,
        "large": large,
        "medium": medium,
        "small": small,
        "portrait": portrait,
        "landscape": landscape,
        "tiny": tiny,
      };
}
