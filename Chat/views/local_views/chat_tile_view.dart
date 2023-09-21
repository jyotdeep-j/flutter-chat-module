import '../../../../common/export.dart';
import '../../../../data/models/chat_all_model.dart';
import 'active_tile_view.dart';

class ChatTileView extends StatelessWidget {
  UserChatModel? userChatModel;

  ChatTileView({this.userChatModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          userChatModel?.reciverDetail?.userImages != null &&
                  userChatModel?.reciverDetail?.userImages?.isNotEmpty == true
              ? ActiveTileView(
                  height: 45.h,
                  url:
                      '${userChatModel?.reciverDetail?.userImages?.first.imageName}',
                  width: 50.w,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: Image.asset(
                    Assets.noImageAvailable,
                    fit: BoxFit.fill,
                    height: 45.h,
                    width: 50.w,
                  ),
                ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userChatModel?.reciverDetail?.firstname?.trim() ?? "",
                  style: Utils.textStyleWidget(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  userChatModel?.messageType == "text"
                      ? userChatModel?.message ?? ""
                      : Strings.sentAnAttachment,
                  maxLines: 1,
                  style: Utils.textStyleWidget(
                      color: AppColors.greyshColors,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(
                Utils.covertUtcToLocal(userChatModel?.updatedAt),
                style: Utils.textStyleWidget(
                    color: AppColors.greyshColors,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }
}
