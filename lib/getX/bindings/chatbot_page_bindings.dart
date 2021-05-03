import 'package:covibot/getX/controllers/suggestions_controller.dart';
import 'package:get/get.dart';

class ChatbotPageBindings extends Bindings {

  @override
  void dependencies() {
    Get.put<SuggestionsController>(SuggestionsController());
  }

}