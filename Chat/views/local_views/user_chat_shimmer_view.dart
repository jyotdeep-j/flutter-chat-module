import 'package:shimmer/shimmer.dart';

import '../../../../common/export.dart';

class UserChatTileShimmerView extends StatelessWidget {
  const UserChatTileShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300]!,
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
                  Container(
                    height: 10.h,
                    width: 100.w,
                    color: Colors.grey[300]!,
                    margin: EdgeInsets.only(bottom: 5.h),
                  ),
                  Container(
                    height: 10.h,
                    width: 100.w,
                    color: Colors.grey[300]!,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 7.h,
                  width: 60.w,
                  color: Colors.grey[300]!,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
