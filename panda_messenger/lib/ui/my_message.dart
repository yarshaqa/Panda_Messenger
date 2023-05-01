import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panda_messenger/user_repository.dart';

import '../models/message_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.messageModel});

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        const SizedBox(width: 10),
        messagePositioned(context)
      ],
    );
  }

  Widget messagePositioned(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
        color: messageModel.senderName ==
                UserRepository.userRepository.loggedUser.email
            ? Colors.deepPurple
            : Colors.grey,
      ),
      width: MediaQuery.of(context).size.width - 30,
      child: Stack(
        children: [ Positioned(
          top: 1,
          child: Text(' ${messageModel.senderName}',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
          Positioned(
            top: 20,
            child: Text(
              ' ${messageModel.message}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              maxLines: 20,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 1,
            child: Text(
                'Posted on ${DateFormat('MMMM, d, yyyy').format(DateTime.parse(messageModel.time!))}',
                style: const TextStyle(color: Colors.black54)),
          )
        ],
      ),
    );
  }
}
