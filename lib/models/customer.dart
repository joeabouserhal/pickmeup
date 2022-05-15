class Customer {
  String email;
  int id;
  String phone;
  String firstName;
  String lastName;

  Customer(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.id});

  static Customer fromJson(Map<String, dynamic> json) {
    return Customer(
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        id: json['id'] as int);
  }
}
