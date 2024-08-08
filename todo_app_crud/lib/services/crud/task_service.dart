import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:todo_app_crud/extensions/list/fliter.dart';
import 'package:todo_app_crud/services/exceptions/crud_exceptions.dart';

class TaskService {
  Database? _db;
  List<DatabaseTask> _tasks = [];
  DatabaseUser? _user;

  static final TaskService _shared = TaskService._sharedInstance();

  TaskService._sharedInstance() {
    _tasksStreamController = StreamController<List<DatabaseTask>>.broadcast(
      onListen: () {
        _tasksStreamController.sink.add(_tasks);
      },
    );
  }

  factory TaskService() => _shared;

  late final StreamController<List<DatabaseTask>> _tasksStreamController;

  Stream<List<DatabaseTask>> get allTasks =>
      _tasksStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.uid == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllNotes();
        }
      });

  Future<void> _cacheAllTasks() async {
    final cacheTasks = await fetchAllTasks();
    _tasks = cacheTasks.toList();
    _tasksStreamController.add(_tasks);
  }

  Future<DatabaseUser> createOrGetUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await fetchUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on UserDoesNotExistException {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseTask> checkBoxChanged({required DatabaseTask task}) async{
    await isDbOpen();
    final db = _getDatabaseOrThrow();

    await fetchTask(taskId: task.id);

    final updateCount = await db.update(
      taskTable,
      {
        isCheckedColumn: !task.isChecked,
      },
      where: 'id=?',
      whereArgs: [task.id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateTask();
    } else {
      final updatedTask = await fetchTask(taskId: task.id);
      _tasks.removeWhere((task) => task.id == updatedTask.id);
      _tasks.add(updatedTask);
      _tasksStreamController.add(_tasks);
      return updatedTask;
    }
  }

  Future<DatabaseTask> updateTask({
    required DatabaseTask task,
    required String text,
  }) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();

    await fetchTask(taskId: task.id);

    final updateCount = await db.update(
      taskTable,
      {
        textColumn: text,
      },
      where: 'id=?',
      whereArgs: [task.id],
    );
    if (updateCount == 0) {
      throw CouldNotUpdateTask();
    } else {
      final updatedTask = await fetchTask(taskId: task.id);
      _tasks.removeWhere((task) => task.id == updatedTask.id);
      _tasks.add(updatedTask);
      _tasksStreamController.add(_tasks);
      return updatedTask;
    }
  }

  Future<Iterable<DatabaseTask>> fetchAllTasks() async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(taskTable);
    return results.map((tasksRow) => DatabaseTask.fromRow(tasksRow));
  }

  Future<void> deleteAllTasks() async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final delCount = await db.delete(taskTable);
    if (delCount == 0) {
      throw CouldNotDeleteTask();
    } else {
      _tasks = [];
      _tasksStreamController.add(_tasks);
    }
  }

  Future<DatabaseTask> fetchTask({required int taskId}) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final task = await db.query(
      taskTable,
      where: 'id=?',
      whereArgs: [taskId],
      limit: 1,
    );
    if (task.isEmpty) {
      throw CouldNotFindTask();
    }
    return DatabaseTask.fromRow(task.first);
  }

  Future<void> deleteTask({required int taskId}) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final delCount = await db.delete(
      taskTable,
      where: 'id=?',
      whereArgs: [taskId],
    );
    if (delCount == 0) {
      throw CouldNotDeleteTask();
    } else {
      _tasks.removeWhere((task) => task.id == taskId);
      _tasksStreamController.add(_tasks);
    }
  }

  Future<DatabaseTask> createTask({required DatabaseUser owner}) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await fetchUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }else{
      print('Success');
    }
    const text = '';
    final taskId = await db.insert(
      taskTable,
      {
        uidColumn: owner.id,
        textColumn: text,
        isCheckedColumn: 0,
      },
    );
    final task = DatabaseTask(
      id: taskId,
      text: text,
      uid: owner.id,
      isChecked: false,
    );

    _tasks.add(task);
    _tasksStreamController.add(_tasks);

    return task;
  }

  Future<DatabaseUser> fetchUser({required String email}) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    if (results.isEmpty) {
      throw UserDoesNotExistException();
    }
    return DatabaseUser.fromRow(results.first);
  }

  Future<void> deleteUser({required String email}) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );

    if (results.isEmpty) {
      throw UserDoesNotExistException();
    }
    final delCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (delCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await isDbOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistException();
    }
    final id = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );

    return DatabaseUser(id: id, email: email);
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    }
    await db.close();
    _db = null;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> isDbOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      //create user table
      await db.execute(createUserTable);
      //create tasks table
      await db.execute(createTasksTable);
      await _cacheAllTasks();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    // TODO: implement toString
    return 'User:- ID:$id, Email:$email';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseTask {
  final int id;
  final int uid;
  final String text;
  final bool isChecked;

  DatabaseTask({
    required this.id,
    required this.text,
    required this.uid,
    required this.isChecked,
  });

  DatabaseTask.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        text = map[textColumn] as String,
        uid = map[uidColumn] as int,
        isChecked = (map[isCheckedColumn] as int) == 1 ? true : false;

  @override
  String toString() {
    // TODO: implement toString
    return 'Task:- ID:$id, USER ID:$uid, TEXT:$text, isChecked:$isChecked';
  }

  @override
  bool operator ==(covariant DatabaseTask other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'tasks.db';
const userTable = 'user';
const taskTable = 'tasks';
const idColumn = 'id';
const emailColumn = 'email';
const textColumn = 'text';
const uidColumn = 'uid';
const isCheckedColumn = 'isChecked';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createTasksTable = '''CREATE TABLE IF NOT EXISTS "tasks" (
	"id"	INTEGER NOT NULL,
	"uid"	INTEGER NOT NULL,
	"text"	TEXT,
	"isChecked"	INTEGER DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("uid") REFERENCES "user"("id")
);''';
