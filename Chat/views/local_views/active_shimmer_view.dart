import 'package:shimmer/shimmer.dart';

import '../../../../common/export.dart';

class ActiveShimmerView extends StatelessWidget {
  const ActiveShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.only(right: 10.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300]!,
              ),
              height: 60.h,
              width: 60.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              color: Colors.grey[300]!,
              height: 10.h,
              width: 60.w,
            )
          ],
        ),
      ),
    );
  }
}
