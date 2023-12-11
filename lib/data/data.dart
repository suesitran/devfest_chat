import 'package:cloud_firestore/cloud_firestore.dart';

/// data classes
class Message {
  final String id;
  final DateTime time;
  final String senderUid;
  final String message;

  Message({required this.time, required this.senderUid, required this.message})
      : id = '';

  Message.fromMap(this.id, Map<String, dynamic> map)
      : time = (map['time'] as Timestamp).toDate(),
        senderUid = map['from'],
        message = map['message'];

  Map<String, dynamic> toMap() =>
      {'time': Timestamp.fromDate(time), 'from': senderUid, 'message': message};
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

  Map<String, dynamic> toMap() => {
    'uid' : uid,
    'displayName':displayName,
    'avatar': avatar
  };
}