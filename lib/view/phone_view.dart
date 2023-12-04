import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_bloc.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:firebase_auth_all_feature/view/otp_verify_view.dart';
import 'package:firebase_auth_all_feature/widgets/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneView extends StatefulWidget {
  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Phone Number'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/p.png"),
              const SizedBox(height: 16.0),
              const Welcome(),
              const SizedBox(height: 26.0),
              TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Adds a border
                    labelText: 'Phone Number',
                    hintText: 'Phone Number',
                  ),
                  onChanged: (value) {
                    context.read<AuthBloc>().add(CheckPhoneNumberExist(value));
                  }),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is ShortPhoneNumber) {
                    return const Text(
                      'Phone number must be at least 10 characters',
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (state is PhoneNumberLoading) {
                    return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator());
                  } else if (state is OldPhoneNumber) {
                    return const Text(
                      'Phone number already exist',
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (state is NewPhoneNumber) {
                    return const Text(
                      'Phone number not exist Read to verify',
                      style: TextStyle(color: Colors.green),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 16),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  print(state.toString());
                  if (state is PhoneNumberCodeSent) {
                    print("codesent state");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OtpVerifyView()));
                  }
                },
                builder: (context, state) {
                  if (state is NewPhoneNumber) {
                    return ElevatedButton(
                      onPressed: () async {
                        AuthService.userModel.phone =
                            _phoneNumberController.text.toString();
                        context.read<AuthBloc>().verifyPhoneNumber(
                            _phoneNumberController.text.toString());
                      },
                      child: Text('Verify Phone Number'),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        print("number old");
                      },
                      child: Text('Verify Phone Number'),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
