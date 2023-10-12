// ignore_for_file: camel_case_types, unused_local_variable, unnecessary_string_interpolations

import 'package:intl/intl.dart';

import '../untils/export_file.dart';

class Login_time extends StatefulWidget {
  Map? homedir;
  Login_time({super.key, this.homedir});

  @override
  State<Login_time> createState() => _LogintimeState();
}

class _LogintimeState extends State<Login_time> {
  //////
  bool isLoading = false;
  Future attendancesHandler(String type) async {
    setState(() {
      isLoading = true;
    });
    if (type == "in") {
      widget.homedir!["checkin_checkout"]["check_in"]["status"] = true;
      widget.homedir!["checkin_checkout"]["check_out"]["status"] = false;
    } else {
      widget.homedir!["checkin_checkout"]["check_in"]["status"] = false;
      widget.homedir!["checkin_checkout"]["check_out"]["status"] = true;
    }

    Map payload = {"type": type};

    Map value = await Services.checkin(payload);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {}

    setState(() {
      isLoading = false;
    });
  }

  final String DATE = 'assets/images/date.svg';
  final String LOCATION = 'assets/images/location.svg';
  @override
  Widget build(BuildContext context) {
    ////
    ServiceController serviceController = Get.put(ServiceController());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm a').format(now);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Kwhite,
            boxShadow: [
              BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 6),
                color: Ktextcolor.withOpacity(0.2),
              )
            ],
            // boxShadow: [
            //   BoxShadow(
            //     color: Ktextcolor.withOpacity(0.5),
            //     blurRadius: 10,
            //     offset: const Offset(0, 0),
            //     spreadRadius: 2,
            //   )
            // ],
            borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          children: [
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Kwhite,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      topRight: Radius.circular(8.r)),
                  child: const Google_map()),
            ),
            Container(
              padding: EdgeInsets.all(13.r),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        //DateFormat('hh:mm a').format(DateTime.now()),

                        "${TimeOfDay.fromDateTime(DateTime.now()).format(context)} ",
                        style: TextStyle(
                            fontSize: kTwentyFont,
                            fontWeight: kFW600,
                            color: KdarkText),
                      ),
                      isLoading == false
                          ? widget.homedir != null
                              ?
                              // ? (widget.homedir!["checkin_checkout"]
                              //                 ["check_out"]["status"] ==
                              //             true &&
                              //         widget.homedir!["checkin_checkout"]
                              //                 ["check_in"]["status"] ==
                              //             true)
                              //     ? CustomButton(
                              //         Color: KOrange,
                              //         fontWeight: kFW600,
                              //         fontSize: 13.sp,
                              //         borderRadius: BorderRadius.circular(5.r),
                              //         Padding: EdgeInsets.only(
                              //             left: 20.w,
                              //             right: 20.w,
                              //             top: 6.h,
                              //             bottom: 6.h),
                              //         label: "Check In",
                              //         //  "Check-In",
                              //         textColor: Kwhite,
                              //         isLoading: false,
                              //         onTap: () {
                              //           attendancesHandler("in");
                              //         })
                              //     :
                              CustomButton(
                                  Color: KOrange,
                                  fontWeight: kFW600,
                                  fontSize: 13.sp,
                                  borderRadius: BorderRadius.circular(5.r),
                                  Padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                      top: 6.h,
                                      bottom: 6.h),
                                  label: widget.homedir!["checkin_checkout"]
                                              ["check_out"]["status"] !=
                                          true
                                      ? widget.homedir!["checkin_checkout"]
                                                  ["check_in"]["status"] ==
                                              true
                                          ? "Check Out"
                                          : "Check In"
                                      : "Done",
                                  //  "Check-In",
                                  textColor: Kwhite,
                                  isLoading: false,
                                  onTap: () {
                                    widget.homedir!["checkin_checkout"]
                                                ["check_out"]["status"] !=
                                            true
                                        ? widget.homedir!["checkin_checkout"]
                                                    ["check_in"]["status"] ==
                                                true
                                            ? attendancesHandler("out")
                                            : attendancesHandler("in")
                                        : null;
                                  })
                              : const SizedBox()
                          : const Center(
                              child: SpinKitWave(
                              color: KOrange,
                              size: 15,
                            ))
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(DATE,
                          color: KCustomDarktwo, semanticsLabel: 'Acme Logo'),
                      // Image.asset(
                      //   "assets/images/date.svg",
                      //   //  color: KCustomDarktwo
                      // ),
                      SizedBox(
                        width: 8.w,
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text:
                              "${DateFormat.MMMd().format(DateTime.now())} | ",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: kFW500,
                              color: KCustomDark),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${DateFormat.E().format(DateTime.now())} ',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: kFW500,
                                  color: KCustomDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() => serviceController.address.value == ""
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "No Location Address Found",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW700,
                                color: KCustomDark),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(LOCATION,
                                color: KCustomDarktwo,
                                semanticsLabel: 'Acme Logo'),
                            //  Image.asset("assets/images/location.svg"),
                            SizedBox(
                              width: 8.w,
                            ),

                            SizedBox(
                                width: 250.w,
                                child: Text(
                                  serviceController.address.value,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: kTwelveFont,
                                      fontWeight: kFW400,
                                      height: 1.2,
                                      color: KCustomDarktwo),
                                )),
                          ],
                        )),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.homedir!["checkin_checkout"]["check_in"]["time"] !=
                              null
                          ? Text(
                              "Check-in:${DateFormat('hh :mm aaa').format(DateTime.parse(widget.homedir!["checkin_checkout"]["check_in"]["time"].toString()))}",
                              style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: KdarkText,
                                  fontWeight: kFW600),
                            )
                          : SizedBox(),
                      widget.homedir!["checkin_checkout"]["check_out"]
                                  ["time"] !=
                              null
                          ? Text(
                              "Check-out:${DateFormat('hh :mm aaa').format(DateTime.parse(widget.homedir!["checkin_checkout"]["check_out"]["time"].toString()))}",
                              style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: KdarkText,
                                  fontWeight: kFW600),
                            )
                          : SizedBox(),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
