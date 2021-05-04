import 'package:covibot/getX/controllers/chat_suggestions_controller.dart';
import 'package:get/get.dart';

class ChatbotPageBindings extends Bindings {

  @override
  void dependencies() {
    Get.put<ChatSuggestionsController>(ChatSuggestionsController());
  }

}