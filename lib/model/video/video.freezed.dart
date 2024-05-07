// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Video _$VideoFromJson(Map<String, dynamic> json) {
  return _Video.fromJson(json);
}

/// @nodoc
mixin _$Video {
  String? get kind => throw _privateConstructorUsedError;
  String? get etag => throw _privateConstructorUsedError;
  String? get nextPageToken => throw _privateConstructorUsedError;
  String? get regionCode => throw _privateConstructorUsedError;
  PageInfo? get pageInfo => throw _privateConstructorUsedError;
  List<Items>? get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VideoCopyWith<Video> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCopyWith<$Res> {
  factory $VideoCopyWith(Video value, $Res Function(Video) then) =
      _$VideoCopyWithImpl<$Res, Video>;
  @useResult
  $Res call(
      {String? kind,
      String? etag,
      String? nextPageToken,
      String? regionCode,
      PageInfo? pageInfo,
      List<Items>? items});
}

/// @nodoc
class _$VideoCopyWithImpl<$Res, $Val extends Video>
    implements $VideoCopyWith<$Res> {
  _$VideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = freezed,
    Object? etag = freezed,
    Object? nextPageToken = freezed,
    Object? regionCode = freezed,
    Object? pageInfo = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      kind: freezed == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String?,
      etag: freezed == etag
          ? _value.etag
          : etag // ignore: cast_nullable_to_non_nullable
              as String?,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
      regionCode: freezed == regionCode
          ? _value.regionCode
          : regionCode // ignore: cast_nullable_to_non_nullable
              as String?,
      pageInfo: freezed == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Items>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoImplCopyWith<$Res> implements $VideoCopyWith<$Res> {
  factory _$$VideoImplCopyWith(
          _$VideoImpl value, $Res Function(_$VideoImpl) then) =
      __$$VideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? kind,
      String? etag,
      String? nextPageToken,
      String? regionCode,
      PageInfo? pageInfo,
      List<Items>? items});
}

/// @nodoc
class __$$VideoImplCopyWithImpl<$Res>
    extends _$VideoCopyWithImpl<$Res, _$VideoImpl>
    implements _$$VideoImplCopyWith<$Res> {
  __$$VideoImplCopyWithImpl(
      _$VideoImpl _value, $Res Function(_$VideoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = freezed,
    Object? etag = freezed,
    Object? nextPageToken = freezed,
    Object? regionCode = freezed,
    Object? pageInfo = freezed,
    Object? items = freezed,
  }) {
    return _then(_$VideoImpl(
      kind: freezed == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String?,
      etag: freezed == etag
          ? _value.etag
          : etag // ignore: cast_nullable_to_non_nullable
              as String?,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
      regionCode: freezed == regionCode
          ? _value.regionCode
          : regionCode // ignore: cast_nullable_to_non_nullable
              as String?,
      pageInfo: freezed == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Items>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoImpl implements _Video {
  _$VideoImpl(
      {this.kind,
      this.etag,
      this.nextPageToken,
      this.regionCode,
      this.pageInfo,
      final List<Items>? items})
      : _items = items;

  factory _$VideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoImplFromJson(json);

  @override
  final String? kind;
  @override
  final String? etag;
  @override
  final String? nextPageToken;
  @override
  final String? regionCode;
  @override
  final PageInfo? pageInfo;
  final List<Items>? _items;
  @override
  List<Items>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Video(kind: $kind, etag: $etag, nextPageToken: $nextPageToken, regionCode: $regionCode, pageInfo: $pageInfo, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.etag, etag) || other.etag == etag) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken) &&
            (identical(other.regionCode, regionCode) ||
                other.regionCode == regionCode) &&
            (identical(other.pageInfo, pageInfo) ||
                other.pageInfo == pageInfo) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, kind, etag, nextPageToken,
      regionCode, pageInfo, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      __$$VideoImplCopyWithImpl<_$VideoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoImplToJson(
      this,
    );
  }
}

abstract class _Video implements Video {
  factory _Video(
      {final String? kind,
      final String? etag,
      final String? nextPageToken,
      final String? regionCode,
      final PageInfo? pageInfo,
      final List<Items>? items}) = _$VideoImpl;

  factory _Video.fromJson(Map<String, dynamic> json) = _$VideoImpl.fromJson;

  @override
  String? get kind;
  @override
  String? get etag;
  @override
  String? get nextPageToken;
  @override
  String? get regionCode;
  @override
  PageInfo? get pageInfo;
  @override
  List<Items>? get items;
  @override
  @JsonKey(ignore: true)
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
