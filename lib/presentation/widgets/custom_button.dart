import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gig_worker_task_manager/presentation/pages/task_list_page.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignUp;
  final AuthRepository authRepository = AuthRepositoryImpl();

  CustomButton({
    super.key,
    required this.text,
    required this.emailController,
    required this.passwordController,
    this.isSignUp = false,
  });

  void _handleAuth(BuildContext context) async {
    try {
      User? user;
      if (isSignUp) {
        user = await authRepository.signUp(
            emailController.text, passwordController.text, context);
      } else {
        user = await authRepository.signIn(
            emailController.text, passwordController.text, context);
      }

      if (user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const TaskListScreen(),
          ),
          (route) => false,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$text Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _handleAuth(context);
          emailController.clear();
          passwordController.clear();
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
