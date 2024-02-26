import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'create_user_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();

  void _deleteUser(String userId) async {
    try {
      await _userService.deleteUser(userId);
      // Affiche un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User successfully deleted')),
      );
      // Rafraîchir la liste des utilisateurs
      setState(() {});
    } catch (e) {
      // Affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the User Manager Screen!'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<List<User>>(
        future: _userService.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user.id),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No users found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateUserPage()),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
        tooltip: 'Create a User',
      ),
    );
  }
}
