import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';

class ProductController {
  Future<List<String>> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
  }) async {
    final List<String> images = <String>[];

    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic('ducobtxxe', 'ymg0fxf2');

      try {
        for (var i = 0; i < pickedImages.length; i++) {
          final CloudinaryResponse cloudinaryResponse = await cloudinary
              .uploadFile(
                CloudinaryFile.fromFile(
                  pickedImages[i].path,
                  folder: productName,
                ),
              );

          images.add(cloudinaryResponse.secureUrl);
        }
      } catch (e) {
        debugPrint('Error uploading images: $e');
        rethrow;
      }
    }

    return images;
  }
}
