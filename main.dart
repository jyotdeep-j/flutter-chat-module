Socket? socket;

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  NotificationHandler().initNotifications();
  SocketConnect().initSocket();
  await GetStorage.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: false,
      // designSize: const Size(430, 932),
      builder: (context, widget) {
        return GestureDetector(
          onTap: () {
            GetUtils;
            FocusManager.instance.primaryFocus!.unfocus();
            TextEditingController().clear();
          },
          child: GetMaterialApp(

              navigatorObservers: [AudioPlayerObserver(audioPlayer)],
              builder: EasyLoading.init(),
              title: Strings.appName,
              locale: const Locale("en"),
              getPages: AppRoutes.routes,
              theme: ThemeData(fontFamily: FontFamily.sfFontFamily),
              debugShowCheckedModeBanner: false,
              initialRoute: GetStorage().read(StorageKeys.tokenKeys) == null
                  ? initialRoute
                  : AppPages.dashboard),
        );
      },
    );
  }
}
