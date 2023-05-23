import 'dart:io';
import 'package:path/path.dart' as path;

final files = [
  'index.html',
  'main.dart.js',
  'flutter.js',
];

/// Read built files from unpublish Flutter web project
/// and save them as static strings in unpub project
/// similar to how unpub_web is used
main(List<String> args) async {

  /// Build for Flutter web
  final result = await Process.run(
    'flutter',
    [
      "build",
      "web",
      "--pwa-strategy=none",
      "--web-renderer=html",
      r'--base-href=/delete/',
    ],
    workingDirectory: 'unpublish',
  );

  if (result.exitCode != 0) {
    print(result.stderr);
    exit(result.exitCode);
  }

  for (var file in files) {
    var content =
        File(path.absolute('unpublish/build/web', file)).readAsStringSync();

    /// Remove favicon from index.html
    if (file == 'index.html') {
      const tagToRemove =
          '<link rel="icon" type="image/png" href="favicon.png"/>';
      content = content.replaceAll(tagToRemove, '');
    }

    content = content.replaceAll('\\', '\\\\').replaceAll('\$', '\\\$');
    content = "const content = '''$content''';\n";
    File(path.absolute('unpub/lib/src/flutter', '${file}.dart'))
        .writeAsStringSync(content);
  }
}
