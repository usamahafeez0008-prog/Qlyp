import 'dart:io';

void main() {
  final oldLines =
      File('lib/ui/auth_screen/login_screen.dart').readAsLinesSync();
  final newBlock =
      File('lib/ui/auth_screen/temp_replace.dart').readAsLinesSync();

  final top = oldLines.sublist(0, 39); // indexes 0..38 (lines 1 to 39)
  final bottom = oldLines.sublist(1039); // indexes 1039..end (from line 1040)

  final out = [...top, ...newBlock, ...bottom];
  File('lib/ui/auth_screen/login_screen.dart')
      .writeAsStringSync(out.join('\n'));
}
