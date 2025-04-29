import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/add%20post/add_post_screen.dart';
import 'package:social_app/modules/chats_/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings_/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
// import 'package:Genie/modules/settings_/settings_screen.dart';
// import 'package:Genie/shared/components/constants.dart';
// import 'package:Genie/shared/cubit/states.dart';
// import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitial());
  static SocialCubit get(context) => BlocProvider.of(context);
  FlexScheme currentFlexScheme = FlexScheme.money;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDark = false;
  bool commentFull = false;
  bool chatFull = false;
  bool updateUserLoading = false;
  bool profileImageUploaded = false;
  bool coverImageUploaded = false;
  int currentIndex = 0;

  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const AddPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  List infoStats = [
    '105',
    '459',
    '10K',
    '64',
  ];
  void toggleTheme({bool? storedBool}) {
    if (storedBool != null) {
      isDark = storedBool;
      emit(ToggleTheme());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(ToggleTheme());
      });
    }
  }

  void changeIndex(int index, BuildContext context) {
    if (index == 2) {
      navigateTo(context, const AddPostScreen());
      emit(SocialChangeBottomNavBar());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavBar());
    }
  }

  UserModel? currentUserModel;
  void getUserData() {
    if (uId.isNotEmpty) {
      emit(GetUserLoading());
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        currentUserModel = UserModel.fromJson(value.data()!);
        emit(GetUserSuccess());
      }).catchError((error) {
        // print(error.toString());
        emit(GetUserError(error.toString()));
      });
    } else {}
  }

  List<UserModel> users = [];
  List<UserModel> allUsers = [];
  void getUsers() {
    if (users.isEmpty) {
      emit(GetUsersLoading());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.id != uId) {
            users.add(UserModel.fromJson(element.data()));
          }
          allUsers.add(UserModel.fromJson(element.data()));
        }
        emit(GetUsersSuccess());
      }).catchError((error) {
        // print(error.toString());
        emit(GetUsersError(error.toString()));
      });
    }
  }

  final picker = ImagePicker();

  File? profileImage;
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      profileImageUploaded = true;
      emit(ChoosingImageSuccess());
    } else {
      emit(ChoosingImageError());
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      coverImageUploaded = true;
      emit(ChoosingImageSuccess());
    } else {
      print('No image selected');
      emit(ChoosingImageError());
    }
  }

  String? newProfileImageUrl;
  void uploadProfileImage() {
    emit(UploadProfileImageLoading());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(UploadProfileImageSuccess());
        // newProfileImageUrl = value;
        // profileImageUploaded = false;
        updateProfileImage(value);
      }).catchError((error) {
        emit(UploadProfileImageError(error.toString()));
      });
    }).catchError((error) {
      emit(UploadProfileImageError(error.toString()));
    });
  }

  String? newCoverImageUrl;

  void uploadCoverImage() {
    emit(UploadCoverImageLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(UploadCoverImageSuccess());
        // newCoverImageUrl = value;
        // coverImageUploaded = false;
        updateCoverImage(value);
      }).catchError((error) {
        emit(UploadCoverImageError(error.toString()));
      });
    }).catchError((error) {
      emit(UploadCoverImageError(error.toString()));
    });
  }

  void updateProfileImage(String? url) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserModel!.uId)
        .update({'image': url}).then((value) {
      profileImageUploaded = false;
      getUserData();
      emit(UpdateProfileImageSuccess());
    }).catchError((error) {
      emit(UpdateProfileImageError(error.toString()));
    });
  }

  void updateCoverImage(String? url) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserModel!.uId)
        .update({'coverImage': url}).then((value) {
      getUserData();
      coverImageUploaded = false;
      emit(UpdateCoverImageSuccess());
    }).catchError((error) {
      emit(UpdateCoverImageError(error.toString()));
    });
  }

  void updateImages() {
    emit(UpdateImagesLoading());

    if (profileImage != null) {
      uploadProfileImage();
    }
    if (coverImage != null) {
      uploadCoverImage();
    }
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateUserLoading());
    updateUserLoading = true;
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'name': name,
      'phone': phone,
      'bio': bio,
    }).then((value) {
      getUserData();
      updateUserLoading = false;
      emit(UpdateUserSuccess());
    }).catchError((error) {
      UpdateUserError(error.toString());
    });
  }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(ChoosingImageSuccess());
    } else {
      emit(ChoosingImageError());
    }
  }

  void discardPostImageFile() {
    postImage = null;
    emit(DiscardPostImageFile());
  }

  String? postImageUrl;

  void uploadPostImage() {
    emit(UploadPostImageLoading());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(UploadPostImageSuccess());
        postImageUrl = value;
      }).catchError((error) {
        emit(UploadPostImageError(error.toString()));
      });
    }).catchError((error) {
      emit(UploadPostImageError(error.toString()));
    });
  }

  void createNewPost({
    String? postImage,
    required String dateTime,
    required String text,
  }) {
    emit(CreatePostLoading());
    PostModel model = PostModel(
      name: currentUserModel!.name,
      uId: currentUserModel!.uId,
      image: currentUserModel!.image,
      postImage: postImage,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      updateUserLoading = false;
      emit(CreatePostSuccess());
    }).catchError((error) {
      CreatePostError(error.toString());
    });
  }

  List<PostModel> posts = [];
  List<String> postIds = [];
  void getPosts() {
    emit(GetPostsLoading());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      posts = [];
      postIds = [];
      for (var element in event.docs) {
        postIds.add(element.id);
        posts.add(
          PostModel.fromJson(
            element.data(),
          ),
        );
      }
    });
  }

  //?           To Do
  void editPost({
    String? postImage,
    required String dateTime,
    required String text,
  }) {
    emit(CreatePostLoading());
    PostModel model = PostModel(
      name: currentUserModel!.name,
      uId: currentUserModel!.uId,
      image: currentUserModel!.image,
      postImage: postImage,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      updateUserLoading = false;
      emit(CreatePostSuccess());
    }).catchError((error) {
      CreatePostError(error.toString());
    });
  }

  void deletePost({
    required String postId,
  }) {
    emit(DeletePostLoading());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(DeletePostSuccess());
    }).catchError((error) {
      DeletePostError(error.toString());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(currentUserModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(PostLikeSuccess());
    }).catchError((error) {
      emit(PostLikeError(error.toString()));
    });
  }

  void unLikesPost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(currentUserModel!.uId)
        .set({
      'like': false,
    }).then((value) {
      emit(PostLikeSuccess());
    }).catchError((error) {
      emit(PostLikeError(error.toString()));
    });
  }

  void commentFullChange({
    required String value,
  }) {
    if (value.isNotEmpty) {
      commentFull = true;
    } else {
      commentFull = false;
    }
    emit(CommentFullChange());
  }

  void chatFullChange({
    required String value,
  }) {
    if (value.isNotEmpty) {
      chatFull = true;
    } else {
      chatFull = false;
    }
    emit(ChatFullChange());
  }

  void commentOnPost(
    String postId,
    String comment,
    String dateTime,
  ) {
    CommentModel model = CommentModel(
      comment: comment,
      dateTime: dateTime,
      uId: currentUserModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .add(model.toMap())
        .then((value) {
      emit(PostCommentSuccess());
    }).catchError((error) {
      emit(PostCommentError(error.toString()));
    });
  }

  void deleteComment(
    String postId,
    String docId,
  ) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(docId)
        .delete()
        .then((value) {
      emit(DeleteCommentSuccess());
    }).catchError((error) {
      emit(DeleteCommentError(error.toString()));
    });
  }

  void editComment(
    String postId,
    String docId,
    String newComment,
  ) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(docId)
        .update({
      'comment': newComment,
    }).then((value) {
      emit(EditCommentSuccess());
    }).catchError((error) {
      emit(EditCommentError(error.toString()));
    });
  }

  void sendMessage({
    required String dateTime,
    required String message,
    required String senderUId,
    required String receiverUId,
  }) {
    MessageModel model = MessageModel(
      dateTime: dateTime,
      message: message,
      senderId: senderUId,
      receiverId: receiverUId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderUId)
        .collection('chats')
        .doc(receiverUId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(MessageSentSuccess());
    }).catchError((error) {
      emit(MessageSentError(error.toString()));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUId)
        .collection('chats')
        .doc(senderUId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(MessageSentSuccess());
    }).catchError((error) {
      emit(MessageSentError(error.toString()));
    });
  }

  void deleteMessage({
    required String docId,
    required String senderUId,
    required String receiverUId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderUId)
        .collection('chats')
        .doc(receiverUId)
        .collection('messages')
        .doc(docId)
        .delete()
        .then((value) {
      emit(DeleteMessageSuccess());
    }).catchError((error) {
      emit(DeleteMessageError(error.toString()));
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(receiverUId)
    //     .collection('chats')
    //     .doc(senderUId)
    //     .collection('messages')
    //     .doc(docId)
    //     .delete()
    //     .then((value) {
    //   emit(DeleteMessageSuccess());
    // }).catchError((error) {
    //   emit(DeleteMessageError(error.toString()));
    // });
  }

  // void editMessage({
  //   required String docId,
  //   required String newMessage,
  //   required String senderUId,
  //   required String receiverUId,
  // }) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(senderUId)
  //       .collection('chats')
  //       .doc(receiverUId)
  //       .collection('messages')
  //       .doc(docId)
  //       .update({
  //     'message': newMessage,
  //   }).then((value) {
  //     emit(EditMessageSuccess());
  //   }).catchError((error) {
  //     emit(EditMessageError(error.toString()));
  //   });
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(receiverUId)
  //       .collection('chats')
  //       .doc(senderUId)
  //       .collection('messages')
  //       .doc(docId)
  //       .update({
  //     'message': newMessage,
  //   }).then((value) {
  //     emit(EditMessageSuccess());
  //   }).catchError((error) {
  //     emit(EditMessageError(error.toString()));
  //   });
  // }
}
