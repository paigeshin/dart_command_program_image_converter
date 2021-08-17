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
    Option('Confert to png', 'png'),
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
