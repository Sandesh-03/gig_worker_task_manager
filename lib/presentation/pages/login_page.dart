import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gig_worker_task_manager/presentation/pages/signup_page.dart';

import '../constants/constant.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/log_in_options.dart';
import '../widgets/right_logo.dart';

class LoginPage extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 100, right: 0, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const RightLogo(),
            const Text(
              'Welcome back!',
              style: kTitleTextStyle,
            ),
            CustomTextField(
              controller: _emailController,
              lableText: 'Email',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              isPassword: true,
              lableText: 'Password',
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Login',
              emailController: _emailController,
              passwordController: _passwordController,
            ),
            const SizedBox(height: 30),
            const Text('or Sign in with'),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogInOption(
                  method: 'facebook',
                ),
                LogInOption(
                  method: 'google',
                ),
                LogInOption(
                  method: 'apple',
                ),
              ],
            ),
            // const SizedBox(height: 30),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text('Don\'t have an account? Get started!'),
            ),
          ],
        ),
      ),
    );
  }
}
