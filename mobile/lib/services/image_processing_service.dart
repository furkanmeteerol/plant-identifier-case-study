import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';


class ImageProcessingService {
  static const int maxDimension = 1024;
  static const int jpegQuality = 85;

  Future<File> processImage(File inputFile) async {
    final inputBytes = await inputFile.readAsBytes();

    final decodedImage = img.decodeImage(inputBytes);

    if (decodedImage == null) {
      throw Exception('Unable to decode the selected image.');
    }

    final needsResize =
        decodedImage.width > maxDimension ||
        decodedImage.height > maxDimension;

    if (!needsResize) {
      return inputFile;
    }

    final resizedImage = _resizeImage(decodedImage);

    final jpegBytes = img.encodeJpg(
      resizedImage,
      quality: jpegQuality,
    );

    final temporaryDirectory = await getTemporaryDirectory();

    final outputFile = File(
      '${temporaryDirectory.path}/plant_image.jpg',
    );

    await outputFile.writeAsBytes(jpegBytes);

    return outputFile;
  }

  img.Image _resizeImage(img.Image image) {
    final width = image.width;
    final height = image.height;

    if (width >= height) {
      return img.copyResize(
        image,
        width: maxDimension,
      );
    }

    return img.copyResize(
      image,
      height: maxDimension,
    );
  }
}