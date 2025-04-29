import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/login_cubit_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  void toggleIsPassword() {
    isPassword = !isPassword;
    emit(LoginToggleIsPassword());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccess(value.user!.uid));
    }).catchError((error) {
      emit(LoginError(error.toString()));
    });
  }
}
