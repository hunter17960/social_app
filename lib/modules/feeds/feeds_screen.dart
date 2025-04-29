import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getPosts();
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);
          return ConditionalBuilder(
            condition: cubit.currentUserModel != null &&
                cubit.posts.isNotEmpty &&
                cubit.postIds.isNotEmpty,
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            builder: (context) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: List.generate(
                    cubit.posts.length,
                    (index) => buildPostItem(
                      context,
                      cubit.posts[index],
                      cubit.postIds[index],
                      index,
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }
}

Widget buildPostItem(
  BuildContext context,
  PostModel model,
  String postId,
  int index,
) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: MediaQuery.of(context).size.height / 25,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: buildCachedNetworkImage(
                    context: context,
                    url: SocialCubit.get(context)
                        .allUsers
                        .firstWhere((element) => element.uId == model.uId)
                        .image,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.name,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        size: 16,
                        Icons.check_circle_rounded,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  Text(
                    DateFormat.yMMMMd()
                        .add_jm()
                        .format(DateTime.parse(model.dateTime)),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(IconBroken.Edit),
                                  Text('  Edit Post')
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Post"),
                                    content: const Text(
                                        "Are you sure you want to permanently remove this post?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .unselectedWidgetColor,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          SocialCubit.get(context)
                                              .deletePost(postId: postId);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Theme.of(context)
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
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(IconBroken.Delete),
                                  Text('  Delete Post')
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.more_horiz_rounded,
                ),
              ),
            ],
          ),
          //?              divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Text(
            '  ${model.text}',
          ),
          const SizedBox(
            height: 10,
          ),
          //?              HashTags
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
              top: 5.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                children: List.generate(
                  27,
                  (index) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 3),
                      child: InkWell(
                        splashFactory: InkSplash.splashFactory,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                        onTap: () {
                          print('HashTag');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Text(
                            '#HashTag',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.blue,
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
          //? The Post Photo
          if (model.postImage != null)
            Card(
              child: buildCachedNetworkImage(
                url: model.postImage!,
                context: context,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3.5,
              ),
            ),
          //?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                splashFactory: InkSplash.splashFactory,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        IconBroken.Heart,
                        color: Theme.of(context).primaryColor,
                        size: MediaQuery.of(context).size.height / 40,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('likes')
                            .where('like', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int likes = snapshot.data?.docs.length ?? 0;
                          return Text(
                            '$likes',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                splashFactory: InkSplash.splashFactory,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
                onTap: () {
                  TextEditingController commentController =
                      TextEditingController();
                  commentsBottomSheet(
                    context: context,
                    postId: postId,
                    commentController: commentController,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        IconBroken.Chat,
                        size: MediaQuery.of(context).size.height / 40,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('comment')
                            .snapshots(),
                        builder: (context, snapshot) {
                          int comments = snapshot.data?.docs.length ?? 0;
                          return Text(
                            '$comments',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //?              divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                maxRadius: MediaQuery.of(context).size.height / 35,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: buildCachedNetworkImage(
                    context: context,
                    url: SocialCubit.get(context).currentUserModel!.image,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        splashFactory: InkSplash.splashFactory,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                        onTap: () {
                          TextEditingController commentController =
                              TextEditingController();
                          commentsBottomSheet(
                            context: context,
                            postId: postId,
                            commentController: commentController,
                            commentFocus: true,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Write a comment ...',
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('likes')
                            .doc(SocialCubit.get(context).currentUserModel!.uId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic>? data =
                                snapshot.data?.data() as Map<String, dynamic>?;

                            bool liked = (data ?? const {})['like'] ?? false;
                            return InkWell(
                              splashFactory: InkSplash.splashFactory,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                              onTap: () {
                                if (liked) {
                                  SocialCubit.get(context).unLikesPost(postId);
                                } else {
                                  SocialCubit.get(context).likePost(postId);
                                }
                                // SocialCubit.get(context).likePost(postId);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      color: liked
                                          ? Colors.red
                                          : Theme.of(context)
                                              .unselectedWidgetColor,
                                      IconBroken.Heart,
                                    ),
                                    const Text(' Like')
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return InkWell(
                              splashFactory: InkSplash.splashFactory,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                              onTap: () {
                                // if (SocialCubit.get(context).postLikes[index] == 1) {
                                //   SocialCubit.get(context).unLikesPost(postId);
                                //   print('unlike');
                                // } else {
                                //   SocialCubit.get(context).likePost(postId);
                                //   print('like');
                                // }
                                SocialCubit.get(context).likePost(postId);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      color: Theme.of(context)
                                          .unselectedWidgetColor,
                                      // color: Theme.of(context).unselectedWidgetColor,
                                      IconBroken.Heart,
                                    ),
                                    const Text(' Like')
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
