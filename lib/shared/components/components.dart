import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

enum ToastStates { success, error, warning }

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function Function(String)? onSubmit,
  final ValueChanged<String>? onChange,
  final VoidCallback? onTap,
  bool isPassword = false,
  required final FormFieldValidator<String> validator,
  required String label,
  String? initialText,
  required IconData prefix,
  IconData? suffix,
  final VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  required Color background,
  required Color onBackground,
  double radius = 25.0,
  bool? loading,
  required VoidCallback? onPressed,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: loading == null
            ? Text(
                text,
                style: TextStyle(
                  color: onBackground,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void navigateAndReplace(context, widget) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

void showToast({
  required String message,
  required BuildContext context,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state: state, context: context)[0],
    textColor: chooseToastColor(state: state, context: context)[1],
  );
}

List<Color> chooseToastColor({
  required ToastStates state,
  required BuildContext context,
}) {
  late Color color;
  late Color onColor;
  switch (state) {
    case ToastStates.success:
      color = Theme.of(context).colorScheme.primary;
      onColor = Theme.of(context).colorScheme.onPrimary;
      break;
    case ToastStates.error:
      color = Theme.of(context).colorScheme.error;
      onColor = Theme.of(context).colorScheme.onError;
      break;
    case ToastStates.warning:
      color = Theme.of(context).colorScheme.secondary;
      onColor = Theme.of(context).colorScheme.onSecondary;
      break;
    default:
      color = Theme.of(context).colorScheme.error;
      onColor = Theme.of(context).colorScheme.onError;
  }
  return [
    color,
    onColor,
  ];
}

Widget buildCachedNetworkImage({
  required String url,
  required BuildContext context,
  double? height,
  double? width,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height ?? 100,
    width: width ?? 100,
    errorWidget: (context, url, error) => const Padding(
      padding: EdgeInsets.all(20.0),
      child: Image(
        image: AssetImage(
          'assets/images/errorImage.png',
        ),
      ),
    ),
    fit: BoxFit.cover,
    placeholder: (context, url) => buildShimmerImage(
      context: context,
    ),
  );
}

Widget buildShimmerImage({
  required BuildContext context,
}) {
  return Shimmer.fromColors(
    baseColor: Theme.of(context).primaryColor,
    highlightColor: Theme.of(context).highlightColor,
    child: Container(
      height: 190.0,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
      ),
    ),
  );
}

commentsBottomSheet({
  required BuildContext context,
  required String postId,
  required TextEditingController commentController,
  bool? commentFocus,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    shape: const Border(
      bottom: BorderSide.none,
      top: BorderSide.none,
      left: BorderSide.none,
      right: BorderSide.none,
    ),
    context: context,
    builder: (context) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('comment')
              .orderBy('dateTime')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CommentModel> comments = [];
              List<String> commentsIds = [];
              for (var element in snapshot.data!.docs) {
                comments.add(
                  CommentModel.fromJson(
                    (element.data() as Map<String, dynamic>)
                        .cast<String, dynamic>(),
                  ),
                );
                commentsIds.add(element.id);
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          if (comments.isNotEmpty)
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    comments.length,
                                    (index) {
                                      return InkWell(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12.0)),
                                        onLongPress: () {
                                          if (comments[index].uId == uId) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Time"),
                                                  content: Text(DateFormat.yMd()
                                                      .add_jm()
                                                      .format(DateTime.parse(
                                                          comments[index]
                                                              .dateTime))),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            TextEditingController
                                                                newCommentController =
                                                                TextEditingController();
                                                            newCommentController
                                                                    .text =
                                                                comments[index]
                                                                    .comment;
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'New Message',
                                                              ),
                                                              content:
                                                                  TextFormField(
                                                                maxLines: 5,
                                                                minLines: 1,
                                                                controller:
                                                                    newCommentController,
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (newCommentController
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      SocialCubit.get(
                                                                              context)
                                                                          .editComment(
                                                                        postId,
                                                                        commentsIds[
                                                                            index],
                                                                        newCommentController
                                                                            .text,
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Done'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Edit',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                'Delete',
                                                              ),
                                                              content:
                                                                  const Text(
                                                                'Are you sure You want to delete this comment',
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .unselectedWidgetColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    SocialCubit.get(
                                                                            context)
                                                                        .deleteComment(
                                                                      postId,
                                                                      commentsIds[
                                                                          index],
                                                                    );
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Sure',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .error,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Card(
                                            color:
                                                Theme.of(context).dividerColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    maxRadius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            40,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: ClipOval(
                                                      child:
                                                          buildCachedNetworkImage(
                                                        context: context,
                                                        url: SocialCubit.get(
                                                                context)
                                                            .allUsers
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .uId ==
                                                                    comments[
                                                                            index]
                                                                        .uId)
                                                            .image,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      comments[index].comment,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          if (comments.isEmpty)
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    size: 50,
                                    IconBroken.Paper_Fail,
                                  ),
                                  Text('No comments yet')
                                ],
                              ),
                            ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TextFormField(
                              autofocus: commentFocus ?? false,
                              maxLines: 5,
                              minLines: 1,
                              controller: commentController,
                              onChanged: (value) {
                                SocialCubit.get(context).commentFullChange(
                                  value: value,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'What is on your mind',
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    DateTime date = DateTime.now();

                                    if (SocialCubit.get(context).commentFull) {
                                      SocialCubit.get(context).commentOnPost(
                                        postId,
                                        commentController.text,
                                        date.toIso8601String(),
                                      );
                                      commentController.clear();
                                      SocialCubit.get(context)
                                          .commentFullChange(
                                        value: '',
                                      );
                                    }
                                  },
                                  color: SocialCubit.get(context).commentFull
                                      ? Colors.blue
                                      : null,
                                  icon: const Icon(
                                    IconBroken.Send,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      size: 50,
                      IconBroken.Paper_Fail,
                    ),
                    Text('No comments yet')
                  ],
                ),
              );
            }
          });
    },
  );
}
