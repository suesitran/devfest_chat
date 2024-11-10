import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
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

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationBloc(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        super(AuthenticationInitial()) {
    on<ValidateAuthenticationEvent>((event, emit) async {
      await emit.forEach(
        _firebaseAuth.authStateChanges(),
        onData: (user) {
          if (user == null) {
            return const Unauthenticated();
          }

          return Authenticated(user);
        },
      );
    });

    on<SignInWithGoogleEvent>((event, emit) async {
      try {
        await signInWithGoogle();
      } on PlatformException catch (e) {
        emit(AuthenticationError(e.toString()));
      } on FirebaseAuthException catch (e) {
        emit(AuthenticationError(e.toString()));
      } catch (e) {
        emit(AuthenticationError(e.toString()));
      }
    });

    on<RequestSignOutEvent>((event, emit) async {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    });
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: ['email', 'profile']);
    GoogleSignInAccount? googleUser;
    googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('User cancel');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(oAuthCredential);
    final User? user = userCredential.user;

    if (user == null) {
      throw Exception('Failed to validate with Firebase Auth');
    }

    // save user detail
    _firebaseFirestore.collection('members').doc(user.uid).set(UserDetail(
            uid: user.uid,
            displayName: user.displayName ?? _defaultDisplayName,
            avatar: user.photoURL)
        .toMap());

    return user;
  }
}
