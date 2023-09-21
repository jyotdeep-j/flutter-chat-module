import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../../common/export.dart';

class AgoraRtcView extends GetView<ChatController> {
  const AgoraRtcView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Get started with Video Calling'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          children: [
            // Container for the local video
           Obx(() =>  Container(
             height: 240,
             decoration: BoxDecoration(border: Border.all()),
             child: Center(child: _localPreview()),
           )),
            const SizedBox(height: 10),
            //Container for the Remote video
            Container(
              height: 240,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(child: _remoteVideo()),
            ),
            // Button Row
         Obx(() =>    Row(
           children: <Widget>[
             Expanded(
               child: ElevatedButton(
                 onPressed: controller.isJoined.isTrue ? null : () => {controller.join()},
                 child: const Text("Join"),
               ),
             ),
             const SizedBox(width: 10),
             Expanded(
               child: ElevatedButton(
                 onPressed: controller.isJoined.isTrue ? () => {controller.leave()} : null,
                 child: const Text("Leave"),
               ),
             ),
           ],
         ),)
            // Button Row ends
          ],
        )
    );
  }

// Display local video preview
  Widget _localPreview() {
    if (controller.isJoined.isTrue) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: controller.agoraEngine!,
          canvas: VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (controller != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.agoraEngine!,
          canvas: VideoCanvas(uid: 1),
          connection: RtcConnection(channelId: "test"),
        ),
      );
    } else {
      String msg = '';
      if (controller.isJoined.isTrue) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

}

