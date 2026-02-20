import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app_flutter_vendor_app/global_variables.dart';
import 'package:mac_store_app_flutter_vendor_app/models/order.dart';
import 'package:mac_store_app_flutter_vendor_app/services/manage_http_response.dart';

class OrderController {

  // Method to GET Orders by vendor id
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data
            .map((order) => Order.fromJson(order as Map<String, dynamic>))
            .toList();
        return orders;
      } else {
        throw Exception(
          'Failed to load Orders: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error loading Orders: $e');
    }
  }

  //delete order by ID
  Future<void> deleteOrder({
    required String id,
    required BuildContext context,
  }) async {
    try {
      //send an HTTP Delete request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );
      if (!context.mounted) return;

      //handle the HTTP Response
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          if (!context.mounted) return;
          showSnackBar(context, 'Order Deleted successfully');
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString());
    }
  }

  Future<bool> markOrderAsDelivered({
    required String id,
    required BuildContext context,
  }) async {
    try {
      final http.Response response = await http.put(
        Uri.parse('$uri/api/orders/$id/delivered'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'processing': false,
          'delivered': true,
        }),
      );

      if (!context.mounted) return false;

      bool isSuccess = false;
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          isSuccess = true;
          showSnackBar(context, 'Order marked as delivered');
        },
      );
      return isSuccess;
    } catch (e) {
      if (!context.mounted) return false;
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
