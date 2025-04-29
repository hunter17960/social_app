import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          SocialCubit.get(context).getUserData();
          Navigator.pop(context);
          SocialCubit.get(context).profileImage = null;
          SocialCubit.get(context).coverImage = null;
          SocialCubit.get(context).updateUserLoading = false;
        }
        if (state is UpdateCoverImageSuccess) {
          SocialCubit.get(context).coverImage = null;
        }
        if (state is UpdateProfileImageSuccess) {
          SocialCubit.get(context).profileImage = null;
        }
      },
      builder: (context, state) {
        TextEditingController nameController = TextEditingController();
        TextEditingController bioController = TextEditingController();
        TextEditingController phoneController = TextEditingController();
        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        SocialCubit cubit = SocialCubit.get(context);
        if (cubit.currentUserModel != null) {
          nameController.text = cubit.currentUserModel!.name;
          bioController.text = cubit.currentUserModel!.bio;
          phoneController.text = cubit.currentUserModel!.phone;
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            if (cubit.profileImage != null || cubit.coverImage != null) {
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
                          cubit.profileImage = null;
                          cubit.coverImage = null;
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
              title: const Text('Edit Profile'),
              leading: IconButton(
                onPressed: () {
                  if (cubit.profileImage != null || cubit.coverImage != null) {
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
                                cubit.profileImage = null;
                                cubit.coverImage = null;
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
                      cubit.updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                      );
                    }
                  },
                  child: Text(
                    'Update',
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
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (cubit.updateUserLoading)
                        const LinearProgressIndicator(),
                      if (cubit.updateUserLoading) const SizedBox(height: 10.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2.7,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Card(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: cubit.coverImage == null
                                        ? buildCachedNetworkImage(
                                            url: cubit
                                                .currentUserModel!.coverImage,
                                            context: context,
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                          )
                                        : Image(
                                            image: FileImage(cubit.coverImage!),
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cubit.getCoverImage();
                                    },
                                    splashColor: Colors.transparent,
                                    color: Colors.transparent,
                                    icon: const CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  maxRadius:
                                      MediaQuery.of(context).size.height / 8,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: ClipOval(
                                    child: cubit.profileImage == null
                                        ? buildCachedNetworkImage(
                                            context: context,
                                            url: cubit.currentUserModel!.image,
                                            height: 175,
                                            width: 175,
                                          )
                                        : Image(
                                            image:
                                                FileImage(cubit.profileImage!),
                                          ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                  splashColor: Colors.transparent,
                                  color: Colors.transparent,
                                  icon: const CircleAvatar(
                                    radius: 20,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (cubit.profileImage != null ||
                          cubit.coverImage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    if (state is UploadProfileImageLoading ||
                                        state is UploadCoverImageLoading)
                                      const LinearProgressIndicator(),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          cubit.updateImages();
                                        },
                                        child: const Text('Upload Images'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      defaultFormField(
                        controller: nameController,
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name must not be empty';
                          }
                          return null;
                        },
                        label: 'UserName',
                        prefix: IconBroken.User,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: bioController,
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bio must not be empty';
                          }
                          return null;
                        },
                        label: 'Bio',
                        prefix: IconBroken.Info_Square,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        type: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone must not be empty';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call,
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
