import 'package:basic_app/services/crud/notes_service.dart';
import 'package:basic_app/utilities/generics/get_arguments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    final text = _textController.text;
    if (note != null) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {

    final widgetNote = context.getArgument<DatabaseNote>();

    if(widgetNote!=null){
      _note=widgetNote;
      _textController.text=widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = FirebaseAuth.instance.currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.fetchUser(email: email);
    print(owner.email);
    final newNote =  await _notesService.createNote(owner: owner);
    print(newNote.id);
    _note=newNote;
    return newNote;
  }

  void deleteNoteIfEmpty() {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isEmpty) {
      _notesService.deleteNote(noteId: note.id);
    }
  }

  void saveNoteIfNotEmpty() {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    deleteNoteIfEmpty();
    saveNoteIfNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Type your note here...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
