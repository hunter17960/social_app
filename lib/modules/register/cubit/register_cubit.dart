import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
// import 'package:social_app/models/login_model.dart';
import 'package:social_app/modules/register/cubit/register_cubit_states.dart';
// import 'package:social_app/shared/network/end_points.dart';
// import 'package:social_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  List<String> imageUrls = [
    'https://picfiles.alphacoders.com/633/633933.jpeg',
    'https://picfiles.alphacoders.com/633/633935.jpeg',
    'https://picfiles.alphacoders.com/633/633936.jpeg',
    'https://picfiles.alphacoders.com/633/633939.jpeg',
    'https://picfiles.alphacoders.com/633/633937.jpeg',
    'https://picfiles.alphacoders.com/633/633940.jpeg',
    'https://picfiles.alphacoders.com/633/633938.jpeg',
    'https://picfiles.alphacoders.com/633/633934.jpeg',
  ];

  String tempImage() {
    final random = Random();
    final randomIndex = random.nextInt(imageUrls.length);
    return imageUrls[randomIndex];
  }

  // late LoginModel loginModel;
  void toggleIsPassword() {
    isPassword = !isPassword;
    emit(RegisterToggleIsPassword());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
        image: tempImage(),
        coverImage: 'https://images5.alphacoders.com/101/1010058.jpg',
        bio: 'Write Your Bio ...',
        isEmailVerified: true,
      );
    }).catchError((error) {
      print(error.toString());
      emit(RegisterError(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required String image,
    required String coverImage,
    required String bio,
    required bool isEmailVerified,
  }) {
    emit(CreateUserLoading());
    UserModel model = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      image: image,
      coverImage: coverImage,
      bio: bio,
      isEmailVerified: isEmailVerified,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      // print(value.firestore.);
      emit(CreateUserSuccess(uId));
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserError(error.toString()));
    });
  }
}
