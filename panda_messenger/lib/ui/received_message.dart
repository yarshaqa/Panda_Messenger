import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/message_model.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    super.key,
    required this.messageModel,
    required this.time,
  });

  final MessageModel messageModel;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topStart, children: [
      Positioned(
        left: 55,
        child: Row(
          children: [
            Text('${messageModel.senderName} '),
            Text(DateFormat.jm().format((DateTime.parse(messageModel.time!))),
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(top: 35, left: 55),
          child: messagePositioned(context))
    ]);
  }

  Widget messagePositioned(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 150,
      child: Text(
        maxLines: 20,
        ' ${messageModel.message}',
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
