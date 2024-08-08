import 'package:basic_app/constant/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
            autocorrect: false,
          ),
          TextButton(
            //register button
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final user = FirebaseAuth.instance;
                await user.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                await user.currentUser?.sendEmailVerification();
                if (!context.mounted) return;
                Navigator.of(context).pushNamed(verifyRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Email Already in use',
                  );
                } else if (e.code == 'weak-password') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Weak Password',
                  );
                } else if (e.code == 'invalid-email') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Invalid Email',
                  );
                } else {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Error: Authentication Error',
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                await showErrorDialog(
                  context,
                  'Error: Authentication Error',
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Registered Already?? Login Here!!'),
          )
        ],
      ),
    );
  }
}
