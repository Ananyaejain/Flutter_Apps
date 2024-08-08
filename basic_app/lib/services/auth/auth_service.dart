import 'package:basic_app/services/auth/firebase_auth_provider.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService._firebase(this.provider);

  static final AuthService _instance = AuthService._firebase(FirebaseAuthProvider());

  factory AuthService(){
    return _instance;
  }

  @override
  Future<void> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );


  @override
  Future<void> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;
}
