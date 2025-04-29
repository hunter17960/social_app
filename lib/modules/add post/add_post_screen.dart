import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is UploadPostImageSuccess) {
          showToast(
            message: 'Done',
            context: context,
            state: ToastStates.success,
          );
        }
        if (state is UploadPostImageError) {
          showToast(
            message: state.error,
            context: context,
            state: ToastStates.error,
          );
        }
        if (state is CreatePostSuccess) {
          Navigator.pop(context);
          textEditingController.text = '';
          SocialCubit.get(context).postImage = null;
          SocialCubit.get(context).postImageUrl = null;
        }
      },
      builder: (context, state) {
        GlobalKey<FormState> formKey = GlobalKey<FormState>();
        SocialCubit cubit = SocialCubit.get(context);
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            if (cubit.postImage != null ||
                cubit.postImageUrl != null ||
                textEditingController.text.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Discard"),
                    content: const Text("Are you Sure you want to Discard?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // cubit.deleteSelectedPostImage();
                          cubit.postImage = null;
                          cubit.postImageUrl = null;
                          textEditingController.clear();
                        },
                        child: const Text(
                          'Discard',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Add Post'),
              leading: IconButton(
                onPressed: () {
                  if (cubit.postImage != null ||
                      cubit.postImageUrl != null ||
                      textEditingController.text.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Discard"),
                          content:
                              const Text("Are you Sure you want to Discard?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).unselectedWidgetColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // cubit.deleteSelectedPostImage();
                                cubit.postImage = null;
                                cubit.postImageUrl = null;
                                textEditingController.clear();
                              },
                              child: const Text(
                                'Discard',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(IconBroken.Arrow___Left_2),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (cubit.postImage != null &&
                          cubit.postImageUrl == null) {
                        showToast(
                          message: 'confirm the image to continue',
                          context: context,
                          state: ToastStates.warning,
                        );
                      } else if (cubit.postImage != null &&
                          cubit.postImageUrl != null) {
                        DateTime date = DateTime.now();
                        cubit.createNewPost(
                          postImage: cubit.postImageUrl,
                          dateTime: date.toIso8601String(),
                          text: textEditingController.text,
                        );
                        print('createNewPost with the image ');
                      } else if (cubit.postImage == null &&
                          cubit.postImageUrl == null) {
                        DateTime date = DateTime.now();
                        String formattedDate = date.toIso8601String();
                        cubit.createNewPost(
                          postImage: cubit.postImageUrl,
                          dateTime: formattedDate,
                          text: textEditingController.text,
                        );
                        print('createNewPost without the image ');
                      }
                    } else {
                      return;
                    }
                  },
                  child: Text(
                    'Post',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is CreatePostLoading)
                        const LinearProgressIndicator(),
                      if (state is CreatePostLoading)
                        const SizedBox(
                          height: 5,
                        ),
                      Row(
                        children: [
                          CircleAvatar(
                            maxRadius: MediaQuery.of(context).size.height / 25,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: buildCachedNetworkImage(
                                context: context,
                                url: cubit.currentUserModel!.image,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            cubit.currentUserModel!.name,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 10,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          hintText: 'What is on your mind',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Post must not be empty';
                          }
                          return null;
                        },
                      ),
                      if (cubit.postImage != null)
                        Stack(
                          children: [
                            Card(
                              child: Image(
                                image: FileImage(cubit.postImage!),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                              ),
                            ),
                            if (cubit.postImageUrl == null)
                              IconButton(
                                  onPressed: () {
                                    cubit.discardPostImageFile();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 20,
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                    ),
                                  ))
                          ],
                        ),
                      if (state is UploadPostImageLoading)
                        const LinearProgressIndicator(),
                      if (state is UploadPostImageLoading)
                        const SizedBox(
                          height: 5,
                        ),
                      Row(
                        children: [
                          if (cubit.postImage == null)
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  cubit.getPostImage();
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      IconBroken.Image,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Add photo')
                                  ],
                                ),
                              ),
                            ),
                          if (cubit.postImage != null &&
                              cubit.postImageUrl == null)
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  cubit.uploadPostImage();
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      IconBroken.Image,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Confirm')
                                  ],
                                ),
                              ),
                            ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                // cubit.emitTest();
                              },
                              child: const Text('# Tags'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
