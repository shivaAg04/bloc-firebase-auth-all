import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_all_feature/auth/api.dart';
import 'package:firebase_auth_all_feature/auth/firestore.dart';
import 'package:firebase_auth_all_feature/bloc/auth.event.dart';
import 'package:firebase_auth_all_feature/bloc/auth_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<LoginWithGoogle>(_loginWithGoogle);
    on<CheckAuth>(_checkAuth);
    on<CheckUserNameExist>(_checkUserNameExist);

    on<CheckPhoneNumberExist>(_checkPhoneNumberExist);
    on<VerifyOtp>(_verifyOtp);
    on<PasswordSubmit>(_passwordSubmit);
    on<LoginWithEmailPassword>(_loginWithEmailPassword);

    add(CheckAuth());
  }
// login with email/username/phone and password

  Future<void> _loginWithEmailPassword(
      LoginWithEmailPassword event, Emitter<AuthState> emit) async {
    try {
      emit(LoginLoading());
      await FirebaseCloudStoreService.getEmail(event.email).then((value) async {
        if (value != null) {
          //email exist
          await AuthService.signInWithEmailPassword(value, event.password)
              .then((value) {
            //login success
            emit(LoginSuccess());
          }).onError((error, stackTrace) {
            emit(PasswordWrong());
          });
        } else {
          //email not exist
          emit(UserNotFound());
        }
      });
    } catch (error) {
      emit(LoginFailed());
    }
  }

  //for phone number

  //check phone number exist
  Future<void> _checkPhoneNumberExist(
      CheckPhoneNumberExist event, Emitter<AuthState> emit) async {
    if (event.phoneNumber.length < 10) {
      print('Phone number must be at least 10 characters');
      emit(ShortPhoneNumber());
      return;
    }
    emit(PhoneNumberLoading());
    await FirebaseCloudStoreService.checkPhoneNumberExist(event.phoneNumber)
        .then((value) {
      if (value) {
        //phone number exist
        emit(OldPhoneNumber());
      } else {
        //phone number not exist

        emit(NewPhoneNumber());
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  //for verifying phone number

  void verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${phoneNumber}",
        verificationCompleted: (_) async {},
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed");
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          print("codeSent");

          AuthService.userModel.verificationId = verificationId;
          emit(PhoneNumberCodeSent());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("codeAutoRetrievalTimeout");
          // Auto-resolution timed out...
        },
      );
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }
  // otp verification

  Future<void> _verifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    try {
      emit(OtpVerifying());
      print("otpverifying");
      PhoneAuthProvider.credential(
          verificationId: AuthService.userModel.verificationId!,
          smsCode: event.otp);

      emit(OtpVerified());
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  // submit password and create account
  Future<void> _passwordSubmit(
      PasswordSubmit event, Emitter<AuthState> emit) async {
    try {
      emit(PasswordLoading());

      await AuthService.signUpWithEmailPassword(
              AuthService.userModel.email!, AuthService.userModel.password!)
          .then((value) async {
        if (value != null) {
          await FirebaseCloudStoreService.saveDataOnFirebase().then((value) {
            emit(AccountCreated());
          });
        } else {}
      }).catchError((error) {
        print('Error: $error');
      });
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> _checkUserNameExist(
      CheckUserNameExist event, Emitter<AuthState> emit) async {
    if (event.username.length < 4) {
      print('Username must be at least 4 characters');
      emit(ShortUserName());
      return;
    }
    emit(UserNameLoading());
    await FirebaseCloudStoreService.checkUsernameExist(event.username)
        .then((value) {
      if (value) {
        //username exist
        emit(OldUserName());
      } else {
        //username not exist

        emit(NewUserName());
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future<void> _loginWithGoogle(
      LoginWithGoogle event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    await AuthService.handleSignIn().then((value) {
      if (value == null) {
        //new user go to name and username screen
        emit(NewUser());
      } else {
        //old user go to home screen
        print('Signed in: ${value.user!.displayName}');
        emit(OldUser());
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  //check user is log in or not
  Future<void> _checkAuth(CheckAuth event, Emitter<AuthState> emit) async {
    if (AuthService.currentUser != null) {
      print('Signed in: ${AuthService.currentUser!.displayName}');
      emit(Authenticated());
    } else {
      print('Not signed in');
      emit(UnAuthenticated());
    }
  }
}
