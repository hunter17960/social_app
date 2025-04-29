class MessageModel {
  late String dateTime;
  late String message;
  late String senderId;
  late String receiverId;
  MessageModel({
    required this.dateTime,
    required this.message,
    required this.senderId,
    required this.receiverId,
  });

  MessageModel.fromJson(dynamic json) {
    dateTime = json['dateTime'];
    message = json['message'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }
}
