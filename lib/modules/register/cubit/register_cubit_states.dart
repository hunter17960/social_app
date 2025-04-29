abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterToggleIsPassword extends RegisterStates {}

class RegisterLoading extends RegisterStates {}

class RegisterSuccess extends RegisterStates {
  // LoginModel loginModel;
  // RegisterSuccess(this.loginModel);
}

class RegisterError extends RegisterStates {
  final String error;
  RegisterError(this.error);
}

class CreateUserLoading extends RegisterStates {}

class CreateUserSuccess extends RegisterStates {
  String uId;
  CreateUserSuccess(this.uId);
}

class CreateUserError extends RegisterStates {
  final String error;
  CreateUserError(this.error);
}
