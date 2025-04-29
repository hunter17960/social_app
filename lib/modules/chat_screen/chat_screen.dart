import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/chat_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatScreen extends StatelessWidget {
  final UserModel model;
  final TextEditingController chatController = TextEditingController();
  ChatScreen({required this.model, super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              children: [
                CircleAvatar(
                  maxRadius: MediaQuery.of(context).size.height / 38,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: buildCachedNetworkImage(
                      context: context,
                      url: model.image,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  model.name,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(cubit.currentUserModel!.uId)
                          .collection('chats')
                          .doc(model.uId)
                          .collection('messages')
                          .orderBy('dateTime')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<MessageModel> messages = [];
                          List<String> messagesIds = [];
                          for (var element in snapshot.data!.docs) {
                            messages.add(MessageModel.fromJson(element.data()));
                            messagesIds.add(element.id);
                          }
                          return ConditionalBuilder(
                            condition: messages.isNotEmpty,
                            fallback: (context) {
                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      size: 50,
                                      IconBroken.Message,
                                    ),
                                    Text(
                                      'No messages Yet',
                                    ),
                                  ],
                                ),
                              );
                            },
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    messages.length,
                                    (index) => message(
                                      context: context,
                                      message: messages[index],
                                      messageId: messagesIds[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 50,
                                  IconBroken.Message,
                                ),
                                Text('Loading')
                              ],
                            ),
                          );
                        }
                      }),
                ),
                TextFormField(
                  maxLines: 5,
                  minLines: 1,
                  controller: chatController,
                  onChanged: (value) {
                    SocialCubit.get(context).chatFullChange(
                      value: value,
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        onPressed: () {
                          DateTime date = DateTime.now();
                          if (cubit.chatFull) {
                            cubit.sendMessage(
                              dateTime: date.toIso8601String(),
                              message: chatController.text,
                              senderUId: uId,
                              receiverUId: model.uId,
                            );
                            chatController.clear();
                            SocialCubit.get(context).chatFullChange(
                              value: '',
                            );
                          }
                        },
                        color: cubit.chatFull ? Colors.blue : null,
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
        );
      },
    );
  }
}

Widget message({
  required BuildContext context,
  required MessageModel message,
  required String messageId,
}) {
  return Align(
    alignment:
        message.senderId == SocialCubit.get(context).currentUserModel!.uId
            ? Alignment.topRight
            : Alignment.topLeft,
    child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Time"),
              content: Text(DateFormat.yMd()
                  .add_jm()
                  .format(DateTime.parse(message.dateTime))),
              actions: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController newMessageController =
                            TextEditingController();
                        newMessageController.text = message.message;
                        return AlertDialog(
                          title: const Text('New Message'),
                          content: TextFormField(
                            maxLines: 5,
                            minLines: 1,
                            controller: newMessageController,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (newMessageController.text.isNotEmpty) {
                                  // SocialCubit.get(context).editMessage(
                                  //   docId: messageId,
                                  //   newMessage: newMessageController.text,
                                  //   senderUId: message.senderId,
                                  //   receiverUId: message.receiverId,
                                  // );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Done'),
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
                          title: const Text('Delete'),
                          content: const Text(
                              'Are you sure You want to delete this message'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                                SocialCubit.get(context).deleteMessage(
                                  docId: messageId,
                                  senderUId: message.senderId,
                                  receiverUId: message.receiverId,
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sure',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
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
      },
      child: Card(
        color:
            message.senderId == SocialCubit.get(context).currentUserModel!.uId
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).dividerColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  message.message,
                ),
              ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   DateFormat.yMd()
              //       .add_jm()
              //       .format(DateTime.parse(message.dateTime)),
              //   style: TextStyle(
              //     color: Theme.of(context).dividerColor,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ),
  );
}
