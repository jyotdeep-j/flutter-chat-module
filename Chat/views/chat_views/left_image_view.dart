import '../../../../common/export.dart';
import '../../../../data/models/user_message_model.dart';
import '../local_views/active_tile_view.dart';

class LeftImageView extends StatelessWidget {
  UserMessageDataModel? userMessageDataModel;

  LeftImageView({this.userMessageDataModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Container(
          height: 280.h,
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
            children: [
              Row(
                children: [
                /*  ActiveTileView(
                    height: 25.h,
                    width: 25.w,
                    url: userMessageDataModel?.reciverDetail?.profileImage ?? "",
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
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Utils.cacheNetworkImage(
                    url:
                        '${Constants.baseUrl}${userMessageDataModel?.media ?? ""}',
                    height: 200.h,
                    width: Get.width * 0.8,
                    fit: BoxFit.fill,
                  )),
              Padding(
                padding: EdgeInsets.only(left: 10.w,top: 10.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    userMessageDataModel?.createdAt!=null&& userMessageDataModel?.createdAt.toString().contains("Z")==true?
                    Utils.covertUtcToLocal( userMessageDataModel?.createdAt)
                        :  userMessageDataModel?.createdAt,
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
    ;
  }
}
