import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/user_model.dart';
import 'package:flutter_firebase/services/firebase_service.dart';
import 'package:flutter_firebase/users/user_form.dart';


class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<User>> users;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    users = _firebaseService.getAllUsers();;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Age : ${user.age}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserForm(user: user)),
                          ).then((value) {
                            if (value["status"] == true) {
                              // Refresh the list
                              setState(() {
                                users = _firebaseService.addOrUpdateUser(users, value["user"], index);
                              });
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _firebaseService.deleteUser(user.id);
                          setState(() {
                            users = _firebaseService.removeUser(users, index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserForm()),
          ).then((value) {
            if (value["status"] == true) {
              setState(() {
                users = _firebaseService.addOrUpdateUser(users, value["user"], null);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}