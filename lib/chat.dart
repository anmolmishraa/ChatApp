import 'package:chatapp/chat_controller.dart';
import 'package:chatapp/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class Chat extends StatefulWidget {
  const  Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Color g=Colors.greenAccent;
  Color w=Colors.white;
  TextEditingController msgTextcontroller =TextEditingController();
  late IO.Socket socket;
  ChatController chatcontroller =ChatController();
 @override
  void initState() {
   socket = IO.io('https://nodejs-posgresql.onrender.com',IO.OptionBuilder()
       .setTransports(['websocket'])
       .disableAutoConnect()
       .build());
   socket.connect();
   setUpSocketlistener();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(child: Obx(
           ()=> Container(
                child: Text( "connected user ${chatcontroller.userscount}",style: TextStyle(color: Colors.white),)

              ),
            )),
            Expanded(flex: 8,
                child: Obx(
              
                    ()=> ListView.builder(
              itemCount: chatcontroller.chatMessages.length
              ,itemBuilder: (context,index){
var currentItems=chatcontroller.chatMessages[index];
                return MessageItem(
                    sendbyMe:currentItems.sentByme==socket.id,
                  message: currentItems.message,

                );
              }),
            )),
            Expanded(flex: 1,child: Container(

              padding: EdgeInsets.all(10),
              // color: Colors.red,

              child: TextField(
                maxLines: 25,
                textInputAction: TextInputAction.send,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.tealAccent,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 15,bottom: 10,right: 15,left: 15),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                  suffixIcon: Container(
                    child: IconButton(
                      onPressed: (){
                        sendMessage(msgTextcontroller.text);

                         msgTextcontroller.clear();
                      },
                      icon: Icon(Icons.send,color: Colors.white,),
                    ),
                  )

                ),
                controller: msgTextcontroller,
              ),
            )),

          ],
        ),
      ),
    );
  }
void sendMessage(String text){

   var messageJson={
     "message":text,
     "sendbyMe":socket.id

   };
   socket.emit("message",messageJson);
   chatcontroller.chatMessages.add(Message.fromJson(messageJson));
}
void setUpSocketlistener(){
   socket.on("message--receive", (data) => {

chatcontroller.chatMessages.add(Message.fromJson(data)),



   });
   socket.on("users-count", (data) => {

     chatcontroller.userscount.value=data,



   });
}
}
class MessageItem extends StatelessWidget {
 MessageItem({Key? key,required this.sendbyMe,required this.message}) : super(key: key);
final bool sendbyMe;
final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:sendbyMe?Alignment.centerLeft:Alignment.centerRight ,
      child: Container(

        decoration: BoxDecoration(
            color:sendbyMe?Colors.teal:Colors.orange,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),topRight:  Radius.circular(10), )
        ),
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        margin: EdgeInsets.symmetric(
          vertical: 8,horizontal: 15
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(message.toString(),style: TextStyle(fontStyle: FontStyle.italic,fontSize: 15),),
            // Text("1.10 AM"),
          ],
        ),

      ),
    );
  }
}


