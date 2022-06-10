import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_tcc/helpers/firebase_errors.dart';
import 'package:app_tcc/models/user_app.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  UserApp? user;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _initLoading = false;
  bool get initLoading => _initLoading;

  set initLoading(bool value) {
    _initLoading = value;
    notifyListeners();
  }

  ///Sign In function
  Future<void> signIn(
      {required UserApp userApp, Function? onFail, Function? onSuccess}) async {
    loading = true;

    try {
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: userApp.email!, password: userApp.password!)
          .timeout(const Duration(seconds: 10));

      await _loadCurrentUser(firebaseUser: userCredential.user);

      onSuccess!();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  ///Sign UP function
  Future<void> signUp(
      {required UserApp userApp, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userApp.email!, password: userApp.password!);

      userApp.id = userCredential.user!.uid;
      this.user = userApp;

      await userApp.saveData();

      onSuccess!();
    } on FirebaseAuthException catch (e) {
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  ///Sign Out function
  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  ///Forgot password function
  Future<void> recoverPass(
      {Function? onFail, Function? onSuccess, required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      onSuccess!();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      onFail!(getErrorString(e.code));
    }
  }

  ///Function responsible for identifying and instantiating the current user
  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    initLoading = true;
    /*Deprecated FirebaseUser user*/
    final User? currentUserApp = firebaseUser ?? await auth.currentUser;
    if (currentUserApp != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentUserApp.uid).get();

      this.user = UserApp.fromDocument(docUser);

      print(this.user!.name);
      notifyListeners();
    }
    initLoading = false;
  }
}
