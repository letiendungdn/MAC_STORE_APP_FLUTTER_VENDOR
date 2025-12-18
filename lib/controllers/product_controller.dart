import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mac_store_app_flutter_vendor_app/global_variables.dart';
import 'package:mac_store_app_flutter_vendor_app/models/product.dart';
import 'package:mac_store_app_flutter_vendor_app/services/manage_http_response.dart';

class ProductController {
  Future<void> uploadProduct({
    required BuildContext context,
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
    final cloudinary = CloudinaryPublic('ducobtxxe', 'ymg0fxf2');

    if (pickedImages != null && pickedImages.isNotEmpty) {
      try {
        // Upload each image to Cloudinary and collect secure URLs.
        for (final File image in pickedImages) {
          final CloudinaryResponse cloudinaryResponse =
              await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path, folder: productName),
          );
          images.add(cloudinaryResponse.secureUrl);
        }
      } catch (e) {
        debugPrint('Error uploading images: $e');
        showSnackBar(context, 'Image upload failed, please try again.');
        return;
      }
    } else {
      showSnackBar(context, 'Select Image');
      return;
    }

    if (category.isNotEmpty && subCategory.isNotEmpty) {
      final Product product = Product(
        id: '',
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        description: description,
        category: category,
        vendorId: vendorId,
        fullName: fullName,
        subCategory: subCategory,
        images: images,
      );

      try {
        final http.Response response = await http.post(
          Uri.parse('$uri/api/add-product'),
          body: product.toJson(),
          headers: const <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (!context.mounted) return;

        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product Uploaded');
          },
        );
      } catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString());
        }
        return;
      }
    } else {
      showSnackBar(context, 'Select Category');
    }
  }
}
