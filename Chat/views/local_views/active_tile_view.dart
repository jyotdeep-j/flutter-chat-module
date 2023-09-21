import '../../../../common/export.dart';

class ActiveTileView extends StatelessWidget {
  double? height;
  double? width;
  String? url;

  ActiveTileView({this.height, this.url = "", this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      height: height ?? 60.h,
      width: width ?? 60.w,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child:url==""?Image.asset(Assets.noImageAvailable,fit: BoxFit.cover,):Utils.cacheNetworkImage(
          url: url,
          height: height ?? 60.h,
          width: width ?? 60.w,
        ),
      )
      ,
    );
  }
}
