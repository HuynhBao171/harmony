import 'package:json_annotation/json_annotation.dart';

part 'default.g.dart';

@JsonSerializable()
class Default {
  String? url;
  int? width;
  int? height;

  Default({this.url, this.width, this.height});

  factory Default.fromJson(Map<String, dynamic> json) => _$DefaultFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultToJson(this);
}