import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:todo_app_crud/constants/routes.dart';
import 'package:todo_app_crud/utils/create_new_task_dialog.dart';
import 'package:todo_app_crud/views/login_view.dart';
import 'package:todo_app_crud/views/register_view.dart';
import 'package:todo_app_crud/views/todolist/todo_view.dart';
import 'package:todo_app_crud/views/verify_email_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        toDoRoute: (context) => const ToDoView(),
        verifyEmailRoute: (context)=> const VerifyEmailView(),
        createNewTaskRoute: (context)=> const CreateNewTaskDialog(),
      },
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if(user!=null){
              if(user.emailVerified){
                return const ToDoView();
              }else{
                return const VerifyEmailView();
              }
            }else{
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
