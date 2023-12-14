import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_chat/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final String _collectionMembers = 'members';
  final String _defaultDisplayName = 'Unknown';

  UserDetailBloc() : super(UserDetailInitial()) {
    on<LoadUserDetailEvent>((event, emit) async {
      await emit.forEach(
        FirebaseFirestore.instance
            .collection(_collectionMembers)
            .doc(event.uid)
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  UserDetail.fromMap(snapshot.data() ?? {}),
              toFirestore: (value, options) => value.toMap(),
            )
            .snapshots(includeMetadataChanges: true),
        onData: (data) {
          final UserDetail? userDetail = data.data();

          if (userDetail == null) {
            return LoadUserDetailFailed();
          }

          return UserDetailLoaded(userDetail);
        },
      );
    });
  }
}
