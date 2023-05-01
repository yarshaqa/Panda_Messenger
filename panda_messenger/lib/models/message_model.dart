class MessageModel {
  String? message;
  String? time;
  String? senderName;
  String? chatId;
  String? messageId;

  MessageModel(
      {this.message,
        this.time,
        this.senderName,
        this.chatId,
        this.messageId});

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    time = json['time'];
    senderName = json['senderName'];
    chatId = json['chatId'];
    messageId = json['messageId'];
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'time': time,
    'senderName': senderName,
    'chatId': chatId,
    'messageId': messageId,
  };
}
