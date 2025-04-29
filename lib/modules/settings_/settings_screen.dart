import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/login/log_in_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List info = [
          'Posts',
          'Photos',
          'Followers',
          'Following',
        ];
        SocialCubit cubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.currentUserModel != null,
          fallback: (context) => Container(),
          builder: (context) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.7,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            child: buildCachedNetworkImage(
                              url: cubit.currentUserModel!.coverImage,
                              context: context,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 4,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          maxRadius: MediaQuery.of(context).size.height / 8,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: ClipOval(
                            child: buildCachedNetworkImage(
                              context: context,
                              url: cubit.currentUserModel!.image,
                              height: 175,
                              width: 175,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    cubit.currentUserModel!.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    cubit.currentUserModel!.bio,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  cubit.infoStats[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  info[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text(
                            'Add Photos',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          navigateTo(context, const EditProfileScreen());
                        },
                        icon: const Icon(IconBroken.Edit),
                        label: const Text(''),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('LogOut'),
                                  content: const Text(
                                      'Are you sure you want to log out'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        uId = '';
                                        CacheHelper.clearData(key: 'uId');
                                        SocialCubit.get(context)
                                            .currentUserModel = null;
                                        SocialCubit.get(context).users = [];
                                        navigateAndReplace(
                                            context, LoginScreen());
                                      },
                                      child: const Text(
                                        'Yes',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Log Out',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Dark Mode',
                              style: TextStyle(fontSize: 25),
                            ),
                            Switch(
                              value: cubit.isDark,
                              onChanged: (value) {
                                cubit.toggleTheme();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
