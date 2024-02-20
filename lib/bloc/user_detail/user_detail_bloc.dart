import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_chat/data/data.dart';
import 'package:equatable/equatable.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final String _collectionMembers = 'members';

  final FirebaseFirestore _firebaseFirestore;

  UserDetailBloc({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        super(UserDetailInitial()) {
    on<LoadUserDetailEvent>((event, emit) async {
      await emit.forEach(
        _firebaseFirestore
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
