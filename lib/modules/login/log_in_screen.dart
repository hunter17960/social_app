import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/login/cubit/login_cubit_states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final bool isPasswordVisible = true;
  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    final emailController = TextEditingController();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
              SocialCubit.get(context).getUserData();
              navigateAndReplace(context, const SocialLayout());
            });
          }
          if (state is LoginError) {
            showToast(
              message: state.error,
              context: context,
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          LoginCubit loginCubit = LoginCubit.get(context);
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          'Login Now To Chat',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              loginCubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                            return () {};
                          },
                          isPassword: loginCubit.isPassword,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: loginCubit.isPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          suffixPressed: () {
                            loginCubit.toggleIsPassword();
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          // condition: state is! ShopLoginLoading,
                          condition: true,
                          builder: (context) {
                            return defaultButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  loginCubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'LOGIN',
                              width: double.infinity,
                              background: Theme.of(context).colorScheme.primary,
                              onBackground:
                                  Theme.of(context).colorScheme.onPrimary,
                            );
                          },
                          fallback: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                navigateAndReplace(context, RegisterScreen());
                              },
                              child: const Text(
                                'Register now',
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
      ),
    );
  }
}
