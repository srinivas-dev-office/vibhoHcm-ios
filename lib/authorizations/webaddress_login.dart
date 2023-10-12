// ignore_for_file: camel_case_types

import '../untils/export_file.dart';

class Web_Address extends StatefulWidget {
  const Web_Address({super.key});

  @override
  State<Web_Address> createState() => _Web_AddressState();
}

class WebAddress {
  String url = "";
}

class _Web_AddressState extends State<Web_Address> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  WebAddress data = WebAddress();
  Future webAddressHandler() async {
    setState(() {
      isLoading = true;
    });
    Map payload = {
      "url": "${data.url}.vibhohcm.com",
    };

    Map value = await Services.checkDomain(payload);
    if (value["status"] != null && value["status"] != "") {
      setState(() {
        KWebURL = "https://${data.url}.vibhohcm.com";
        UserSimplePreferences.setWebUrl(
            userData: "https://${data.url}.vibhohcm.com");

        kDEVURL = "${value["status"]["api"]["apilink"]}/api";
        UserSimplePreferences.setDevUrl(
            userData: "${value["status"]["api"]["apilink"]}/api");
        UserSimplePreferences.setCurrency(
            money: value["status"]["api"]["currency"]);
      });
      Get.toNamed(KLogin_id);
    } else {
      Fluttertoast.showToast(msg: value["message"]);
    }

    setState(() {
      isLoading = false;
    });
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Kwhite,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   elevation: 0,
        //   backgroundColor: Kwhite,
        // ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.r),
            child: Form(
              key: _formKey,
              child: Column(
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
                      text: "Welcome to  VIBHO",
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
                    "Let’s start by entering your company’s VibhoHCM web address",
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
                    style: TextStyle(fontSize: kTwelveFont, fontWeight: kFW600),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      contentPadding: const EdgeInsets.only(
                          left: 20.0, bottom: 6.0, top: 8.0),
                      // contentPadding: const EdgeInsets.symmetric(
                      //     vertical: 13.0, horizontal: 12.0),

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

                      hintText: "yourcompany",
                      suffix: Padding(
                        padding: EdgeInsets.only(top: 3.h, right: 10.w),
                        child: Text(
                          ".vibhohcm.com",
                          style: TextStyle(
                            color: Klightgray.withOpacity(0.7),
                            fontSize: kTwelveFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      //make hint text
                      hintStyle: TextStyle(
                        color: Klightgray.withOpacity(0.5),
                        fontSize: kTenFont,
                        fontWeight: FontWeight.w600,
                      ),

                      //create lable
                      labelText: 'Web address',
                      //lable style
                      labelStyle: TextStyle(
                        color: Klightgray,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text ';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      setState(() {
                        data.url = value;
                      });
                    },
                  ),
                  // SizedBox(
                  //   height: 30.h,
                  // ),
                  // Text("Find your company by email or phone number",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //         fontSize: kTenFont,
                  //         fontWeight: kFW600,
                  //         color: KOrange)),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                      width: 200.w,
                      child: Divider(
                        color: Ktextcolor.withOpacity(0.5),
                      )),
                  SizedBox(
                    height: 220.h,
                  ),
                  isLoading == false
                      ? CustomButton(
                          height: 35.h,
                          width: double.infinity,
                          textColor: Kwhite,
                          borderRadius: BorderRadius.circular(20.r),
                          Color: KOrange,
                          fontSize: kFourteenFont,
                          fontWeight: kFW600,
                          label: "Next",
                          isLoading: false,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              webAddressHandler();
                            }
                          })
                      : const SpinKitWave(
                          color: KOrange,
                          size: 25,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
