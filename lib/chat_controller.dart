import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'message.dart';
class ChatController extends GetxController{

  var chatMessages =<Message>[].obs;
  var userscount =0.obs;
}