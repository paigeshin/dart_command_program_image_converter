# Reference 

https://github.com/paigeshin/dart_create_library

https://pub.dev/packages/prompt_king


# What to expect from the project

- Working with the file system (reading/writing files)
- Asynchronous code with Dart (futures)
- Regexp's (working with strings)

# Create Project

```bash
dart create ${converter}
dart pub get 
```

# with Imported Project

- The library I created

```dart
import 'dart:io';

import 'package:prompt_king/prompt_king.dart';

void main() {
  final prompter = Prompter();
  final choice = prompter.askBinary('Are you here to convert an image?');
  print(choice);
  if (!choice) {
    exit(0);
  }
}
```

# Pubspec

```yaml
name: converter
description: A simple command-line application.
version: 1.0.0
# homepage: https://www.example.com

environment:
  sdk: '>=2.12.0 <3.0.0'

dependencies:
  prompt_king: ^0.0.1
  image: ^3.0.2
dev_dependencies:
  pedantic: ^1.10.0
```

# lib/src/converter.dart

```dart
import 'dart:io';
import 'package:image/image.dart';

String convertImage(FileSystemEntity selectedFile, String format) {
  //Create ImageFile
  final rawImage = createRawFileImage(selectedFile);
  if (rawImage == null) {
    return "Can't Convert Image...";
  }

  var newImage;
  // Encode png or Encode jpg
  if (format == 'jpeg' || format == 'jpg') {
    newImage = encodeJpg(rawImage);
  } else if (format == 'png') {
    newImage = encodePng(rawImage);
  } else {
    print('Unsupported file type');
  }

  //Writing file to hard drive
  final newPath = replaceExtension(selectedFile.path, format);
  File(newPath).writeAsBytesSync(newImage);
  return newPath;
}

String replaceExtension(String path, String newExtension) {
  return path.replaceAll(RegExp(r'(png|jpg|jpeg)'), newExtension);
}

Image? createRawFileImage(FileSystemEntity selectedFile) {
  final file = selectedFile as File;
  final rawImage = file.readAsBytesSync();
  return decodeImage(rawImage);
}
```

# bin/converter.dart

```dart
import 'dart:io';
import 'package:prompt_king/prompt_king.dart';
import 'package:converter/src/converter.dart';

void main(List<String> arguments) {
  final prompter = Prompter();
  final choice = prompter.askBinary('Are you here to convert an image?');
  print(choice);
  if (!choice) {
    exit(0);
  }

  final format = prompter.askMultiple('Select format', buildFormatOptions());
  final selectedFile =
      prompter.askMultiple('Select an image to convert:', buildFileOptions());
  final newPath = convertImage(selectedFile, format);
  final shouldOpen = prompter.askBinary('Open the image?');
  if (shouldOpen) {
    Process.run('open', [newPath]);
  }
}

List<Option> buildFormatOptions() {
  return [
    Option('Convert to jpeg', 'jpeg'),
    Option('Convert to png', 'png'),
  ];
}

List<Option> buildFileOptions() {
  // Take all the images and create an option object out of each
  return Directory.current
      .listSync()
      .where((entity) =>
          FileSystemEntity.isFileSync(entity.path) &&
          entity.path.contains(RegExp(r'\.(png|jpg|jpeg)')))
      .map((entity) {
    final filename = entity.path.split(Platform.pathSeparator).last;
    return Option(filename, entity);
  }).toList();
}
```