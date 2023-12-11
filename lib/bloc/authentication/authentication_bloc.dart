import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_chat/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final String _defaultDisplayName = 'Unknown';

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<ValidateAuthenticationEvent>((event, emit) async {
      await emit.forEach(
        FirebaseAuth.instance.authStateChanges(),
        onData: (user) {
          if (user == null) {
            return Unauthenticated();
          }

          return Authenticated(user);
        },
      );
    });

    on<SignInWithGoogleEvent>((event, emit) async {
      signInWithGoogle();
    });

    on<RequestSignOutEvent>((event, emit) async {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    });
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: ['email', 'profile']);
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } on PlatformException catch (e) {
      return null;
    }

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(oAuthCredential);
      final User? user = userCredential.user;

      if (user == null) {
        return null;
      }

      // save user detail
      FirebaseFirestore.instance.collection('members').doc(user.uid).set(
          UserDetail(
                  uid: user.uid,
                  displayName: user.displayName ?? _defaultDisplayName,
                  avatar: user.photoURL)
              .toMap());

      return user;
    } on FirebaseAuthException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
