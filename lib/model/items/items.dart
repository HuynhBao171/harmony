import 'package:json_annotation/json_annotation.dart';
import 'package:harmony/model/id/id.dart';
import 'package:harmony/model/snippet/snippet.dart';

part 'items.g.dart';

@JsonSerializable(explicitToJson: true)
class Items {
  String? kind;
  String? etag;
  Id? id;
  Snippet? snippet;

  Items({this.kind, this.etag, this.id, this.snippet});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}