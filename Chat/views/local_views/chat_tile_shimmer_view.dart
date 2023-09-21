import 'package:shimmer/shimmer.dart';

import '../../../../common/export.dart';
import 'active_tile_view.dart';

class ChatTileShimmerView extends StatelessWidget {
  const ChatTileShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            ActiveTileView(
              height: 45.h,
              width: 45.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Natasha Wink",
                    style: Utils.textStyleWidget(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Hello, evening too Andrew",
                    style: Utils.textStyleWidget(
                        color: AppColors.greyshColors,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
