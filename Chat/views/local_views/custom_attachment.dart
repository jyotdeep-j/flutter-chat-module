import 'package:lottie/lottie.dart';
import 'package:singles_connect/app/modules/chat/controller/chat_controller.dart';

import '../../../../common/export.dart';
import '../../../../data/models/chat_all_model.dart';

class CustomAttachMentView extends GetView<ChatController> {
  UserChatModel? userChatModel;

  CustomAttachMentView({this.userChatModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: itemView(
                onTab: () {
                  controller.superController.hideTooltip();
                  controller.selectImageFromGallery(userChatModel);
                },
                imageUrl: Assets.attachGallery,
                title: Strings.galleryAttach)),
        Expanded(
            child: itemView(
                onTab: () {
                  controller.superController.hideTooltip();
                  controller.selectFilesFromGallery(userChatModel);
                },
                imageUrl: Assets.attachDocument,
                title: Strings.docsAttach)),
        Expanded(child: Obx(
          () {
            return itemView(
                onLongPress: () {
                  // controller.   isLongPress.value=true;
                  controller.startRecording();
                  //   controller.superController.hideTooltip();
                },
                onLongPressEnd: () {
                  //controller.   isLongPress.value=true;
                  controller.stopRecording(userChatModel);
                  print("end");
                },
                onTab: () {
                  controller.requestAudioPermission();
                },
                isLottieFiles:
                    controller.isLongPress.value == false ? false : true,
                imageUrl: controller.isLongPress.value == false
                    ? Assets.attachAudio
                    : Assets.attachAudioRecorded,
                title: Strings.audioAttach);
          },
        )),
      ],
    );
  }

  itemView(
      {imageUrl,
      title,
      onTab,
      onLongPress,
      onLongPressEnd,
      isLottieFiles = false}) {
    return GestureDetector(
      onLongPress: () {
        if (onLongPress == null) {
          return;
        }
        onLongPress!();
      },
      onLongPressEnd: (longDetails) {
        if (onLongPressEnd == null) {
          return;
        }
        onLongPressEnd!();
      },
      onTap: () {
        if (onTab == null) {
          return;
        }
        onTab!();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10.h,
          ),
          isLottieFiles
              ? Lottie.asset(
                  Assets.recordAudio,
            height: 55.h,
            width: 55.w,
                )
              : Image.asset(
                  imageUrl,
                  height: 35.h,
                  width: 35.w,
                ),
          SizedBox(
            height:isLottieFiles? 0.h:10.h,
          ),
          Text(
            title,
            style: Utils.textStyleWidget(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
