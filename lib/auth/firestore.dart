import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_all_feature/auth/api.dart';

class FirebaseCloudStoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //check wheather email exist or not
  static Future<bool> checkEmailExist(String email) async {
    try {
      // Get a specific document by its ID (replace 'email' with the actual document ID)
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('email').doc(email).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // old user
        print('Document data: ${documentSnapshot.data()}');

        return true;
      } else {
        // new user
        print('Document does not exist on the database');

        return false;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return false;
    }
  }

  //check wheather phone exist or not
  static Future<bool> checkPhoneNumberExist(String phone) async {
    try {
      // Get a specific document by its ID (replace 'phone' with the actual document ID)
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('phone').doc(phone).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // old user
        print('Document data: ${documentSnapshot.data()}');

        return true;
      } else {
        // new user
        print('Document does not exist on the database');

        return false;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return false;
    }
  }

  //check wheather username exist or not
  static Future<bool> checkUsernameExist(String username) async {
    try {
      // Get a specific document by its ID (replace 'username' with the actual document ID)
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('userid').doc(username).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // old user
        print('Document data: ${documentSnapshot.data()}');

        return true;
      } else {
        // new user
        print('Document does not exist on the database');

        return false;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return false;
    }
  }
  //save data on firebase

  static Future<void> saveDataOnFirebase() async {
    final email = AuthService.userModel.email;
    final phone = AuthService.userModel.phone;
    final username = AuthService.userModel.username;

    try {
      await _firestore.collection('userid').doc(username).set({
        'email': email,
      });
      await _firestore.collection('email').doc(email).set({
        'email': email,
      });
      await _firestore.collection('phone').doc(phone).set({
        'email': email,
      });
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  // get email from username/phone/email

  static Future<String?> getEmail(String username) async {
    String? email;
    await checkUsernameExist(username).then((value) async {
      if (value) {
        await _firestore.collection('userid').doc(username).get().then((value) {
          final data = value.data();
          print(data!['email']);
          email = data['email'];
        });
      } else {
        await checkPhoneNumberExist(username).then((value) async {
          if (value) {
            await _firestore
                .collection('phone')
                .doc(username)
                .get()
                .then((value) {
              final data = value.data();
              print(data!['email']);
              email = data['email'];
            });
          } else {
            await checkEmailExist(username).then((value) async {
              if (value) {
                await _firestore
                    .collection('email')
                    .doc(username)
                    .get()
                    .then((value) {
                  final data = value.data();
                  print(data!['email']);
                  email = data['email'];
                });
              }
            });
          }
        });
      }
    });

    return email;
  }
}
