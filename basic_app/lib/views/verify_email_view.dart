import 'package:basic_app/constant/routes.dart';
import 'package:basic_app/services/auth/auth_exceptions.dart';
import 'package:basic_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've already sent an email for verification. Please open it to Verify your email."),
          const Text(
              "If you haven't received an email yet please press the button below"),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              } on UserNotLoggedInAuthException {
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  loginRoute,
                      (route) => false,
                );
              }
            },
            child: const Text('Verify Email'),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance;
              try {
                await user.signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                      (route) => false,
                );
              }catch(_) {
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                      (route) => false,
                );
              }
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
