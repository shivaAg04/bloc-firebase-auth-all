abstract class AuthEvent {}

class LoginWithGoogle extends AuthEvent {
  LoginWithGoogle();
}

class CheckAuth extends AuthEvent {
  CheckAuth();
}

class CheckUserNameExist extends AuthEvent {
  String username;
  CheckUserNameExist(this.username);
}

class SaveUserName extends AuthEvent {
  String username;
  SaveUserName(this.username);
}

//for   phone number

//check phone number exist
class CheckPhoneNumberExist extends AuthEvent {
  String phoneNumber;
  CheckPhoneNumberExist(this.phoneNumber);
}

//verify phone number
class VerifyPhoneNumber extends AuthEvent {
  String phoneNumber;
  VerifyPhoneNumber(this.phoneNumber);
}

// otp verification
class VerifyOtp extends AuthEvent {
  String otp;
  VerifyOtp(this.otp);
}
// for password

// password submit
class PasswordSubmit extends AuthEvent {
  String password;
  PasswordSubmit(this.password);
}

// login with email and password
class LoginWithEmailPassword extends AuthEvent {
  String email;
  String password;
  LoginWithEmailPassword(this.email, this.password);
}
