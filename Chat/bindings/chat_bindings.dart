import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ChatController());
  }
}
