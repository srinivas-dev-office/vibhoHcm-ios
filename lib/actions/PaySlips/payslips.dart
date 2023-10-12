// ignore_for_file: camel_case_types, unused_local_variable

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibeshr/actions/Time_sheet/timeSheetWebView.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibeshr/actions/Time_sheet/timeSheetWebView.dart';
import 'dart:io' as io;

import '../../untils/export_file.dart';

class PaySlips_view extends StatefulWidget {
  const PaySlips_view({super.key});

  @override
  State<PaySlips_view> createState() => _PaySlips_viewState();
}

class _PaySlips_viewState extends State<PaySlips_view> {
  DateTime? selectedDate;

  Map payslipdata = {};
  Map ctcdata = {};

  bool isLoading = false;
  Future payslipListHandler(DateTime selectedDate) async {
    payslipdata = {};
    ctcdata = {};
    setState(() {
      isLoading = true;
    });
    Map data = await Services.payslipview(selectedDate);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      payslipdata = data["paslip"];
      //  ctcdata = data["ctc"];
      ctcdata = data["ctc"] ?? {};
    }
    setState(() {
      isLoading = false;
    });
  }

// "payslip_file_path"
  //SA payslip pdf
  Map payslipdatasa = {};
  Map ctcdatasa = {};

  Future payslipListSAHandler(DateTime selectedDate) async {
    payslipdatasa = {};
    ctcdatasa = {};
    setState(() {
      isLoading = true;
    });
    Map data = await Services.payslipviewsa(selectedDate);

    if (data["rows"] == null) {
      payslipdatasa = data;
      // Fluttertoast.showToast(
      //   msg: data["message"],
      // );
    } else {
      payslipdatasa = data;
      // payslipdatasa = data["paslip"];
      // //  ctcdata = data["ctc"];
      // ctcdatasa = data["ctc"] ?? {};
    }
    setState(() {
      isLoading = false;
    });
  }

  //

  Map profile = {};
  Future getProfile() async {
    profile = await Services.employeeprofile();
    selectedDate = DateTime.now().subtract(const Duration(days: 30));
    payslipListHandler(selectedDate!);
  }

  var downloading = false.obs;
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      appBar: const VibhoAppBar(
        bColor: Kwhite,
        title: 'Payslips',
        dontHaveBackAsLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(13.r),
            margin: EdgeInsets.all(13.r),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                  color: Ktextcolor.withOpacity(0.2),
                )
              ],
              borderRadius: BorderRadius.circular(10.r),
              color: Kwhite,
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Month & Year",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: KOrange.withOpacity(0.7),
                  ),
                ),

                // Container(
                //   alignment: Alignment.center,
                //   height: 40,
                //   width: 260.w,
                //   margin: EdgeInsets.all(13.r),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(13.r),
                //     color: Kbackground,
                //   ),
                //   child: ListView.builder(
                //       itemCount: items.length,
                //       scrollDirection: Axis.horizontal,
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         return Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             GestureDetector(
                //               onTap: () {
                //                 setState(() {
                //                   current = index;
                //                 });
                //               },
                //               child: AnimatedContainer(
                //                 margin: EdgeInsets.only(left: 10.w),
                //                 padding: EdgeInsets.only(
                //                     left: 10.w,
                //                     right: 12.w,
                //                     top: 5.h,
                //                     bottom: 5.h),
                //                 duration: const Duration(milliseconds: 300),
                //                 child: Text(
                //                   items[index],
                //                   style: TextStyle(
                //                     fontSize: current == index
                //                         ? kFourteenFont
                //                         : kTwelveFont,
                //                     fontWeight:
                //                         current == index ? kFW900 : kFW500,
                //                     color:
                //                         current == index ? KOrange : Klightgray,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         );
                //       }),
                // ),
                GestureDetector(
                  onTap: () async {
                    showMonthPicker(
                      backgroundColor: Kwhite,
                      selectedMonthBackgroundColor: KOrange.withOpacity(0.5),
                      roundedCornersRadius: 10,
                      headerColor: KOrange,
                      unselectedMonthTextColor: Ktextcolor,
                      context: context,
                      initialDate: DateTime.now(),
                      confirmWidget: Text(
                        "OK",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: KOrange.withOpacity(0.7),
                        ),
                      ),
                      cancelWidget: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: KOrange.withOpacity(0.7),
                        ),
                      ),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          if (selectedDate != null) {
                            // payslipListSAHandler(selectedDate!);
                            payslipListHandler(selectedDate!);
                          }
                        });
                      }
                    });
                  },
                  child: Image.asset(
                    "assets/images/Group.png",
                    width: 23.w,
                  ),
                )
              ],
            ),
          ),
          payslipdata["payslip_file_path"] != ""
              //payslipdata["payslip_file_path"] == ""
              //  payslipdata.isEmpty
              ? Column(
                  children: [
                    ////Payslip for month
                    isLoading == false
                        ? payslipdata.isNotEmpty
                            ? Container(
                                margin: EdgeInsets.all(13.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Kwhite,
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                8.roundToDouble())),
                                        child: Image.asset(
                                          "assets/images/buble.png",
                                          width: 80.w,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 10.w, bottom: 8.h),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Payslip",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: kTwelveFont,
                                                fontWeight: kFW600,
                                                color: Klightblack),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            "Payslip Available for ${DateFormat('yyyy-MMM').format(selectedDate!)}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: kFW700,
                                                color: KdarkText),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              payslipdata["payslip_file_path"] !=
                                                      ""
                                                  // payslipdata["PayrollProcess"] !=
                                                  //         null
                                                  ? Custom_OutlineButton(
                                                      height: 28.h,
                                                      width: 120.w,
                                                      textColor: KOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                      Color: KOrange,
                                                      label: "View More",
                                                      fontSize: kTenFont,
                                                      fontWeight: kFW600,
                                                      isLoading: false,
                                                      onTap: () {
                                                        Get.toNamed(
                                                            KPayslips_Detail,
                                                            arguments: {
                                                              "payslip":
                                                                  payslipdata,
                                                              "ctc": ctcdata,
                                                              "route": "payslip"
                                                            });
                                                      })
                                                  : SizedBox(),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              // payslipdata["payslip_file_path"] !=
                                              //         ""
                                              //     // payslipdata["PayrollProcess"] !=
                                              //     //         null
                                              //     ? CustomButton(
                                              //         height: 28.h,
                                              //         width: 120.w,
                                              //         textColor: Kwhite,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 8.r),
                                              //         Color: KOrange,
                                              //         fontSize: kTenFont,
                                              //         fontWeight: kFW600,
                                              //         label: "Download",
                                              //         isLoading: false,
                                              //         onTap: () async {
                                              //           // Map<Permission,
                                              //           //         PermissionStatus>
                                              //           //     statuses = await [
                                              //           //   Permission.storage,
                                              //           //   //add more permission to request here.
                                              //           // ].request();

                                              //           // if (statuses[Permission
                                              //           //         .storage]!
                                              //           //     .isGranted) {
                                              //           var dir =
                                              //               await DownloadsPathProvider
                                              //                   .downloadsDirectory;
                                              //           if (dir != null) {
                                              //             String savename =
                                              //                 "file.pdf";
                                              //             String savePath =
                                              //                 dir.path +
                                              //                     "/$savename";
                                              //             print(savePath);
                                              //             //output:  /storage/emulated/0/Download/banner.png

                                              //             try {
                                              //               await Dio().download(
                                              //                   "$KSubDomainURL/assets/payslips/${payslipdata['payslip_file_path']}",
                                              //                   savePath,
                                              //                   onReceiveProgress:
                                              //                       (received,
                                              //                           total) {
                                              //                 if (total != -1) {
                                              //                   print((received /
                                              //                               total *
                                              //                               100)
                                              //                           .toStringAsFixed(
                                              //                               0) +
                                              //                       "%");
                                              //                   //you can build progressbar feature too
                                              //                 }
                                              //               });
                                              //               print(
                                              //                   "File is saved to download folder.");
                                              //             } on DioError catch (e) {
                                              //               print(e.message);
                                              //             }
                                              //           }
                                              //           // } else {
                                              //           //   print(
                                              //           //       "No permission to read and write.");
                                              //           // }
                                              //           // Get.to(TimeSheetWebView(
                                              //           //     url:
                                              //           //         "$KSubDomainURL/assets/payslips/${payslipdata['payslip_file_path']}",
                                              //           //     // "$KSubDomainURL/welcome/payslip_download_post/${profile["emp_id"]}/${payslipdata["payslip_id"]}/${payslipdata["payroll_process_id"]}",
                                              //           //     name:
                                              //           //         "Payslip - ${payslipdata["month"]} - ${payslipdata["year"]}"
                                              //           //     // name:
                                              //           //     //     "Payslip",
                                              //           //     ));
                                              //           // //Get.toNamed(KPayslips_Detail);
                                              //         })
                                              //     : SizedBox(),
                                              // SizedBox(
                                              //   width: 10.w,
                                              // ),
                                              payslipdata["payslip_file_name"] ==
                                                      null
                                                  ? SizedBox()
                                                  : payslipdata[
                                                              "payslip_file_path"] !=
                                                          ""
                                                      // payslipdata["PayrollProcess"] !=
                                                      //         null
                                                      ? CustomButton(
                                                          height: 28.h,
                                                          width: 120.w,
                                                          textColor: Kwhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                          Color: KOrange,
                                                          fontSize: kTenFont,
                                                          fontWeight: kFW600,
                                                          label: "Download",
                                                          isLoading: false,
                                                          onTap: () async {
                                                            var dir =
                                                                await DownloadsPathProvider
                                                                    .downloadsDirectory;
                                                            if (dir != null) {
                                                              String savename =
                                                                  payslipdata[
                                                                      "payslip_file_name"];
                                                              // String savePath = dir.path + "/$savename";

                                                              // String savename = "${widget.name}.pdf";
                                                              String savePath =
                                                                  "${dir.path}/(1)$savename";
                                                              print(savePath);
                                                              bool isExist =
                                                                  await io.File(
                                                                          savePath)
                                                                      .exists();
                                                              int i = 0;
                                                              if (isExist) {
                                                                while (
                                                                    isExist) {
                                                                  i = i + 1;
                                                                  savePath =
                                                                      "${dir.path}/($i)$savename";
                                                                  isExist = await io
                                                                          .File(
                                                                              savePath)
                                                                      .exists();
                                                                  io.File(savePath)
                                                                      .existsSync();
                                                                }
                                                              }

                                                              try {
                                                                downloading(
                                                                    true);
                                                                await Dio().download(
                                                                    "$KSubDomainURL/assets/payslips/${payslipdata['payslip_file_path']}",
                                                                    savePath,
                                                                    onReceiveProgress:
                                                                        (received,
                                                                            total) {
                                                                  if (total !=
                                                                      -1) {
                                                                    print((received /
                                                                                total *
                                                                                100)
                                                                            .toStringAsFixed(0) +
                                                                        "%");
                                                                  }
                                                                });
                                                                print(
                                                                    "File is saved to download folder.");
                                                                downloading(
                                                                    false);
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "File is saved to $savePath",
                                                                );
                                                              } on DioError catch (e) {
                                                                print(
                                                                    e.message);
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "File Not Saved",
                                                                );
                                                              }
                                                              downloading(
                                                                  false);
                                                            }
                                                            // Get.to(TimeSheetWebView(
                                                            //   url:
                                                            //       "$KSubDomainURL/welcome/payslip_download_post/${payslipdata["emp_id"]}/${payslipdata["payslip_id"]}/${payslipdata["payroll_process_id"]}",
                                                            //   name: "Payslip",
                                                            // ));
                                                            // downloadAPI();
                                                          },
                                                        )
                                                      : SizedBox()
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                            : Center(
                                child: Column(
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/oopsNoData.svg",
                                      // color: KOrange,
                                      fit: BoxFit.fill,
                                      semanticsLabel: 'No Data'),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Oops! No Data Found",
                                    style: TextStyle(
                                        fontWeight: kFW700,
                                        fontSize: kTwentyFont),
                                  )
                                ],
                              ))
                        : const Center(
                            child: SpinKitWave(
                            color: KOrange,
                            size: 15,
                          )),
                    ////Reimbursement Payslip
                    // payslipdata!=null?
                    // payslipdata.isNotEmpty
                    //     ? Container(
                    //         margin: EdgeInsets.all(13.r),
                    //         width: double.infinity,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10.r),
                    //           color: Kwhite,
                    //         ),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Align(
                    //               alignment: Alignment.topRight,
                    //               child: ClipRRect(
                    //                 borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(8.roundToDouble())),
                    //                 child: Image.asset(
                    //                   "assets/images/buble.png",
                    //                   width: 80.w,
                    //                 ),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: EdgeInsets.only(
                    //                   left: 20.w, right: 10.w, bottom: 15.h),
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     "Reimbursement Payslip",
                    //                     maxLines: 2,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         fontSize: kTwelveFont,
                    //                         fontWeight: kFW600,
                    //                         color: Klightblack),
                    //                   ),
                    //                   SizedBox(
                    //                     height: 40.h,
                    //                   ),
                    //                   Text(
                    //                     "No payslip found for the selected month",
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         fontSize: kTenFont,
                    //                         fontWeight: kFW600,
                    //                         color: Klightblack),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ))
                    //     : const SizedBox():SizedBox(),
                    /////CTC per Years
                    ///
                    ctcdata.isNotEmpty
                        ? //   ctcdata["CTC"] != null
                        ctcdata["payslip_file_path"] != ""
                            ? Container(
                                margin: EdgeInsets.all(13.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Kwhite,
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                8.roundToDouble())),
                                        child: Image.asset(
                                          "assets/images/buble.png",
                                          width: 80.w,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 10.w, bottom: 8.h),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "CTC Payslip",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: kTwelveFont,
                                                fontWeight: kFW600,
                                                color: Klightblack),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            ctcdata["CTC"] != null
                                                ? ctcdata["CTC"].toString()
                                                : "No data Found",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: kFW700,
                                                color: KdarkText),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Custom_OutlineButton(
                                                  height: 28.h,
                                                  width: 120.w,
                                                  textColor: KOrange,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  Color: KOrange,
                                                  label: "View More",
                                                  fontSize: kTenFont,
                                                  fontWeight: kFW600,
                                                  isLoading: false,
                                                  onTap: () {
                                                    Get.toNamed(
                                                        KPayslips_Detail,
                                                        arguments: {
                                                          "payslip":
                                                              payslipdata,
                                                          "ctc": ctcdata,
                                                          "route": "CTC"
                                                        });
                                                  }),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              // CustomButton(
                                              //     height: 28.h,
                                              //     width: 120.w,
                                              //     textColor: Kwhite,
                                              //     borderRadius: BorderRadius.circular(8.r),
                                              //     Color: KOrange,
                                              //     fontSize: kTenFont,
                                              //     fontWeight: kFW600,
                                              //     label: "Download",
                                              //     isLoading: false,
                                              //     onTap: () {})
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                            : const SizedBox()
                        : const SizedBox()
                  ],
                )
              // : SizedBox()
              : Center(
                  child: Column(
                  children: [
                    SvgPicture.asset("assets/images/oopsNoData.svg",
                        // color: KOrange,
                        fit: BoxFit.fill,
                        semanticsLabel: 'No Data'),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Oops! No Data Found",
                      style:
                          TextStyle(fontWeight: kFW700, fontSize: kTwentyFont),
                    )
                  ],
                ))
        ],
      ),
    );
  }
}
