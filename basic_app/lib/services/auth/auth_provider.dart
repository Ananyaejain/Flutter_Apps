import 'auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  Future<void> logIn({
    required String email,
    required String password,
  });

  AuthUser? get currentUser;

  Future<void> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}
