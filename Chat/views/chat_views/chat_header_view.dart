
import '../../../../common/export.dart';
import '../../../../data/models/chat_all_model.dart';
import '../../../../data/models/user_upload_image.dart';
import '../../../user_complete_profile/views/user_complete_profile_view.dart';
import '../agora/agora_video_view.dart';
import '../local_views/active_tile_view.dart';

class ChatHeaderView extends GetView<ChatController> implements PreferredSize {
  bool? fromProfile;
  UserChatModel? userChatModel;

  ChatHeaderView(this.fromProfile, this.userChatModel,{super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20.h,
            left: 10.w,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.stopAudioPlayer();

                  controller.hitApiToUpdateChatStatus(false);
                  if (fromProfile == true) {
                    Get.offAllNamed(AppPages.dashboard);
                  } else {
                    Get.back();
                  }
                },
                child: Image.asset(
                  Assets.backImage,
                  height: 18.h,
                  width: 18.w,
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              userChatModel?.reciverDetail?.userImages != null &&
                      userChatModel?.reciverDetail?.userImages?.isNotEmpty ==
                          true
                  ? GestureDetector(
                      onTap: () {
                        Get.to(UserCompleteProfileView(
                          userId: userChatModel?.reciverDetail?.id,
                          matchId: userChatModel?.matchId,
                          showIcons: false,
                        ));
                      },
                      child: ActiveTileView(
                        height: 35.h,
                        url:
                            '${userChatModel?.reciverDetail?.userImages?.first.imageName}',
                        width: 40.w,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Get.to(UserCompleteProfileView(
                          userId: userChatModel?.reciverDetail?.id,
                          matchId: userChatModel?.matchId,
                          showIcons: false,
                        ));
                      },
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                        child: Image.asset(
                          Assets.noImageAvailable,
                          fit: BoxFit.fill,
                          height: 45.h,
                          width: 50.w,
                        ),
                      ) ,
                    ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                userChatModel?.reciverDetail?.firstname ?? "",
                style: Utils.textStyleWidget(
                    fontSize: 18.sp,
                    color: AppColors.volietColors,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Image.asset(
                Assets.callingImage,
                height: 18.h,
                width: 18.w,
              ),
              SizedBox(
                width: 15.w,
              ),
              GestureDetector(
                onTap: () async {

                 // Get.to(const AgoraRtcView());
                 // await AgoraVideoCall.initAgora();
                },
                child: Image.asset(
                  Assets.videoImage,
                  height: 18.h,
                  width: 18.w,
                ),
              ),
              _popupMenu,
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ));
  }

  Widget get _popupMenu => PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Image.asset(
        Assets.threeHorizontalImage,
        height: 15.h,
        width: 15.w,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: "1",
              child: Text(
                Strings.block,
                style: Utils.textStyleWidget(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            PopupMenuItem<String>(
              value: "2",
              child: Text(
                Strings.report,
                style: Utils.textStyleWidget(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
      onSelected: (String value) {
        // Handle option selection here
        switch (value) {
          case '1':
            controller.showUserBlockDialog();
            break;
          case '2':
            controller.hitApiToGetReportedList();
            break;
        }
      });

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
