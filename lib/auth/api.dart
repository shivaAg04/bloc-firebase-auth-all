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
  // signup with email and password
  static Future<UserCredential?> signUpWithEmailPassword(
      String emailAddress, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(userModel.googleAuthCredential!);
      await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(userModel.phoneAuthCredential!);

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

  // change password
  static Future<UserCredential?> changePassword(String password) async {
    try {
      final uc =
          await _auth.signInWithCredential(userModel.phoneAuthCredential!);

      await uc.user!
          .reauthenticateWithCredential(userModel.phoneAuthCredential!)
          .then((value) {
        uc.user!.updatePassword(password);
        print("password change :$password");
      });
      return uc;
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
  static Future<void> signInWithEmailPassword(
      String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw Exception(e.code);
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
        throw Exception(e.code);
        // Handle the case of a wrong password.
      } else {
        throw Exception(e.code);
      }
    } catch (e) {
      print(e.toString());
      throw Exception("Error");
      // General error handling
    }
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

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Authenticate with Firebase using Google Sign-In credentials

        final AuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        if (isEmailExist) {
          //if email exist<old user> then sign in with google

          UserCredential us =
              await _auth.signInWithCredential(googleAuthCredential);
          return us;
        } else {
          ///////if email not exist<New USER> then move to the next screen for more information/////////////

          userModel.googleAuthCredential = googleAuthCredential;
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
  // static Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  // /// google signout
  // static Future<void> googleSignOut() async {
  //   await _googleSignIn.signOut();

  //   await _auth.signOut();
  // }
  static Future<void> signOut() async {
    // Sign out of Firebase
    await _auth.signOut();

    // Check if the user signed in with Google

    if (await _googleSignIn.isSignedIn()) {
      print("google signout");
      await _googleSignIn.signOut();
    }
    // You may also want to check if the user signed in with email/password
    // and perform the logout for that method as well.
  }
}
