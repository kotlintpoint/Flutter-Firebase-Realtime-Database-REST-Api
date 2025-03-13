import 'package:dio/dio.dart';
import 'package:flutter_firebase/models/user_model.dart';

class FirebaseService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://your-project-id-default-rtdb.firebaseio.com/",
      headers: {"Content-Type": "application/json"},
    ),
  );

  /// 🔹 Create Data with Auto-Generated Key (POST)
  Future<String?> createUser(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post("users.json", data: data);
      if (response.data != null) {
        String generatedId = response.data['name']; // Firebase returns the generated key
        print("User Created with ID: $generatedId");
        return generatedId;
      }
    } catch (e) {
      print("Error Creating User: $e");
    }
    return null;
  }

  /// 🔹 Get All Users (GET) with JSON Parsing
  Future<List<User>> getAllUsers() async {
    try {
      Response response = await _dio.get("users.json");

      if (response.data != null) {
        Map<String, dynamic> data = response.data;
        List<User> users = [];

        data.forEach((key, value) {
          users.add(User.fromJson(key, value)); // Parse JSON to User model
        });

        return users;
      }
    } catch (e) {
      print("Error Fetching Users: $e");
    }
    return [];
  }

  /// 🔹 Update User (PATCH)
  Future<bool> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      Response response = await _dio.patch("users/$userId.json", data: updatedData);
      if (response.statusCode == 200) {
        print("User Updated Successfully!");
        return true;
      }
    } catch (e) {
      print("Error Updating User: $e");
    }
    return false;
  }

  /// 🔹 Delete User (DELETE)
  Future<bool> deleteUser(String userId) async {
    try {
      Response response = await _dio.delete("users/$userId.json");
      if (response.statusCode == 200) {
        print("User Deleted Successfully!");
        return true;
      }
    } catch (e) {
      print("Error Deleting User: $e");
    }
    return false;
  }

  Future<List<User>> addOrUpdateUser(Future<List<User>> futureUsers, User newUser, int? index) async {
    // Await the completion of the original future to get the list of users
    List<User> users = await futureUsers;
    // Add the new user to the list
    if(index == null){
      users.insert(0, newUser);
    }else{
      users[index] = newUser;
    }
    // Return a new future with the updated list
    return users;
  }

  Future<List<User>> removeUser(Future<List<User>> futureUsers, int? index) async {
    // Await the completion of the original future to get the list of users
    List<User> users = await futureUsers;
    // Add the new user to the list
    users.removeAt(index!);
    // Return a new future with the updated list
    return users;
  }
}
