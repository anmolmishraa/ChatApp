class Message{
  String message;
  String sentByme;

  Message({required this.message,required this.sentByme});
  factory Message.fromJson(Map<String,dynamic> json){

    return Message(message: json["message"],sentByme:json["sendbyMe"]);

  }

}