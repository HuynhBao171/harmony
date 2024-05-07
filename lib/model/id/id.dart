import 'package:json_annotation/json_annotation.dart';

part 'id.g.dart';

@JsonSerializable()
class Id {
  String? kind;
  String? videoId;

  Id({this.kind, this.videoId});

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);

  Map<String, dynamic> toJson() => _$IdToJson(this);
}