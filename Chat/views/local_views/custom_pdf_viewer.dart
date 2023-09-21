import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../common/export.dart';

class CustomPdfViewView extends StatelessWidget {
  String? url;

  CustomPdfViewView({this.url, super.key});

  @override
  Widget build(BuildContext context) {
    print("check url ${url}");
    return ConnectScaffold(
      padding: EdgeInsets.all(10.r),
      showAppBar: true,
      child: SfPdfViewer.network(
        url??"",
      ),
    );
  }
}
