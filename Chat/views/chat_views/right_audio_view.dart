
import '../../../../common/export.dart';
import '../../../../data/models/user_message_model.dart';
import '../local_views/active_tile_view.dart';

class RightAudioView extends GetView<ChatController> {
  UserMessageDataModel? userMessageDataModel;
  int? index;

  RightAudioView({this.userMessageDataModel, this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Spacer(),
        Container(
          margin: EdgeInsets.only(right: 10.w, top: 5.h, bottom: 10.h),
          width: 220.w,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                  bottomLeft: Radius.circular(10.r)),
              gradient: LinearGradient(
                colors: [AppColors.gredFirstColors, AppColors.gredSecondColors],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
               /*   ActiveTileView(
                    height: 25.h,
                    width: 25.w,
                    url:
                        userMessageDataModel?.reciverDetail?.profileImage ?? "",
                  ),*/
                  Text(
                    "You",
                    style: Utils.textStyleWidget(
                        fontSize: 13.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              GestureDetector(
                onTap: () {
                  if( userMessageDataModel?.isPlay == false ||
                      userMessageDataModel?.isPlay == null){
                    controller.playAudioPlayer(
                        url: '${Constants.baseUrl}${userMessageDataModel?.media}',
                        id: index);
                  }else{
                    controller.stopAudioPlayer();
                  }

                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Colors.white.withOpacity(0.6)),
                  child: Row(
                    children: [
                      Icon(
                        userMessageDataModel?.isPlay == false ||
                                userMessageDataModel?.isPlay == null
                            ? Icons.play_circle
                            : Icons.pause_circle,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: Text(
                        Strings.play,
                        style: Utils.textStyleWidget(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700),
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, top: 10.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    userMessageDataModel?.createdAt != null &&
                            userMessageDataModel?.createdAt
                                    .toString()
                                    .contains("Z") ==
                                true
                        ? Utils.covertUtcToLocal(
                            userMessageDataModel?.createdAt)
                        : userMessageDataModel?.createdAt,
                    style: Utils.textStyleWidget(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
