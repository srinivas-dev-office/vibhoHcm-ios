// ignore_for_file: camel_case_types, depend_on_referenced_packages

import '../untils/export_file.dart';

class Notification_screen extends StatefulWidget {
  const Notification_screen({super.key});

  @override
  State<Notification_screen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notification_screen> {
  Map notifiydata = {};
  bool isLoading = false;
  Future notifiyHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.notification();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      notifiydata = data;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    notifiyHandler();
    super.initState();
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        UserSimplePreferences.setNotificationStatus(status: true);
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
    } else {
      setState(() {
        isSwitched = false;
        UserSimplePreferences.setNotificationStatus(status: false);
        textValue = 'Switch Button is OFF';
      });
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kbackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Kwhite,
          titleSpacing: 0,
          // actions: [
          //   Padding(
          //     padding: EdgeInsets.only(right: 0.w, top: 5.h),
          //     child: GestureDetector(
          //       onTap: () {
          //         Get.toNamed(KNotification);
          //       },
          //       child: Row(
          //         children: [
          //           Text(
          //             "",
          //             style: TextStyle(
          //                 fontSize: 11.sp, color: KOrange, fontWeight: kFW600),
          //           ),
          //           Switch(
          //             onChanged: toggleSwitch,
          //             value: UserSimplePreferences.getNotificationStatus() ??
          //                 isSwitched,
          //             activeColor: KOrange,
          //             activeTrackColor: KOrange.withOpacity(0.8),
          //             inactiveThumbColor: Klightgray,
          //             inactiveTrackColor: Klightgray.withOpacity(0.5),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ],
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 23.w,
              color: KdarkText,
            ),
          ),
          title: Text(
            "Notification",
            style: TextStyle(
              fontSize: kSixteenFont,
              fontWeight: kFW700,
              color: KdarkText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body:
            // UserSimplePreferences.getNotificationStatus() ??
            //         isSwitched == true

            isLoading == false
                ? notifiydata["rows"].length == 0
                    ? Center(
                        child: Column(
                        children: [
                          SvgPicture.asset("assets/images/oopsNoData.svg",
                              // color: KOrange,
                              fit: BoxFit.fill,
                              semanticsLabel: 'No Data'),
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "No Notifications Found",
                            style: TextStyle(
                                fontWeight: kFW700, fontSize: kTwentyFont),
                          )
                        ],
                      ))
                    : Container(
                        margin: EdgeInsets.all(13.r),
                        child: ListView.builder(
                          itemCount: notifiydata["rows"].length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              direction: DismissDirection.horizontal,
                              background: Container(
                                color: KOrange,
                              ),
                              secondaryBackground: Container(
                                color: KRed.withOpacity(0.8),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Kwhite),
                                    ),
                                  ),
                                ),
                              ),
                              // onDismissed: (DismissDirection direction) {
                              //   setState(() {
                              //     notifiydata["rows"].removeAt(index);
                              //   });
                              // },
                              key: Key(notifiydata["rows"][index]["employee_id"]
                                  .toString()),
                              child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10.r),
                                    margin: EdgeInsets.only(top: 10.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.r),
                                      color: Kwhite,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notifiydata["rows"] != null
                                              ? parse(notifiydata["rows"][index]
                                                      ["Notification"]["title"])
                                                  .body!
                                                  .text
                                              : "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 13.spMax,
                                              fontWeight: kFW800,
                                              color: KdarkText),
                                        ),
                                        SizedBox(
                                          height: 7.w,
                                        ),
                                        Text(
                                          notifiydata["rows"] != null
                                              ? parse(notifiydata["rows"][index]
                                                          ["Notification"]
                                                      ["message"])
                                                  .body!
                                                  .text
                                              : "",
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: kTwelveFont,
                                              fontWeight: kFW600,
                                              color:
                                                  Klightblack.withOpacity(0.9)),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ),
                      )
                : const Center(
                    child: SpinKitWave(
                    color: KOrange,
                    size: 15,
                  ))
        // : const SizedBox()
        );
  }
}
