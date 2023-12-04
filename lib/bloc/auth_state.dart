import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {
  AuthInitialState();
}

class NewUser extends AuthState {
  NewUser();
}

class Authenticated extends AuthState {
  Authenticated();
}

class UnAuthenticated extends AuthState {
  UnAuthenticated();
}

class OldUser extends AuthState {
  OldUser();
}

class NewUserName extends AuthState {
  NewUserName();
}

class OldUserName extends AuthState {
  OldUserName();
}

class UserNameLoading extends AuthState {
  UserNameLoading();
}

class ShortUserName extends AuthState {
  ShortUserName();
}
// phone number states

// code sent on phone number state
class PhoneNumberCodeSent extends AuthState {
  PhoneNumberCodeSent();
}

//old phone number state
class OldPhoneNumber extends AuthState {
  OldPhoneNumber();
}

//new phone number state
class NewPhoneNumber extends AuthState {
  NewPhoneNumber();
}

//Short phone number state
class ShortPhoneNumber extends AuthState {
  ShortPhoneNumber();
}

//phone number loading state
class PhoneNumberLoading extends AuthState {
  PhoneNumberLoading();
}
//otp verification states

//otp verifying
class OtpVerifying extends AuthState {
  OtpVerifying();
}

//otp verified
class OtpVerified extends AuthState {
  OtpVerified();
}

// password states

//password loading
class PasswordLoading extends AuthState {
  PasswordLoading();
}

// Account created
class AccountCreated extends AuthState {
  AccountCreated();
}

//////////login states

//login loading
class LoginLoading extends AuthState {
  LoginLoading();
}

//login success
class LoginSuccess extends AuthState {
  LoginSuccess();
}

// login failed
class LoginFailed extends AuthState {
  String error;
  LoginFailed(this.error);
}

// PasswordWrong
class PasswordWrong extends AuthState {
  PasswordWrong();
}

// UserNotFound
class UserNotFound extends AuthState {
  UserNotFound();
}
