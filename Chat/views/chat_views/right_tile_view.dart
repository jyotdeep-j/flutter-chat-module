import '../../../../common/export.dart';
import '../../../../data/models/user_message_model.dart';
import '../local_views/active_tile_view.dart';

class RightChatTileView extends StatelessWidget {
  UserMessageDataModel? userMessageDataModel;

  RightChatTileView({this.userMessageDataModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 10.w,),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 10.w, top: 5.h, bottom: 10.h),
            //width: 220.w,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r)),
                gradient: LinearGradient(
                  colors: [AppColors.lightPinkColor, AppColors.lightPinkColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userMessageDataModel?.senderDetail?.firstname ?? "",
                  style: Utils.textStyleWidget(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  userMessageDataModel?.message ?? "",
                  maxLines: 100,
                  style: Utils.textStyleWidget(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  userMessageDataModel?.createdAt != null &&
                          userMessageDataModel?.createdAt
                                  .toString()
                                  .contains("Z") ==
                              true
                      ? Utils.covertUtcToLocal(userMessageDataModel?.createdAt)
                      : userMessageDataModel?.createdAt,
                  style: Utils.textStyleWidget(
                      fontSize: 8.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                )
              ],
            ) 
            ,
          ),
        ),
        const Spacer(),
      ],
    );
  }}