import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_crud/constants/routes.dart';
import 'package:todo_app_crud/utils/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _password,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            obscureText: true,
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;
                User? user = FirebaseAuth.instance.currentUser;
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (user != null) {
                  await user.reload();
                  user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      toDoRoute,
                      (route) => false,
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  if (!context.mounted) return;
                  showErrorDialog(
                    context,
                    'Wrong Email or Password',
                  );
                } else if (e.code == 'invalid-email') {
                  if (!context.mounted) return;
                  showErrorDialog(
                    context,
                    'Invalid Email',
                  );
                } else {
                  if (!context.mounted) return;
                  showErrorDialog(
                    context,
                    'Authentication Error',
                  );
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not Registered? Register Here!!'),
          )
        ],
      ),
    );
  }
}
