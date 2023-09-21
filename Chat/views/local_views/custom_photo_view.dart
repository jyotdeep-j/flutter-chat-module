
import '../../../../common/export.dart';

class CustomPhotoView extends StatelessWidget {
  String? url;

  CustomPhotoView({this.url,super.key});

  @override
  Widget build(BuildContext context) {
    return  ConnectScaffold(
      padding: EdgeInsets.all(15.r),
      showAppBar: true,
      child: SizedBox(

        height: Get.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Utils.cacheNetworkImage(url: '${Constants.baseUrl}${url}',height: Get.height/3,width: Get.width,),
        ),
      ),
    );
  }
}
