import 'package:get/get.dart';

class ChatPageController extends GetxController {
  Rx<bool> shouldShowScrollButtons = false.obs;

  void setShouldShowScrollButtons(bool _shouldShowScrollButtons) {
    shouldShowScrollButtons.value = _shouldShowScrollButtons;
  }
}