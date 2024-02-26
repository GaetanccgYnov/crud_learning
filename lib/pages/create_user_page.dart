import 'package:flutter/material.dart';
import '../services/user_service.dart'; // Assurez-vous d'avoir ce service implémenté
import '../models/user.dart'; // Assurez-vous que votre modèle User est à jour

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  Civilite _selectedCivilite = Civilite.Monsieur;

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        id: '',
        name: _nameController.text,
        email: _emailController.text,
        civilite: _selectedCivilite,
      );
      try {
        await UserService().createUser(newUser);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create user'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Civilite>(
                value: _selectedCivilite,
                decoration: InputDecoration(labelText: 'Civilité'),
                onChanged: (Civilite? newValue) {
                  setState(() {
                    _selectedCivilite = newValue!;
                  });
                },
                items: Civilite.values.map((Civilite classType) {
                  return DropdownMenuItem<Civilite>(
                      value: classType, child: Text(civiliteToString(classType)));
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _createUser,
                  child: Text('Create User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
