import 'package:get_storage/get_storage.dart';

import '../../../common/export.dart';
import '../../../data/models/chat_all_model.dart';
import '../../../widgets/header_view.dart';
import '../controller/chat_controller.dart';
import 'chat_screen.dart';
import 'local_views/active_shimmer_view.dart';
import 'local_views/chat_tile_view.dart';
import 'local_views/user_chat_shimmer_view.dart';

class ChatView extends GetView<ChatController> {
  ChatView({super.key}) {
    Get.lazyPut(() => ChatController());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.stopAudioPlayer();
        controller.hitApiToUpdateChatStatus(false);
        //  await controller .hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
        return Future.value(false);
      },
      child: RefreshIndicator(
        color: Colors.transparent,
        backgroundColor: AppColors.gredFirstColors,
        onRefresh: () {
          controller.activeChatList!.clear();
          controller.chatList?.clear();
          controller.hitApiToActiveChatList(
              map: {"records_per_page": 10, "page_no": 1});

          controller
              .hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
          return Future.value(false);
        },
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderView(title: Strings.newActive, showDot: true),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => SizedBox(
                  height: 100.h,
                  child: controller.hasNewActive.isTrue
                      ? ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return const ActiveShimmerView();
                          })
                      : controller.activeChatList!.length != 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              controller: controller.activeChatController,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.activeChatList!.length ?? 0,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.userChatPage.value = 1;
                                    Get.to(ChatScreenView(
                                      false,
                                      userChatModel: UserChatModel(
                                          matchId: controller
                                              .activeChatList![index].id,
                                          senderDetail: SenderDetailModel(
                                              id: GetStorage()
                                                  .read(StorageKeys.userId)),
                                          reciverDetail: ReciverDetailModel(
                                              id: controller
                                                  .activeChatList![index]
                                                  .userTwo
                                                  ?.id,
                                              firstname: controller
                                                      .activeChatList![index]
                                                      .userTwo
                                                      ?.firstname ??
                                                  "",
                                              profileImage: controller
                                                  .activeChatList![index]
                                                  .userTwo
                                                  ?.profileImage,
                                              matchId: controller
                                                  .activeChatList![index].id
                                                  ?.toString(),
                                              isChat: controller
                                                  .activeChatList![index]
                                                  .userTwo
                                                  ?.isChat)),
                                    ));
                                  },
                                  child: Container(
                                    width: 100.w,
                                    padding: EdgeInsets.only(right: 10.h),
                                    child: Column(
                                      children: [
                                        controller.activeChatList![index]
                                                        ?.userTwo?.userImages !=
                                                    null &&
                                                controller
                                                        .activeChatList![index]
                                                        ?.userTwo
                                                        ?.userImages
                                                        ?.isNotEmpty ==
                                                    true
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60.r),
                                                child: Utils.cacheNetworkImage(
                                                    height: 60.h,
                                                    width: 60.h,
                                                    url: controller
                                                            .activeChatList![
                                                                index]
                                                            ?.userTwo
                                                            ?.userImages
                                                            ?.first
                                                            ?.imageName ??
                                                        ""))
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40.r),
                                                child: Image.asset(
                                                  Assets.noImageAvailable,
                                                  fit: BoxFit.fill,
                                                  height: 45.h,
                                                  width: 50.w,
                                                ),
                                              ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          '${controller.activeChatList![index].userTwo?.firstname ?? ""}\n${controller.activeChatList![index].userTwo?.lastname ?? ""}',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : const Center(child: Text(Strings.noDataFound)),
                )),
            Divider(
              color: AppColors.lightGreyColor,
              thickness: 1.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => controller.hasUserChatList.isTrue
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const UserChatTileShimmerView();
                    },
                  )
                : controller.chatList?.length != 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        controller: controller.userChatController,
                        itemCount: controller.chatList?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                controller.userChatPage.value = 1;
                                Get.to(ChatScreenView(
                                  false,
                                  userChatModel: controller.chatList![index],
                                ));
                              },
                              child: ChatTileView(
                                userChatModel: controller.chatList![index],
                              ));
                        })
                    : const Center(child: Text(Strings.noDataFound))),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
