abstract class LoginStates {}

class LoginInitial extends LoginStates {}

class LoginToggleIsPassword extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginSuccess extends LoginStates {
  String uId;
  LoginSuccess(this.uId);
}

class LoginError extends LoginStates {
  final String error;
  LoginError(this.error);
}
