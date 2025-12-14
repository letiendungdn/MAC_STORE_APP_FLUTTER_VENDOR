import 'dart:convert';

class Vendor {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;

  Vendor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.role,
    required this.password,
  });

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      state: map['state'] as String? ?? '',
      city: map['city'] as String? ?? '',
      locality: map['locality'] as String? ?? '',
      role: map['role'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password,
    };

    // Many backends (e.g. Mongo) use `_id`. For signup, id is typically absent.
    if (id.isNotEmpty) {
      map['_id'] = id;
    }

    return map;
  }

  String toJson() => json.encode(toMap());

  factory Vendor.fromJson(String source) => Vendor.fromMap(json.decode(source));
}
