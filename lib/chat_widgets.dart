import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_chat/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Chat bubble to display sent messages
class ChatBubble extends StatelessWidget {
  final String text;
  final String senderUid;
  final bool isMine;

  const ChatBubble(
      {required this.text,
      required this.senderUid,
      required this.isMine,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('members')
            .doc(senderUid)
            .snapshots(),
        builder: (context, snapshot) => UserAvatarView(
          avatar: snapshot.data?['avatar'],
          size: 20,
        ),
      ),
      SizedBox(
        width: 4,
      ),
      Flexible(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color:
                  isMine ? const Color(0xFF7A8194) : const Color(0xFF373E4E)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            text,
            style: TextStyle(color: isMine ? null : Colors.white),
          ),
        ),
      ),
      SizedBox(
        width: 50,
      )
    ];

    if (isMine) {
      children = children.reversed.toList();
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// TextField with Send button to send message
class MessageBoxView extends StatefulWidget {
  final ValueChanged<Message> onSend;
  const MessageBoxView({required this.onSend, Key? key}) : super(key: key);

  @override
  State<MessageBoxView> createState() => _MessageBoxViewState();
}

class _MessageBoxViewState extends State<MessageBoxView> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) => TextField(
        controller: _editingController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: 'Message',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
            border: inputBorder,
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            fillColor: const Color(0xFF3D4354),
            prefixIcon: const CircleAvatar(
              radius: 15,
              backgroundColor: const Color(0xFF9398A7),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 15,),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 50,
            ),
            suffixIcon: InkWell(
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFF9398A7),
                child: Icon(Icons.send, color: Colors.white, size: 15,),
              ),
              onTap: () {
                final String? uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  widget.onSend(Message(
                      time: DateTime.now().toUtc(),
                      senderUid: uid,
                      message: _editingController.text));
                  _editingController.text = '';
                }
              },
            ),
            suffixIconConstraints: BoxConstraints(minWidth: 50)),
      );

  InputBorder get inputBorder =>
      FilledInputBorder(borderRadius: BorderRadius.circular(25.0));
}

class FilledInputBorder extends InputBorder {
  final BorderSide side;
  final TextDirection? textDirection;
  final BorderRadius borderRadius;

  final Paint _paint = Paint()
    ..color = const Color(0xFF3D4354)
    ..style = PaintingStyle.fill;

  FilledInputBorder(
      {this.side = BorderSide.none,
      this.textDirection,
      this.borderRadius = BorderRadius.zero});

  @override
  InputBorder copyWith(
          {BorderSide? borderSide, TextDirection? textDirection}) =>
      FilledInputBorder(
          side: borderSide ?? side,
          textDirection: textDirection ?? this.textDirection);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(max(side.strokeInset, 0));

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  bool get isOutline => false;

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection? textDirection}) {
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), _paint);
  }

  @override
  ShapeBorder scale(double t) {
    return OutlineInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }
}

/// Friend item, with user avatar and display name
class FriendItemView extends StatelessWidget {
  final UserDetail user;

  const FriendItemView({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (user.avatar != null) UserAvatarView(avatar: user.avatar),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(user.displayName),
          ),
        ],
      ),
    );
  }
}

/// Circle avatar which conveniently load user photo from url
class UserAvatarView extends StatelessWidget {
  final String? avatar;
  final double size;

  const UserAvatarView({required this.avatar, this.size = 30, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatar == null) {
      return Icon(Icons.question_mark, size: size,);
    }

    return CircleAvatar(
      backgroundImage: _getImageProvider(avatar!),
      radius: size,
    );
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    }

    return AssetImage(path);
  }
}

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