// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Items _$ItemsFromJson(Map<String, dynamic> json) => Items(
      kind: json['kind'] as String?,
      etag: json['etag'] as String?,
      id: json['id'] == null
          ? null
          : Id.fromJson(json['id'] as Map<String, dynamic>),
      snippet: json['snippet'] == null
          ? null
          : Snippet.fromJson(json['snippet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemsToJson(Items instance) => <String, dynamic>{
      'kind': instance.kind,
      'etag': instance.etag,
      'id': instance.id?.toJson(),
      'snippet': instance.snippet?.toJson(),
    };
