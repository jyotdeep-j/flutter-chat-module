import 'package:get_storage/get_storage.dart';
import 'package:singles_connect/app/modules/chat/views/chat_views/right_audio_view.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../common/export.dart';
import '../../../data/models/chat_all_model.dart';
import '../controller/chat_controller.dart';
import 'chat_views/chat_field.dart';
import 'chat_views/chat_header_view.dart';
import 'chat_views/left_audio_view.dart';
import 'chat_views/left_chat_tile.dart';
import 'chat_views/left_custom_pdf_view.dart';
import 'chat_views/left_image_view.dart';
import 'chat_views/right_custom_pdf_view.dart';
import 'chat_views/right_image_view.dart';
import 'chat_views/right_tile_view.dart';
import 'local_views/custom_photo_view.dart';

class ChatScreenView extends GetView<ChatController>
    with WidgetsBindingObserver {
  bool? fromProfile;
  var userId;
  UserChatModel? userChatModel;

  ChatScreenView(this.fromProfile,
      {this.userChatModel, this.userId, super.key}) {
    Get.lazyPut(() => ChatController());

    socket?.emit('connectCustomerRoom', {'id': userChatModel?.matchId});

    socket!.onConnect((data) {
      socket?.emit('connectCustomerRoom', {'id': userChatModel?.matchId});
    });
    controller.joinedRoom();

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    if (userChatModel == null) return;
    controller.userChatModel = userChatModel;
    controller.customUserMsgList?.clear();
    controller.userMsgList?.clear();
    controller.hitApiToUserChatList(map: {
      "match_id": userChatModel?.matchId,
      "receiver_id": userChatModel?.reciverDetail?.id,
      "sender_id": GetStorage().read(StorageKeys.userId),
      "records_per_page": 8,
      "page_no": 1
    });
    controller.addPaginationOnUserChat();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatHeaderView(fromProfile, userChatModel),
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(Assets.bgImage))),
        child: Column(
          children: [
            SizedBox(
              height: 12.h,
            ),
            Obx(
              () => controller.loadMoreData.isTrue
                  ? CircularProgressIndicator(
                      color: AppColors.gredFirstColors,
                    )
                  : const SizedBox(),
            ),
            Obx(
              () => controller.loadMoreData.isTrue
                  ? SizedBox(
                      height: 12.h,
                    )
                  : const SizedBox(),
            ),
            Obx(() => Expanded(child: innerListView())),
            SizedBox(
              height: 20.h,
            ),
            ChatFieldView(
              userChatModel: controller.userChatModel,
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  innerListView() {
    return controller.userMsgList?.length != 0
        ? ListView.builder(
            controller: controller.messageScrollController.value,
            itemCount: controller.userMsgList?.length ?? 0,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              return controller.userMsgList![index].messageType == "text"
                  ? controller.userMsgList![index].senderId !=
                          GetStorage().read(StorageKeys.userId)
                      ? RightChatTileView(
                          userMessageDataModel: controller.userMsgList![index],
                        )
                      : LeftChatTileView(
                          userMessageDataModel: controller.userMsgList![index],
                        )
                  : controller.userMsgList![index].messageType == "image"
                      ? controller.userMsgList![index].senderId !=
                              GetStorage().read(StorageKeys.userId)
                          ? GestureDetector(
                              onTap: () {
                                Get.to(CustomPhotoView(
                                  url: controller.userMsgList![index].media,
                                ));
                              },
                              child: RightImageView(
                                  userMessageDataModel:
                                      controller.userMsgList![index]),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.to(CustomPhotoView(
                                  url: controller.userMsgList![index].media,
                                ));
                              },
                              child: LeftImageView(
                                  userMessageDataModel:
                                      controller.userMsgList![index]),
                            )
                      : controller.userMsgList![index].messageType == "docs"
                          ? controller.userMsgList![index].senderId !=
                                  GetStorage().read(StorageKeys.userId)
                              ? LeftCustomPdfView(
                                  userMessageDataModel:
                                      controller.userMsgList![index],
                                )
                              : RightCustomPdfView(
                                  userMessageDataModel:
                                      controller.userMsgList![index],
                                )
                          : controller.userMsgList![index].messageType ==
                                  "audio"
                              ? controller.userMsgList![index].senderId !=
                                      GetStorage().read(StorageKeys.userId)
                                  ? LeftAudioView(
                                      userMessageDataModel:
                                          controller.userMsgList![index],
                                      index: controller.userMsgList![index].id,
                                    )
                                  : RightAudioView(
                                      userMessageDataModel:
                                          controller.userMsgList![index],
                                      index: controller.userMsgList![index].id,
                                    )
                              : const SizedBox();
            })
        : controller.hasUserChatData.value
            ? Align(
      alignment: Alignment.topCenter,
              child: SizedBox(
                  height: 50.h,
                  width: 50.w,
                  child: const Center(child: CircularProgressIndicator())),
            )
            : Utils.noDataFoundWidget(msg: Strings.chatNotFound);
  }
}
