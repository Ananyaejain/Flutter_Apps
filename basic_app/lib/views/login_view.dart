import 'package:basic_app/constant/routes.dart';
import 'package:basic_app/services/auth/auth_exceptions.dart';
import 'package:basic_app/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utilities/show_error_dialog.dart';

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
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            obscureText: true,
            enableSuggestions: false,
            keyboardType: TextInputType.text,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final user = FirebaseAuth.instance;
                await user.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // user.currentUser.reload();
                //print(user.currentUser?.emailVerified);
                if (user.currentUser?.emailVerified ?? false) {
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  //await AuthService.firebase().sendEmailVerification();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(verifyRoute);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Invalid username or password',
                  );
                } else if (e.code == 'invalid-email') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Invalid email',
                  );
                } else {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Error: Authentication Error',
                  );
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not Registered?? Register Here!!'),
          )
        ],
      ),
    );
  }
}
