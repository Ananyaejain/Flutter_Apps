import 'package:basic_app/constant/routes.dart';
import 'package:basic_app/services/auth/auth_service.dart';
import 'package:basic_app/views/login_view.dart';
import 'package:basic_app/views/notes/create_update_notes_view.dart';
import 'package:basic_app/views/notes/notes_view.dart';
import 'package:basic_app/views/register_view.dart';
import 'package:basic_app/views/verify_email_view.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

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
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       ),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = FirebaseAuth.instance.currentUser;
//             //devtools.log(currUser?.emailVerified.toString()??null.toString());
//             if (user != null) {
//               if (user.emailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing Bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalid) ? state.invalidValue : '';
            return Column(
              children: [
                Text('Current Value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalid,
                  child: Text('Invalid Input: $invalidValue'),
                ),
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter a number here',
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_textEditingController.text));
                      },
                      child: const Icon(Icons.add),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_textEditingController.text));
                      },
                      child: const Icon(Icons.minimize),
                    )
                  ],
                )
              ],
            );
          },
          listener: (context, state) {
            _textEditingController.clear();
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;

  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(
            CounterStateInvalid(
              invalidValue: event.value,
              previousValue: state.value,
            ),
          );
        } else {
          emit(CounterStateValid(state.value + integer));
        }
      },
    );
    on<DecrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(
            CounterStateInvalid(
              invalidValue: event.value,
              previousValue: state.value,
            ),
          );
        } else {
          emit(CounterStateValid(state.value - integer));
        }
      },
    );
  }
}
