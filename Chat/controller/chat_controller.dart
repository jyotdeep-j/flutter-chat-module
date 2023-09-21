import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../common/export.dart';
import '../../../common/image_picker.dart';
import '../../../data/models/active_user_mode.dart';
import '../../../data/models/chat_all_model.dart';
import '../../../data/models/custom_chat_model.dart';
import '../../../data/models/report_model.dart';
import '../../../data/models/user_message_model.dart';
import '../../../data/models/user_upload_image.dart';
import '../../../data/providers/chat_provider/impl/remote_chat_provider.dart';
import '../../../data/providers/chat_provider/interface/ichat_repostary.dart';
import '../../../widgets/alert_dialog.dart';
import '../../setting/views/local_views/logout_dialog.dart';
import '../../user_complete_profile/views/local_views/report_user_dialog.dart';

class ChatController extends GetxController with WidgetsBindingObserver {
  IChatRepository? iChatRepository;
  var chatController = TextEditingController();
  var messageScrollController = ScrollController().obs;
  var userChatController = ScrollController();
  var activeChatController = ScrollController();
  final superController = SuperTooltipController();
  List<UploadedImageDataModel>? userImageList = [];
  RxBool loadMoreData = false.obs;

  RxBool hasNewActive = true.obs;
  RxBool hasUserChatList = true.obs;

  RxInt userPageNumber = 1.obs;
  RxInt activePageNumber = 1.obs;
  RxBool isLongPress = false.obs;
  RxBool hasUserChatData = true.obs;
  RxList<UserChatModel>? chatList = <UserChatModel>[].obs;

  final record = Record();
  RxList<ReportDataModel>? reportList = <ReportDataModel>[].obs;

  UserChatDetailModel? userMessageModel = UserChatDetailModel();
  RxInt userChatPage = 1.obs;
  IAuthRepository? iAuthRepository;

  RxList<UserMessageDataModel>? userMsgList = <UserMessageDataModel>[].obs;
  RxList<UserMessageDataModel>? userChitChatists = <UserMessageDataModel>[].obs;
  RxList<CustomChatModel>? customUserMsgList = <CustomChatModel>[].obs;
  RxList<ActiveDataModel>? activeChatList = <ActiveDataModel>[].obs;
  UserChatModel? userChatModel = UserChatModel();

  ChatAllDataModel? chatAllDataModel = ChatAllDataModel();
  ActiveDetailModel? activeDetailModel = ActiveDetailModel();
  Timer? timer;

  //for video call handling
 RxInt  remoteUserUid=0.obs;
  bool localUserJoined = false;
  RtcEngine? agoraEngine;
  RxBool isJoined = false.obs;

  @override
  Future<void> onInit() async {
    WidgetsBinding.instance.addObserver(this);
    iAuthRepository = Get.put<RemoteAuthProvider>(RemoteAuthProvider());
    iChatRepository = Get.put(RemoteChatProvider());
  // await setupVideoSDKEngine();
    socketOperations();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      activeChatList!.clear();
      hitApiToActiveChatList(map: {"records_per_page": 10, "page_no": 1});
      userActiveListListener();
      //this is
      chatList?.clear();
      hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
      userChatListListener();
    });

    // TODO: implement onInit
    super.onInit();
  }

  socketOperations() {
    joinedRoom();
    refreshRoom();
    listenChatEvent();
  }

  Future<void> setupVideoSDKEngine() async {
    print("called setupVideoSDKEngine ");
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine?.initialize(const RtcEngineContext(appId: Constants.AGORA_APP_ID));

    await agoraEngine?.enableVideo();

    // Register the event handler
    agoraEngine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Utils.showToast(
              message:
                  "Local user uid:${connection.localUid} joined the channel");
          isJoined.value = true;
          update();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Utils.showToast(
              message: "Remote user uid:$remoteUid joined the channel");
          remoteUserUid.value = remoteUid;
          update();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          Utils.showToast(
              message: "Remote user uid:$remoteUid left the channel");
          remoteUserUid.value = 0;
          update();
        },
      ),
    );
  }


  void  join() async {
    await agoraEngine?.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine?.joinChannel(
      token: Constants.AGORA_APP_TOKEN,
      channelId: "test",
      options: options,
      uid: 1,
    );
  }


  void leave() {
    isJoined.value= false;
    remoteUserUid.value = 0;
    agoraEngine?.leaveChannel();
  }


  //pagination for list
  userChatListListener() {
    userChatController.addListener(() {
      if (userChatController.position.pixels ==
          userChatController.position.maxScrollExtent) {
        if (chatAllDataModel != null &&
            int.parse(chatAllDataModel?.pageNo?.toString() ?? "1") <
                int.parse(chatAllDataModel?.totalPages?.toString() ?? "1")) {
          userPageNumber.value = userPageNumber.value + 1;
          hitApiToGetChatList(
              map: {"records_per_page": 10, "page_no": userPageNumber.value});
        }
      }
    });
  }

  userActiveListListener() {
    activeChatController.addListener(() {
      if (activeChatController.position.pixels ==
          activeChatController.position.maxScrollExtent) {
        if (chatAllDataModel != null &&
            int.parse(chatAllDataModel?.pageNo?.toString() ?? "1") <
                int.parse(chatAllDataModel?.totalPages?.toString() ?? "1")) {
          activePageNumber.value = activePageNumber.value + 1;
          hitApiToActiveChatList(
              map: {"records_per_page": 10, "page_no": activePageNumber});
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      stopAudioPlayer();
    }
  }

  requestAudioPermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      Utils.showToast(message: Strings.grantAudioPermission);
    }
  }

  startRecording() async {
    var directory = await getExternalStorageDirectory();
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: '${directory?.path}/audioRecord.m4a',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        // by default
      );

      bool isRecording = await record.isRecording();
      if (isRecording) {
        isLongPress.value = true;
      }
      print("isRecording ${isRecording}");
      update();
    } else {
      Utils.showToast(message: Strings.grantAudioPermission);
    }
  }

  Future playAudioPlayer({url, id}) async {
    await audioPlayer.play(UrlSource(url));
    int? index = userMsgList?.value
        .indexWhere((element) => element.id?.toString() == id.toString());
    if (index != -1) {
      userMsgList?.value.forEach((element) {
        element?.isPlay = false;
      });
      userMsgList![index!].isPlay = true;
      userMsgList!.refresh();
      update();
    }
    checkAudioPlayerState(index);
  }

  stopAudioPlayer() async {
    userMsgList?.value.forEach((element) {
      element?.isPlay = false;
    });
    userMsgList!.refresh();
    update();
    await audioPlayer.pause();
  }

  void checkAudioPlayerState(index) {
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        userMsgList![index!].isPlay = false;
        userMsgList!.refresh();
        update();
      }
    });
  }

  stopPlayer() async {
    if (audioPlayer != null) {
      audioPlayer.stop();
    }
    bool isRecording = await record.isRecording();
    if (!isRecording) {
      isLongPress.value = false;
    }
    update();
  }

  Future<void> stopRecording(UserChatModel? userChatModel) async {
    superController.hideTooltip();
    var directory = await getExternalStorageDirectory();
    await record.stop();
    List<int> imageBytes =
        File('${directory?.path}/audioRecord.m4a').readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    Map<String, dynamic> map = {};
    map['sender_id'] = GetStorage().read(StorageKeys.userId);
    map['receiver_id'] = userChatModel?.reciverDetail?.id;
    map['match_id'] = userChatModel?.matchId;
    map['message'] = "";
    map['message_type'] = "audio";
    map['extension'] = "m4a";
    map['isRead'] = userChatModel?.reciverDetail?.matchId ==
            userChatModel?.matchId.toString()
        ? userChatModel?.reciverDetail?.isChat?.toString()
        : "0";

    map['media'] = base64Image;
    print("chec----- ${map}");

    socket?.emit('addMessage', map);
    chatList?.clear();
    hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
  }

  joinedRoom() {
    socket!.on('TestingCustomerRoom', (data) {
      print("TestingtCustomerRoom ${data}");
    });
  }

  refreshRoom() {
    socket!.on('autoRefresh', (data) {
      if (data != null && data.isNotEmpty) {
        if (chatList?.isNotEmpty == true) {
          var matchId = data['data'][0]['match_id'];
          // var list=chatList?.where((element) => element.id?.toString())
        }
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    print("check called");
    if (MediaQuery.of(Get.overlayContext!).viewInsets.bottom == 0) {
      // Keyboard closed
    } else {
      // Keyboard opened
      /* int length = userMsgList?.length ?? 0;
      double itemHeight =
          MediaQuery.of(Get.overlayContext!).size.height / length;
      messageScrollController.value.animateTo(
        messageScrollController.value.position.maxScrollExtent * itemHeight,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );*/
    }
  }

  listenChatEvent() {
    socket!.on('chatMessage', (data) {
      print("Testing chatMessage ${data}");
      if (data != null && data.isNotEmpty) {
        userMsgList!.insert(
            0,
            UserMessageDataModel(
              message: data['data'][0]['message'],
              senderId: data['data'][0]['sender_id'],
              messageType: data['data'][0]['message_type'],
              matchId: data['data'][0]['match_id'],
              isRead: data['data'][0]['isRead'],
              media: data['data'][0]['media'],
              senderDetail: SenderDetailModel(
                  id: data['sender_detail'][0]['id'],
                  firstname: data['sender_detail'][0]['firstname'],
                  email: data['sender_detail'][0]['email'],
                  matchId: data['sender_detail'][0]['match_id']),
              reciverDetail: ReciverDetailModel(
                  id: data['receiver_detail'][0]['id'],
                  firstname: data['receiver_detail'][0]['firstname'],
                  email: data['receiver_detail'][0]['email'],
                  matchId: data['receiver_detail'][0]['match_id']),

              // createdAt: data['data'][0]['created_at'],
              createdAt:
                  DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
            ));

        userMsgList;
        if (messageScrollController.value.hasClients) {
          messageScrollController.value.animateTo(
            messageScrollController.value.position.minScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  refreshChatList() {
    var test = chatList!.value
        .where((element) =>
            element.matchId.toString() == userChatModel?.matchId.toString())
        .toList();
    if (test.isNotEmpty) {
      chatList?.first.message = "tested by me";
    }
    chatList!.refresh();
  }

  hitApiToGetChatList({map}) async {
    try {
      await iChatRepository?.getAllChatList(map: map).then((value) {
        if (value != null && value.data != null) {
          hasUserChatList.value = false;
          chatAllDataModel = value.data;
          chatList?.addAll(value.data?.chatList ?? []);
        }
      });
    } on DioError catch (error) {
      hasUserChatList.value = false;
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  //here we get user particular chat
  hitApiToUserChatList({map}) async {
    try {
      map;
      await iChatRepository?.getAllUserChatList(map: map).then((value) {
        if (value != null && value.data != null) {
          userMessageModel = value.data;
          hasUserChatData.value = true;
          hasUserChatData.value =
              value.data?.chatList?.isNotEmpty == true ? true : false;
          userMsgList!
              .addAll(userMessageModel?.chatList?.reversed.toList() ?? []);
          loadMoreData.value = false;

          update();
        }
      });
    } on DioError catch (error) {
      hasUserChatData.value = false;
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  addPaginationOnUserChat() {
    messageScrollController.value.addListener(() {
      if (messageScrollController.value.position.pixels ==
          messageScrollController.value.position.maxScrollExtent) {
        if (userMessageModel != null &&
            int.parse(userMessageModel?.pageNo?.toString() ?? "1") <
                int.parse(userMessageModel?.totalPages?.toString() ?? "1")) {
          userChatPage.value = userChatPage.value + 1;
          loadMoreData.value = true;
          hitApiToUserChatList(map: {
            "match_id": userChatModel?.matchId,
            "receiver_id": userChatModel?.reciverDetail?.id,
            "sender_id": GetStorage().read(StorageKeys.userId),
            "records_per_page": 8,
            "page_no": userChatPage.value
          });
        }
      }
    });

    return;

    // print("i am gerte");
    messageScrollController.value.addListener(() {
      if (messageScrollController.value.position.pixels ==
          messageScrollController.value.position.minScrollExtent) {
        print("i am here for pagination");
        if (userMessageModel != null &&
            int.parse(userMessageModel?.pageNo?.toString() ?? "1") <
                int.parse(userMessageModel?.totalPages?.toString() ?? "1")) {
          userChatPage.value = userChatPage.value + 1;
          loadMoreData.value = true;
          hitApiToUserChatList(map: {
            "match_id": userChatModel?.matchId,
            "receiver_id": userChatModel?.reciverDetail?.id,
            "sender_id": GetStorage().read(StorageKeys.userId),
            "records_per_page": 8,
            "page_no": userChatPage.value
          });
        }
      }
    });
  }

  //get all active list

  hitApiToActiveChatList({map}) async {
    try {
      await iChatRepository?.getAllActiveUserList(map: map).then((value) {
        if (value != null && value.data != null) {
          hasNewActive.value = false;
          activeDetailModel = value.data;
          activeChatList?.addAll(value?.data?.activeList ?? []);
          activeChatList!.refresh();
          update();
        }
      });
    } on DioError catch (error) {
      hasNewActive.value = false;
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  hitApiToUpdateChatStatus(bool refresh) async {
    if (refresh) {
      chatList!.clear();
      await hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
    }

    try {
      await iChatRepository?.updateChatStatus().then((value) {
        if (value != null) {}
      });
    } on DioError catch (error) {
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  selectImageFromCamera(UserChatModel? userChatModel) async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      Utils.showToast(message: Strings.grantCameraPermission);
    } else {
      var result = await CustomImagePicker.cameraImage();
      if (result.path.isNotEmpty) {
        List<int> imageBytes = File(result.path).readAsBytesSync();
        var bytes = File(result.path).readAsBytesSync().length;
        if (bytes > 20971520) {
          Utils.showToast(message: Strings.imageSizeLength);
          return;
        }
        print("check image size ${bytes}");

        String base64Image = base64Encode(imageBytes);
        print("check bases 64 ${base64Image}");
        Map<String, dynamic> map = {};
        map['sender_id'] = GetStorage().read(StorageKeys.userId);
        map['receiver_id'] = userChatModel?.reciverDetail?.id;
        map['match_id'] = userChatModel?.matchId;
        map['message'] = "";
        map['message_type'] = "image";
        map['extension'] = "png";

        map['isRead'] = userChatModel?.reciverDetail?.matchId ==
                userChatModel?.matchId.toString()
            ? userChatModel?.reciverDetail?.isChat?.toString()
            : "0";

        map['media'] = base64Image;

        print("chec ${map}");
        socket?.emit('addMessage', map);
        chatList?.clear();
        hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
      }
    }
  }

  selectImageFromGallery(UserChatModel? userChatModel) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      Utils.showToast(message: Strings.grantGalleryPermission);
    } else {
      var result = await CustomImagePicker.galleryImage();
      if (result.path.isNotEmpty) {
        List<int> imageBytes = File(result.path).readAsBytesSync();
        var bytes = File(result.path).readAsBytesSync().length;
        if (bytes > 20971520) {
          Utils.showToast(message: Strings.imageSizeLength);
          return;
        }
        print("check image size ${bytes}");

        String base64Image = base64Encode(imageBytes);
        print("check bases 64 ${base64Image}");
        Map<String, dynamic> map = {};
        map['sender_id'] = GetStorage().read(StorageKeys.userId);
        map['receiver_id'] = userChatModel?.reciverDetail?.id;
        map['match_id'] = userChatModel?.matchId;
        map['message'] = "";
        map['message_type'] = "image";
        map['extension'] = "png";

        map['isRead'] = userChatModel?.reciverDetail?.matchId ==
                userChatModel?.matchId.toString()
            ? userChatModel?.reciverDetail?.isChat?.toString()
            : "0";

        map['media'] = base64Image;

        print("chec----- ${map}");

        socket?.emit('addMessage', map);
        chatList?.clear();
        hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
      }
    }
  }

  selectFilesFromGallery(UserChatModel? userChatModel) async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      Utils.showToast(message: Strings.grantGalleryPermission);
    } else {
      var result = await CustomImagePicker.selectGalleryFile();
      if (result != null &&
          result.paths.isNotEmpty &&
          result.paths.first!.isNotEmpty == true) {
        List<int> imageBytes = File(result.paths.first!).readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        print("check bases 64 ${base64Image}");
        Map<String, dynamic> map = {};
        map['sender_id'] = GetStorage().read(StorageKeys.userId);
        map['receiver_id'] = userChatModel?.reciverDetail?.id;
        map['match_id'] = userChatModel?.matchId;
        map['message'] = "";
        map['message_type'] = "docs";
        map['extension'] =
            result.paths.first?.toLowerCase().endsWith(".pdf") == true
                ? "pdf"
                : "doc";
        map['isRead'] = userChatModel?.reciverDetail?.matchId ==
                userChatModel?.matchId.toString()
            ? userChatModel?.reciverDetail?.isChat?.toString()
            : "0";

        map['media'] = base64Image;

        print("sahdisds ${map}");
        socket?.emit('addMessage', map);
        chatList?.clear();
        hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
      }
    }
  }

  showUserBlockDialog() {
    Get.dialog(LogoutDialog(
      btnTxt: Strings.block,
      description:
          '${Strings.areYouSureBlock}  ${userChatModel?.reciverDetail?.firstname ?? ""}',
      title: Strings.block,
      onTab: () {
        Get.back();
        hitApiToUserBlocked(userId: userChatModel?.reciverDetail?.id);
      },
    ));
  }

  hitApiToUserBlocked({userId}) async {
    try {
      Utils.showLoader();
      await iAuthRepository
          ?.userBlocked(map: {'block_to': userId}).then((value) {
        Utils.hideLoader();
        Utils.showToast(message: value.message ?? "");
        chatList?.clear();
        hitApiToGetChatList(map: {"records_per_page": 10, "page_no": 1});
        Get.back();
      });
    } on DioError catch (error) {
      Utils.hideLoader();
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  hitApiToGetReportedList() async {
    try {
      reportList!.clear();
      Utils.showLoader();
      await iAuthRepository?.getReportList().then((value) {
        Utils.hideLoader();
        if (value != null && value.data != null) {
          reportList!.addAll(value.data ?? []);
          CustomAlertDialog.showGenerateDialog(
              context: Get.overlayContext!,
              child: Obx(() => ReportUserDialog(
                    onSubmitTab: (data) {
                      hitApiToUserReported(
                          userId: userChatModel?.reciverDetail?.id,
                          reportId: data?.id);
                    },
                    onTab: (index) {
                      for (int i = 0; i < reportList!.length; i++) {
                        if (i == index) {
                          reportList![i].isSelected = true;
                        } else {
                          reportList![i].isSelected = false;
                        }
                      }

                      reportList!.refresh();
                    },
                    reportList: reportList?.value,
                  )));
        }
      });
    } on DioError catch (error) {
      Utils.hideLoader();
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  hitApiToUserReported({userId, reportId}) async {
    try {
      Utils.showLoader();
      await iAuthRepository?.userReported(
          map: {'report_to': userId, "report_type": reportId}).then((value) {
        Utils.hideLoader();
        Utils.showToast(message: value.message ?? "");
      });
    } on DioError catch (error) {
      Utils.hideLoader();
      if (error.response != null && error.response!.data != null) {
        Utils.showToast(message: error.response!.data['message']);
      }
    }
  }

  @override
  void onDetached() {
    audioPlayer.stop();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    stopAudioPlayer();
    await agoraEngine?.leaveChannel();
    agoraEngine?.release();
    
    super.dispose();
  }

  @override
  void onClose() {
    stopAudioPlayer();
   
    super.onClose();
  }
}
