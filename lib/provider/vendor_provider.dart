
import 'package:flutter_riverpod/legacy.dart';
import 'package:mac_store_app_flutter_vendor_app/models/vendor.dart';

class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(
          Vendor(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            role: '',
            password: '',
          ),
        );

  // Getter to access current vendor state.
  Vendor? get vendor => state;

  // Updates the vendor state based on JSON string representation.
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  // Clears vendor state (sign out).
  void signOut() {
    state = null;
  }
}

final vendorProvider =
    StateNotifierProvider<VendorProvider, Vendor?>((ref) => VendorProvider());
