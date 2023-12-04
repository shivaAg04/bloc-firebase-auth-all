import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/auth/model/user_model.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:firebase_auth_all_feature/view/phone_view.dart';
import 'package:firebase_auth_all_feature/widgets/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserNameView extends StatefulWidget {
  UserNameView();

  @override
  State<UserNameView> createState() => _UserNameViewState();
}

class _UserNameViewState extends State<UserNameView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController firstNameController =
        TextEditingController(text: AuthService.userModel.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: AuthService.userModel.lastName);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/p.png"),
              const SizedBox(height: 16.0),
              const Welcome(),
              const SizedBox(height: 26.0),
              TextField(
                decoration: const InputDecoration(labelText: 'First Name'),
                controller: firstNameController,
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                controller: lastNameController,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  controller: usernameController,
                  onChanged: (value) {
                    print('Username entered: $value');
                    context
                        .read<AuthBloc>()
                        .add(CheckUserNameExist(value.toString()));
                  }),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is ShortUserName) {
                  return const Text(
                    "Username is too short",
                    style: TextStyle(color: Colors.red),
                  );
                } else if (state is OldUserName) {
                  return const Row(
                    children: [
                      Text(
                        "Username is already taken",
                        style: TextStyle(color: Colors.red),
                      ),
                      Icon(
                        Icons.close,
                        color: Colors.red,
                      )
                    ],
                  );
                } else if (state is NewUserName) {
                  return const Row(
                    children: [
                      Text(
                        "Username is available",
                        style: TextStyle(color: Colors.green),
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    ],
                  );
                } else if (state is UserNameLoading) {
                  return const Row(
                    children: [
                      Text(
                        "Checking username",
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      CircularProgressIndicator(),
                    ],
                  );
                } else {
                  return Text("");
                }
              }),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text;
                  // Perform any action with the entered username
                  print('Username entered: $username');
                  if (context.read<AuthBloc>().state is NewUserName) {
                    AuthService.userModel.username = usernameController.text;
                    AuthService.userModel.firstName = firstNameController.text;
                    AuthService.userModel.lastName = lastNameController.text;

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PhoneView(),
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
