class SocketConnect{
initSocket() async {
  socket = io(
      Constants.socketUrl,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connectionoptional
          .build());
  socket?.connect();
  socket?.onConnect((data) {
    print("socket connected ");
  });
  print("check socket connected ${socket?.connected}");

  socket!.onerror((error) {
    print("check socket connected error ${error?.toString()}");
  });
}
}
