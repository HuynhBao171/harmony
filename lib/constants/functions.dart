//

// String formatDuration(int seconds) {
//   final minutes = seconds ~/ 60;
//   final remainingSeconds = seconds % 60;
//   final minutesStr = minutes.toString().padLeft(2, '0');
//   final secondsStr = remainingSeconds.toString().padLeft(2, '0');
//   return '$minutesStr:$secondsStr';
// }

extension FormatDuration on int {
  String formatDuration() {
    final minutes = this ~/ 60;
    final remainingSeconds = this % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}

extension StringTrimTitle on String {
  String trimTitle() {
    int index = indexOf(RegExp(r'[\(|\|]'));
    return index == -1 ? this : substring(0, index);
  }
}
