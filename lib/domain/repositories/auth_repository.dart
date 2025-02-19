import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password, BuildContext context);
  Future<User?> signUp(String email, String password, BuildContext context);
  Future<void> signOut();
}
