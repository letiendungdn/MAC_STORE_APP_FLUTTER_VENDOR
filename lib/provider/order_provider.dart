
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app_flutter_vendor_app/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  // Set the list of Orders
  void setOrders(List<Order> orders) {
    state = orders;
  }

  void updateOrderStatus(
    String orderId, {
    bool? processing,
    bool? delivered,
  }) {
    // Update provider state with a new list of orders.
    state = [
      for (final order in state)
        // If this is the target order, create a copied order with new flags.
        if (order.id == orderId)
          Order(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            state: order.state,
            city: order.city,
            locality: order.locality,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            processing: processing ?? order.processing,
            delivered: delivered ?? order.delivered,
            createdAt: order.createdAt,
          )
        else
          order,
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
