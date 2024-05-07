import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harmony/model/items/items.dart';
import 'package:harmony/model/pageinfo/pageinfo.dart';

part 'video.freezed.dart';
part 'video.g.dart';

@freezed
class Video with _$Video {
  factory Video({
    String? kind,
    String? etag,
    String? nextPageToken,
    String? regionCode,
    PageInfo? pageInfo,
    List<Items>? items,
  }) = _Video;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
