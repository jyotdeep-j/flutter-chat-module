import '../../../../common/export.dart';
import '../../../../data/models/user_message_model.dart';
import '../local_views/active_tile_view.dart';

class LeftChatTileView extends StatelessWidget {
  UserMessageDataModel? userMessageDataModel;

  LeftChatTileView({this.userMessageDataModel, super.key});

  @override
  Widget build(BuildContext context) {
     return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Spacer(),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 10.w, top: 5.h, bottom: 10.h),
            //width: 220.w,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.gredFirstColors,
                    AppColors.gredSecondColors
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You",
                  style: Utils.textStyleWidget(
                      fontSize: 13.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h,),
                Text(
                  userMessageDataModel?.message ?? "",
                  maxLines: 100,
                  style: Utils.textStyleWidget(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 10.h,),
                Text(
                Utils.covertUtcToLocal( userMessageDataModel?.createdAt,message: userMessageDataModel?.message)??"",
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
      ],
    );
  }
}
