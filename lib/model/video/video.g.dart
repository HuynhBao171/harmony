// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoImpl _$$VideoImplFromJson(Map<String, dynamic> json) => _$VideoImpl(
      kind: json['kind'] as String?,
      etag: json['etag'] as String?,
      nextPageToken: json['nextPageToken'] as String?,
      regionCode: json['regionCode'] as String?,
      pageInfo: json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$VideoImplToJson(_$VideoImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'etag': instance.etag,
      'nextPageToken': instance.nextPageToken,
      'regionCode': instance.regionCode,
      'pageInfo': instance.pageInfo,
      'items': instance.items,
    };
