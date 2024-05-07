// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Default _$DefaultFromJson(Map<String, dynamic> json) => Default(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DefaultToJson(Default instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
