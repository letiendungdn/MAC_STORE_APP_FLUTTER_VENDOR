import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mac_store_app_flutter_vendor_app/global_variables.dart';
import 'package:mac_store_app_flutter_vendor_app/models/vendor.dart';
import 'package:mac_store_app_flutter_vendor_app/provider/vendor_provider.dart';
import 'package:mac_store_app_flutter_vendor_app/services/manage_http_response.dart';
import 'package:mac_store_app_flutter_vendor_app/views/screens/main_vendor_screen.dart';

final ProviderContainer providerContainer = ProviderContainer();

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

  Future<void> signInVendor({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final SharedPreferences preferences =
              await SharedPreferences.getInstance();

          // Extract and persist auth token.
          final String token = jsonDecode(response.body)['token'] as String;
          await preferences.setString('auth_token', token);

          // Encode vendor payload as JSON string.
          final String vendorJson = jsonEncode(
            jsonDecode(response.body)['vendor'],
          );

          // Update vendor state via Riverpod.
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

          // Persist vendor JSON locally.
          await preferences.setString('vendor', vendorJson);

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainVendorScreen();
              },
            ),
            (route) => false,
          );
          showSnackBar(context, 'Logged in successfully');
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString());
    }
  }
}
