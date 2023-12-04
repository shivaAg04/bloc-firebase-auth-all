import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_all_feature/auth/firestore.dart';
import 'package:firebase_auth_all_feature/auth/model/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static User? get currentUser => _auth.currentUser;
  static final UserModel userModel = UserModel();

  static Future<UserCredential?> signUpWithEmailPassword(
      String emailAddress, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      print("////////////");
      print(credential.user!.email);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        // Handle the case of a weak password
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        // Handle the case of an existing email
      }
    } catch (e) {
      print(e);
      // General error handling
    }
    // Return null or handle as needed in your application logic
    return null;
  }

  /// Sign in with email and password
  static Future<UserCredential?> signInWithEmailPassword(
      String emailAddress, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // Handle the case of a user not found
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // Handle the case of a wrong password
      }
      // You can add more specific error handling if needed
    } catch (e) {
      print(e);
      // General error handling
    }
    // Return null or handle as needed in your application logic
    return null;
  }

  //google sign in
  static Future<UserCredential?> handleSignIn() async {
    try {
      // Trigger Google Sign-In

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final isEmailExist = await FirebaseCloudStoreService.checkEmailExist(
            googleSignInAccount.email);
        if (isEmailExist) {
          //if email exist<old user> then sign in with google

          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;

          // Authenticate with Firebase using Google Sign-In credentials

          final OAuthCredential googleAuthCredential =
              GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          UserCredential us =
              await _auth.signInWithCredential(googleAuthCredential);
          return us;
        } else {
          ///////if email not exist<New USER> then move to the next screen for more information/////////////
          userModel.email = googleSignInAccount.email;
          final fullName = googleSignInAccount.displayName!.split(" ");
          userModel.firstName = fullName[0];
          if (fullName.length > 1) {
            userModel.lastName = fullName[1];
          } else {
            userModel.lastName = "";
          }
          return null;
        }
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  //verify phone number
  static Future<String?> verifyPhoneNumber(String phoneNumber) async {
    String? _verificationId;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: (_) async {
          // ANDROID ONLY!
          // Sign the user in (or link) with the auto-generated credential
          // await _auth.signInWithCredential(credential);
          // print("verificationCompleted");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed");
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          print("codeSent");
          _verificationId = verificationId;

          // // Update the UI - wait for the user to enter the SMS code
          // String smsCode = '123456';

          // Create a PhoneAuthCredential with the code
          // PhoneAuthCredential phoneAuthCredential =
          //     PhoneAuthProvider.credential(
          //         verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          // await _auth.signInWithCredential(phoneAuthCredential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("codeAutoRetrievalTimeout");
          // Auto-resolution timed out...
        },
      );
      AuthService.userModel.verificationId = _verificationId;
      return _verificationId;
    } catch (error) {
      print('Error signing in with Google: $error');
      return _verificationId;
    }
  }

  //////Sign out Function////////////////////
  static Future<void> signOut() async {
    await _googleSignIn.disconnect().then((value) {
      _auth.signOut();
    });
  }
}
