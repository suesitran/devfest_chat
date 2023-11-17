import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogle {
  final String defaultDisplayName = 'Unknown';
  Future<User?> signIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile']
    );
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
                  displayName: user.displayName ?? defaultDisplayName,
                  avatar: user.photoURL)
              .toMap());

      return user;
    } on FirebaseAuthException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

class UserDetail {
  final String uid;
  final String displayName;
  final String? avatar;

  UserDetail({required this.uid, required this.displayName, this.avatar});

  UserDetail.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        displayName = map['displayName'],
        avatar = map['avatar'];

  Map<String, dynamic> toMap() =>
      {'uid': uid, 'displayName': displayName, 'avatar': avatar};

  // mocking purpose
  UserDetail.fromAsset(String asset)
      : uid = 'uid',
        displayName = asset.split('/').last.split('.').first,
        avatar = asset;
}