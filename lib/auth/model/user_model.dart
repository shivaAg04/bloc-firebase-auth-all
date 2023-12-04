import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? username;
  String? phone;
  String? email;
  String? password;
  String? verificationId;
  AuthCredential? googleAuthCredential;
  UserModel(
      {this.firstName,
      this.lastName,
      this.username,
      this.phone,
      this.email,
      this.password,
      this.verificationId,
      this.googleAuthCredential});
}
