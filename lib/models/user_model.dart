
class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({required this.id, required this.name, required this.email, required this.age});

  // Factory method to create a User from JSON
  factory User.fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "age": age,
    };
  }
}
