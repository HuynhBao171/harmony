import 'package:json_annotation/json_annotation.dart';
import 'package:harmony/model/default/default.dart';

part 'thumbnails.g.dart';

@JsonSerializable()
class Thumbnails {
  @JsonKey(name: 'default')
  Default? defaul;
  Default? medium;
  Default? high;

  Thumbnails({this.defaul, this.medium, this.high});

  factory Thumbnails.fromJson(Map<String, dynamic> json) => _$ThumbnailsFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailsToJson(this);
}