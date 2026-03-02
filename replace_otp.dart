import 'dart:io';

void main() {
  final oldLines = File('lib/ui/auth_screen/otp_screen.dart').readAsLinesSync();
  final newBlock =
      File('lib/ui/auth_screen/temp_otp_replace.dart').readAsLinesSync();

  final top = oldLines.sublist(0, 33); // lines 1 to 33
  final bottom = oldLines.sublist(518); // from line 519

  final out = [...top, ...newBlock, ...bottom];
  File('lib/ui/auth_screen/otp_screen.dart').writeAsStringSync(out.join('\n'));
}
