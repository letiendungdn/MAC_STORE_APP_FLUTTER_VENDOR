import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mac_store_app_flutter_vendor_app/provider/vendor_provider.dart';
import 'package:mac_store_app_flutter_vendor_app/views/screens/authentication/login_screen.dart';
import 'package:mac_store_app_flutter_vendor_app/views/screens/main_vendor_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      // Retrieve cached auth/token data.
      final String? token = preferences.getString('auth_token');
      final String? vendorJson = preferences.getString('vendor');

      // If both token and data are available, update the vendor state.
      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<void>(
        future: checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final vendor = ref.watch(vendorProvider);
          final bool isLoggedIn = vendor != null;

          return isLoggedIn
              ? const MainVendorScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
