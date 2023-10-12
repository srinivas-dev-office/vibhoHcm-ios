// ignore_for_file: camel_case_types, unused_element

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibeshr/untils/export_file.dart';

class Login_id extends StatefulWidget {
  const Login_id({super.key});

  @override
  State<Login_id> createState() => _Login_idState();
}

class Employeedata {
  String username = '';
  String password = '';
}

String _identifier = 'Unknown';

class _Login_idState extends State<Login_id> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool isLoading = false;

  Employeedata data = Employeedata();

  getFCMDid() async {
    String? token = await FirebaseMessaging.instance.getToken();
    UserSimplePreferences.setfcmToken(token);
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

  var errorString = "";
  Future employeeHandler() async {
    setState(() {
      errorString = "";
      isLoading = true;
    });
    Map payload = {
      "username": data.username,
      "password": data.password,
      "device_id": UserSimplePreferences.getuniquecode(),
      "fcm_token": UserSimplePreferences.getfcmToken(),
    };

    Map value = await Services.employeelogin(payload);
    if (value["message"] != null) {
      errorString = value["message"];
    } else {
      await UserSimplePreferences.setLoginStatus(loginStatus: true);
      await UserSimplePreferences.setUserdata(
          userData: json.encode(value["results"]));
      await UserSimplePreferences.setToken(token: value["Token"]);
      await UserSimplePreferences.setRefreshToken(
          refreshToken: "refresh_token");
      Get.toNamed(KBottom_navigation);
    }
    print(value);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getFCMDid();
    super.initState();
    passwordVisible = true;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Are you sure?',
              style: TextStyle(
                  fontSize: kEighteenFont,
                  fontWeight: kFW600,
                  color: Klightgray),
            ),
            content: Text(
              'Do you want to exit an App',
              style: TextStyle(
                  fontSize: 13.sp, fontWeight: kFW600, color: Klightgray),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: Text(
                  'No',
                  style: TextStyle(
                      fontSize: kTwelveFont,
                      fontWeight: kFW600,
                      color: KOrange),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                // <-- SEE HERE
                child: Text(
                  'Yes',
                  style: TextStyle(
                      fontSize: kTwelveFont,
                      fontWeight: kFW600,
                      color: KOrange),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Kwhite,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.r),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Image.asset(
                  "assets/images/logo_final.png",
                  width: 150.w,
                ),
                SizedBox(
                  height: 32.h,
                ),
                RichText(
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "Welcome to VIBHO",
                    style: TextStyle(
                        fontSize: kTwentyFont,
                        fontWeight: FontWeight.bold,
                        color: KdarkText),
                    children: <TextSpan>[
                      TextSpan(
                        text: "HCM",
                        style: TextStyle(
                            fontSize: kTwentyFont,
                            fontWeight: FontWeight.bold,
                            color: KOrange),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "Let’s start by entering your company’s VibhoHCM with Email & Password",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      height: 1.2.h,
                      fontSize: 11.sp,
                      fontWeight: kFW600,
                      color: Ktextcolor),
                ),
                SizedBox(
                  height: 40.h,
                ),
                /////TextFormFields
                TextFormField(
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(fontSize: 12.sp, fontWeight: kFW600),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 20.0, bottom: 6.0, top: 8.0),
                    // contentPadding: const EdgeInsets.symmetric(
                    //     vertical: 13.0, horizontal: 10.0),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 1),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    fillColor: Colors.grey,

                    hintText: "eg- email.VibhoHcm.com",

                    //make hint text
                    hintStyle: TextStyle(
                      color: Klightgray.withOpacity(0.5),
                      fontSize: kTenFont,
                      fontWeight: FontWeight.w700,
                    ),

                    //create lable
                    labelText: 'Username',
                    //lable style
                    labelStyle: TextStyle(
                      color: Klightgray,
                      fontSize: kTwelveFont,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  validator: (value) {
                    (input) =>
                        input.isValidEmail() ? null : "Check your email";
                    if (value!.isEmpty) {
                      return 'Please enter Email id';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    data.username = value;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 12.sp, fontWeight: kFW600),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,

                  obscuringCharacter: '●',
                  // style: TextStyle(fontSize: 20),
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    focusColor: Colors.white,

                    contentPadding: const EdgeInsets.only(
                        left: 20.0, bottom: 6.0, top: 8.0),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 1),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Ktextcolor, width: 0.5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    fillColor: Colors.grey,

                    hintText: "**************",

                    //make hint text
                    hintStyle: TextStyle(
                      color: Klightgray.withOpacity(0.5),
                      fontSize: kTwelveFont,
                      fontWeight: FontWeight.w700,
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),

                    //create lable
                    labelText: 'Password',
                    //lable style
                    labelStyle: TextStyle(
                      color: Klightgray,
                      fontSize: kTwelveFont,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    data.password = value;
                  },
                ),

                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                    width: 200.w,
                    child: Divider(
                      color: Ktextcolor.withOpacity(0.5),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(errorString,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            height: 1.0.h,
                            fontSize: 8.sp,
                            // fontWeight: kFW600,
                            color: KRed)),
                  ),
                ),
                SizedBox(
                  height: 220.h,
                ),
                isLoading
                    ? const Center(
                            child: SpinKitWave(
                            color: KOrange,
                            size: 15,
                          ))
                    : CustomButton(
                        height: 35.h,
                        width: double.infinity,
                        textColor: Kwhite,
                        borderRadius: BorderRadius.circular(20.r),
                        Color: KOrange,
                        fontSize: kFourteenFont,
                        fontWeight: kFW600,
                        label: "Login",
                        isLoading: false,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await employeeHandler();
                          }
                        })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
