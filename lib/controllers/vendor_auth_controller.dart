import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mac_store_app_flutter_vendor_app/global_variables.dart';
import 'package:mac_store_app_flutter_vendor_app/models/vendor.dart';
import 'package:mac_store_app_flutter_vendor_app/services/manage_http_response.dart';

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final Vendor vendor = Vendor(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );

      final http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: vendor.toJson(),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          showSnackBar(context, 'Vendor Account Created');
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString());
    }
  }
}


