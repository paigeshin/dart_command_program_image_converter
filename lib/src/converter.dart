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
