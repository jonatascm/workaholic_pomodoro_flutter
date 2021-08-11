import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:workaholic_pomodoro/models/user_model.dart';
import 'auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState> {
  UserModel? _userModel;
  final googleSignIn = GoogleSignIn();
  final fb = FacebookLogin();

  UserModel? get user => _userModel;

  AuthCubit() : super(AuthInitState());

  Future<void> fetchGoogleSignIn() async {
    final user = await googleSignIn.signIn();
    if (user != null) {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        _userModel = new UserModel(name: userCredential.user!.displayName ?? '', email: userCredential.user?.email ?? '', uuid: userCredential.user!.uid);
      }

      emit(AuthAuthenticatedState());
    } else {
      emit(AuthNotAuthenticatedState());
    }
  }

  Future<void> fetchFacebookLogin() async {
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        if (res.accessToken != null) {
          final FacebookAccessToken accessToken = res.accessToken!;

          final credential = FacebookAuthProvider.credential(
            accessToken.token,
          );
          try {
            final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
            if (userCredential.user != null) {
              _userModel = new UserModel(name: userCredential.user!.displayName ?? '', email: userCredential.user?.email ?? '', uuid: userCredential.user!.uid);
            }
            emit(AuthAuthenticatedState());
          } catch (e) {
            //if firebase_auth/account-exists-with-different-credential
            //then login with gmail
            print(e);
            emit(AuthNotAuthenticatedState());
          }
        }

        //final profile = await fb.getUserProfile();
        //final imageUrl = await fb.getProfileImageUrl(width: 100);
        //final email = await fb.getUserEmail();

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  Future<void> fetchGuestLogin() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      if (userCredential.user != null) {
        _userModel = new UserModel(name: userCredential.user!.displayName ?? '', email: userCredential.user?.email ?? '', uuid: userCredential.user!.uid);
      }
      emit(AuthAuthenticatedState());
    } catch (e) {
      emit(AuthNotAuthenticatedState());
    }
  }

  Future<void> resetPassowrd(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> fetchAutoLogin() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _userModel = new UserModel(name: currentUser.displayName ?? '', email: currentUser.email ?? '', uuid: currentUser.uid);

        emit(AuthAuthenticatedState());
      } else {
        emit(AuthNotAuthenticatedState());
      }
    } catch (e) {
      emit(AuthNotAuthenticatedState());
    }
  }

  Future<void> logout() async {
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }

    if (await fb.isLoggedIn) {
      await fb.logOut();
    }

    await FirebaseAuth.instance.signOut();
    emit(AuthNotAuthenticatedState());
  }
}
