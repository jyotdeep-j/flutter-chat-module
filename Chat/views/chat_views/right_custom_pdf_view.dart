
import '../../../../common/export.dart';
import '../../../../data/models/user_message_model.dart';
import '../../../setting/views/local_views/custom_web_view.dart';
import '../local_views/active_tile_view.dart';
import '../local_views/custom_pdf_viewer.dart';

class RightCustomPdfView extends StatelessWidget {
  UserMessageDataModel? userMessageDataModel;

  RightCustomPdfView({this.userMessageDataModel, super.key});

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
                    url: userMessageDataModel?.senderDetail?.profileImage ?? "",
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
                onTap: (){
                  print("yes lciked");
                  Get.to(CustomPdfViewView(
                    url:
                    '${Constants.baseUrl}${userMessageDataModel?.media}',
                  ));


                },
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: Colors.white.withOpacity(0.6)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.w,),
                      Expanded(
                          child: Text(
                        Strings.tabToView,
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
  }
}
