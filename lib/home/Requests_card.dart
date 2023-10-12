// ignore_for_file: camel_case_types, file_names

import 'package:intl/intl.dart';

import '../untils/export_file.dart';

class Requests_Screen extends StatefulWidget {
  const Requests_Screen({super.key});

  @override
  State<Requests_Screen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<Requests_Screen> {
  Map Requestdata = {};

  bool isLoading = false;
  Future RequestListHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.employeehome();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      Requestdata = data["requests"];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    RequestListHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Requestdata["count"] == 0
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Leave Requests",
                    style: TextStyle(
                        fontSize: kSixteenFont,
                        fontWeight: kFW700,
                        color: KdarkText),
                  ),
                  SizedBox(width: 10.w),
                  CircleAvatar(
                     radius: 10.r,
                    backgroundColor: KOrange,
                    child: Text(
                      Requestdata.isNotEmpty
                          ? Requestdata["count"].toString()
                          : "-",
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: kFW600,
                          color: Kwhite),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 70.h,
                

                /// color: Kbackground,
                
                child: isLoading == false
                    ? ListView.builder(
                        itemCount: Requestdata["rows"].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(3.r),
                            padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                top: 10.h,
                                bottom: 10.h),
                            decoration: BoxDecoration(
                              color: Kwhite,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1.5,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                  color: Ktextcolor.withOpacity(0.25),
                                )
                              ],
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Ktextcolor.withOpacity(0.2),
                              //     blurRadius: 5,
                              //     offset: const Offset(0, 0),
                              //     spreadRadius: 1, //New
                              //   )
                              // ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        text: DateFormat.yMMMd()
                                            .format(DateTime.parse(
                                                Requestdata["rows"][index]
                                                    ["from_date"]))
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: kFW700,
                                            color: KdarkText),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: ' - ',
                                            style: TextStyle(
                                                fontSize: kSixteenFont,
                                                fontWeight: kFW700,
                                                color: KOrange),
                                          ),
                                          TextSpan(
                                            text: DateFormat.yMMMd()
                                                .format(DateTime.parse(
                                                    Requestdata["rows"][index]
                                                        ["to_date"]))
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: kFW700,
                                                color: KdarkText),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    CustomButton(
                                        fontSize: kTwelveFont,
                                        Color: Kgreen.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        Padding: EdgeInsets.only(
                                            left: 8.w,
                                            right: 8.w,
                                            top: 3.h,
                                            bottom: 3.h),
                                        textColor: Kgreen,
                                        label: Requestdata["rows"][index]
                                                ["leave_rejected_reason"] ??
                                            "",
                                        isLoading: false,
                                        onTap: () {})
                                  ],
                                ),
                                SizedBox(
                                  height: 5.w,
                                ),
                                RichText(
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: "leave type",
                                    style: TextStyle(
                                        fontSize: kFourteenFont,
                                        fontWeight: kFW400,
                                        color: Klightgray),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' - ',
                                        style: TextStyle(
                                            fontSize: kFourteenFont,
                                            fontWeight: kFW700,
                                            color: KOrange),
                                      ),
                                      TextSpan(
                                        text: Requestdata["rows"][index]
                                            ["leave_type"],
                                        style: TextStyle(
                                            fontSize: kFourteenFont,
                                            fontWeight: kFW700,
                                            color: Klightgray),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : const SpinKitWave(
                      color: KOrange,
                      size: 25,
                    )
              )
            ],
          );
  }
}
