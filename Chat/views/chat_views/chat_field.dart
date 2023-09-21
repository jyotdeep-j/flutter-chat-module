import 'package:get_storage/get_storage.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../common/export.dart';
import '../../../../data/models/chat_all_model.dart';
import '../../controller/chat_controller.dart';
import '../local_views/custom_attachment.dart';

class ChatFieldView extends GetView<ChatController> {
  UserChatModel? userChatModel;

  ChatFieldView({this.userChatModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                child: Row(
                  children: [
                    /*Image.asset(
                      Assets.smilyImage,
                      height: 25.h,
                      width: 25.w,
                    ),*/
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        controller: controller.chatController,
                        decoration: InputDecoration(
                            hintStyle: Utils.textStyleWidget(
                                color: AppColors.greyshColors.withOpacity(0.4),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                            hintText: Strings.typeAMessage,
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    SuperTooltip(
                      showBarrier: true,
                      controller: controller.superController,
                      popupDirection: TooltipDirection.up,
                      backgroundColor: Colors.white,
                      left: 30,
                      right: 30,
                      arrowTipDistance: 15.0,
                      arrowBaseWidth: 20.0,
                      arrowLength: 20.0,
                      borderWidth: 2.0,
                      onShow: () {
                        controller.isLongPress.value = false;
                        controller.update();
                      },
                      constraints: const BoxConstraints(
                        minHeight: 0.0,
                        maxHeight: 100,
                        minWidth: 0.0,
                        maxWidth: 100,
                      ),
                      showCloseButton: ShowCloseButton.none,
                      touchThroughAreaShape: ClipAreaShape.rectangle,
                      touchThroughAreaCornerRadius: 30,
                      content:
                          CustomAttachMentView(userChatModel: userChatModel),
                      child: Image.asset(
                        Assets.attachmentImage,
                        height: 18.h,
                        fit: BoxFit.contain,
                        width: 18.w,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectImageFromCamera(userChatModel);
                      },
                      child: Image.asset(
                        Assets.cameraImage,
                        height: 22.h,
                        width: 22.w,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (controller.chatController.text.isEmpty) {
                return;
              }

              Map<String, dynamic> map = {};
              map['sender_id'] = GetStorage().read(StorageKeys.userId);
              map['receiver_id'] = userChatModel?.reciverDetail?.id;
              map['match_id'] = userChatModel?.matchId;
              map['message'] = controller.chatController.text.trimLeft().trimRight();
              map['message_type'] = "text";
              map['media'] = "";
              map['isRead'] = userChatModel?.reciverDetail?.matchId ==
                      userChatModel?.matchId.toString()
                  ? userChatModel?.reciverDetail?.isChat?.toString()
                  : "0";
              print("check emit messagfe ${map} and ${userChatModel?.reciverDetail?.matchId}");

              socket?.emit('addMessage', map);
              socket!.emit("emit_event");
              socket!.on('emit_event', (data) {
                print('Received event: $data');
              });
             // controller.refreshChatList();
              controller.chatController.text = "";
            },
            child: Image.asset(
              Assets.sendImage,
              height: 35.h,
              fit: BoxFit.contain,
              width: 35.w,
            ),
          ),
        ],
      ),
    );
  }
}
