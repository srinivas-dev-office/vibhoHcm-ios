import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'firebase_options.dart';
import 'untils/export_file.dart';
import 'untils/routes.dart';

String _identifier = 'Unknown';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initFirebase();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UserSimplePreferences.init();
  //HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  UserSimplePreferences.setfcmToken(token);
  print("FCM token${token}");
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  @override
  void initState() {
    super.initState();
    
    getConnectivity();
    initUniqueIdentifierState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;
    UserSimplePreferences.setuniquecode(identifier);
    setState(() {
      _identifier = identifier;
    });
  }
// void _checkVersion() async {
//     final newVersion = NewVersion(
//       androidId: "com.snapchat.android",
//     );
//     final status = await newVersion.getVersionStatus();
//     newVersion.showUpdateDialog(
//       context: context,
//       versionStatus: status,
//       dialogTitle: "UPDATE!!!",
//       dismissButtonText: "Skip",
//       dialogText: "Please update the app from " + "${status.localVersion}" + " to " + "${status.storeVersion}",
//       dismissAction: () {
//         SystemNavigator.pop();
//       },
//       updateButtonText: "Lets update",
//     );

//     print("DEVICE : " + status.localVersion);
//     print("STORE : " + status.storeVersion);
//   }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Vibho HCM',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Objectivity',
          ),
          getPages: Routes.routes,
          initialRoute: kSplashPage,
        );
      },
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
