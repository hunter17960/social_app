// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login/log_in_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/theme.dart';
import 'firebase_options.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool storedBool = await CacheHelper.getData(key: 'isDark') ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate();

  uId = await CacheHelper.getData(key: 'uId') ?? '';
  print(uId);
  Widget startWidget;

  if (uId.isNotEmpty) {
    startWidget = const SocialLayout();
  } else {
    startWidget = LoginScreen();
  }

  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(
      startWidget: startWidget,
      storedBool: storedBool,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final bool storedBool;
  const MyApp({required this.startWidget, required this.storedBool, super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
        ..getUsers()
        ..toggleTheme(storedBool: storedBool),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: tempLightTheme(cubit.currentFlexScheme),
            darkTheme: tempDarkTheme(cubit.currentFlexScheme),
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
