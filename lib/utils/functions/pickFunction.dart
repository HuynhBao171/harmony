import 'package:deep_pick/deep_pick.dart';
import 'package:harmony/utils/extensions/dartExtensions.dart';

String pickVideoId(List<dynamic> recentSearches, int index) {
  return pick(recentSearches, index, 'id').asStringOrNull() ?? '';
}

String pickThumbnailUrl(List<dynamic> recentSearches, int index) {
  return pick(recentSearches, index, 'snippet', 'thumbnails', 'default', 'url')
          .asStringOrNull() ??
      '';
}

String pickTitle(List<dynamic> recentSearches) {
  return (pick(recentSearches, 'snippet', 'title')
          .asStringOrNull()
          ?.trimTitle()) ??
      '';
}

String pickChannelTitle(List<dynamic> recentSearches) {
  return pick(recentSearches, 'snippet', 'channelTitle').asStringOrNull() ?? '';
}
