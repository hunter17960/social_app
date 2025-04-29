import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_screen/chat_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);

        return ConditionalBuilder(
          condition: cubit.users.isNotEmpty,
          fallback: (context) => Container(),
          builder: (context) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cubit.users.length,
              itemBuilder: (context, index) =>
                  chatItem(context: context, model: cubit.users[index]),
            );
          },
        );
      },
    );
  }
}

Widget chatItem({
  required BuildContext context,
  required UserModel model,
}) {
  return InkWell(
    onTap: () {
      navigateTo(
          context,
          ChatScreen(
            model: model,
          ));
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: MediaQuery.of(context).size.height / 31,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: buildCachedNetworkImage(
                context: context,
                url: model.image,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  'this is the last message',
                  style:
                      TextStyle(color: Theme.of(context).unselectedWidgetColor),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '2:04 PM',
            style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
          )
        ],
      ),
    ),
  );
}
