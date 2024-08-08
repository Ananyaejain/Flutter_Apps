import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_crud/constants/routes.dart';
import 'package:todo_app_crud/utils/error_dialog.dart';

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
                final user = FirebaseAuth.instance;
                await user.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                await user.currentUser?.sendEmailVerification();
                if (!context.mounted) return;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                } else if (e.code == 'invalid-email') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Invalid Email',
                  );
                } else if (e.code == 'weak-password') {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Weak password',
                  );
                } else {
                  if (!context.mounted) return;
                  await showErrorDialog(
                    context,
                    'Authentication Error',
                  );
                }
              } catch (e) {
                if (!context.mounted) return;
                await showErrorDialog(
                  context,
                  'Error Occurred',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Registered already? Login here'),
          )
        ],
      ),
    );
  }
}
