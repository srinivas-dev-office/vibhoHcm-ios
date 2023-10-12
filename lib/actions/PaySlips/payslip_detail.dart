// ignore_for_file: camel_case_types, unused_local_variable
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibeshr/actions/Time_sheet/timeSheetWebView.dart';
import 'dart:io' as io;

import '../../untils/export_file.dart';

class PaySlips_details extends StatefulWidget {
  const PaySlips_details({super.key});

  @override
  State<PaySlips_details> createState() => _PaySlips_detailsState();
}

class _PaySlips_detailsState extends State<PaySlips_details> {
  String fileurl = "https://fluttercampus.com/sample.pdf";
  DateTime? selectedDate;
  Map profile = {};
  var payslipdata = Get.arguments["payslip"];
  var ctcdata = Get.arguments["ctc"];
  bool clciked = Get.arguments["route"] == "payslip" ? true : false;

  String getdecuctionPrices(List priceCal, String type) {
    num price = 0;
    for (int i = 0; i < priceCal.length; i++) {
      if (type == "D") {
        if (priceCal[i]["type"] == "Deductions") {
          price = price + priceCal[i]["amount"];
        }
      } else {
        if (priceCal[i]["type"] == "Earnings") {
          price = price + priceCal[i]["amount"];
        }
      }
    }

    return price.toString();
  }

  bool isLoading = false;
  downloadAPI() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.downloadpayslipview(
        DateTime.parse("2024-05-01"), "Payslip");
    profile = await Services.employeeprofile();

    download(data);

    setState(() {
      isLoading = false;
    });
  }

  download(Map data) {
    getApplicationSupportDirectory().then((value) {});
  }

  var downloading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: payslipdata["payslip_file_name"] == null
          ? SizedBox()
          // payslipdata
          : clciked == false
              ? const SizedBox()
              : Obx(() => CustomButton(
                    margin: EdgeInsets.all(10.r),
                    borderRadius: BorderRadius.circular(20.r),
                    Color: KOrange,
                    height: 40.h,
                    label: downloading.value == false
                        ? "Download Payslip"
                        : "Downloading...",
                    textColor: Kwhite,
                    fontWeight: kFW900,
                    fontSize: 13.sp,
                    isLoading: false,
                    onTap: () async {
                      var dir = await DownloadsPathProvider.downloadsDirectory;
                      if (dir != null) {
                        String savename = payslipdata["payslip_file_name"];

                        // String savePath = dir.path + "/$savename";

                        // String savename = "${widget.name}.pdf";
                        String savePath = "${dir.path}/(1)$savename";
                        print(savePath);
                        bool isExist = await io.File(savePath).exists();
                        int i = 0;
                        if (isExist) {
                          while (isExist) {
                            i = i + 1;
                            savePath = "${dir.path}/($i)$savename";
                            isExist = await io.File(savePath).exists();
                            io.File(savePath).existsSync();
                          }
                        }

                        try {
                          downloading(true);
                          await Dio().download(
                              "$KSubDomainURL/assets/payslips/${payslipdata['payslip_file_path']}",
                              savePath, onReceiveProgress: (received, total) {
                            if (total != -1) {
                              print(
                                  (received / total * 100).toStringAsFixed(0) +
                                      "%");
                            }
                          });
                          print("File is saved to download folder.");
                          downloading(false);
                          Fluttertoast.showToast(
                            msg: "File is saved to $savePath",
                          );
                        } on DioError catch (e) {
                          print(e.message);
                          Fluttertoast.showToast(
                            msg: "File Not Saved",
                          );
                        }
                        downloading(false);
                      }
                      // Get.to(TimeSheetWebView(
                      //   url:
                      //       "$KSubDomainURL/welcome/payslip_download_post/${payslipdata["emp_id"]}/${payslipdata["payslip_id"]}/${payslipdata["payroll_process_id"]}",
                      //   name: "Payslip",
                      // ));
                      // downloadAPI();
                    },
                  )),
      backgroundColor: Kbackground,
      appBar: const VibhoAppBar(
        bColor: Kbackground,
        title: 'Payslips',
        dontHaveBackAsLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(13.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),

              ///Earing
              payslipdata["PayrollProcessEarningsDeductions"].length > 0
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r)),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.r)),
                        color: Kgreen.withOpacity(0.15),
                        child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "Earnings",
                                    style: TextStyle(
                                      fontSize: kTwelveFont,
                                      fontWeight: kFW600,
                                      color: Klightblack,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    UserSimplePreferences.getCurrency() == "INR"
                                        ? "₹ ${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "E")}"
                                        //  ? '₹ $pendingAmount'
                                        : UserSimplePreferences.getCurrency() ==
                                                "ZAR"
                                            ? "R ${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "E")}"
                                            // ? 'R $pendingAmount'
                                            : "${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "E")}",
                                    //   : pendingAmount.toString(),
                                    //  "₹ ${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "E")}",
                                    style: TextStyle(
                                      fontSize: kFourteenFont,
                                      fontWeight: kFW900,
                                      color: KdarkText,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Container(
                                    margin: EdgeInsets.all(8.r),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: payslipdata[
                                                "PayrollProcessEarningsDeductions"]
                                            .length,
                                        itemBuilder: (context, index) {
                                          return payslipdata[
                                                          "PayrollProcessEarningsDeductions"]
                                                      [index]["type"] ==
                                                  "Earnings"
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      payslipdata["PayrollProcessEarningsDeductions"]
                                                                  [index][
                                                              "EarningsAndDeduction"]
                                                          [
                                                          "earnings_and_deduction_name"],
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight: kFW600,
                                                        color: Klightgray,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    Text(
                                                      payslipdata["PayrollProcessEarningsDeductions"]
                                                              [index]["amount"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: kTwelveFont,
                                                        fontWeight: kFW600,
                                                        color: Klightgray,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : SizedBox();
                                        })),
                              ],
                            )),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 15.h,
              ),
              /////////////Deductions
              payslipdata["PayrollProcessEarningsDeductions"].length > 0
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r)),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.r)),
                        color: KRed.withOpacity(0.15),
                        child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "Deductions",
                                    style: TextStyle(
                                      fontSize: kTwelveFont,
                                      fontWeight: kFW600,
                                      color: Klightblack,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    UserSimplePreferences.getCurrency() == "INR"
                                        ? "₹ ${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "D")}"
                                        //  ? '₹ $pendingAmount'
                                        : UserSimplePreferences.getCurrency() ==
                                                "ZAR"
                                            ? "R ${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "D")}"
                                            : "${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "D")}",
                                    //'R $pendingAmount'
                                    //  : pendingAmount.toString(),
                                    //   "₹ ${getdecuctionPrices(payslipdata["PayrollProcessEarningsDeductions"], "D")}",
                                    style: TextStyle(
                                      fontSize: kFourteenFont,
                                      fontWeight: kFW900,
                                      color: KdarkText,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                const Divider(),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Container(
                                    margin: EdgeInsets.all(8.r),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: payslipdata[
                                                "PayrollProcessEarningsDeductions"]
                                            .length,
                                        itemBuilder: (context, index) {
                                          return payslipdata[
                                                          "PayrollProcessEarningsDeductions"]
                                                      [index]["type"] ==
                                                  "Deductions"
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      payslipdata["PayrollProcessEarningsDeductions"]
                                                                  [index][
                                                              "EarningsAndDeduction"]
                                                          [
                                                          "earnings_and_deduction_name"],
                                                      style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight: kFW600,
                                                        color: Klightgray,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                    Text(
                                                      payslipdata["PayrollProcessEarningsDeductions"]
                                                              [index]["amount"]
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: kTwelveFont,
                                                        fontWeight: kFW600,
                                                        color: Klightgray,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : SizedBox();
                                        })),
                              ],
                            )),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 15.h,
              ),
              ////Payslip for month
              payslipdata["PayrollProcessEarningsDeductions"].length > 0
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Kwhite,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.roundToDouble())),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Net Pay",
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
                                  payslipdata["PayrollProcess"] != null
                                      ? payslipdata["PayrollProcess"]
                                                  ["totl_pay_amt"] !=
                                              null
                                          ? payslipdata["PayrollProcess"]
                                                  ["totl_pay_amt"]
                                              .toString()
                                          : "-"
                                      : "-",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: kFW700,
                                      color: KdarkText),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                // Text(
                                //     payslipdata["PayrollProcess"] != null?
                                //   NumberToWordsEnglish.convert(payslipdata["PayrollProcess"]
                                //               ["totl_pay_amt"]
                                //           ):"-",
                                //   maxLines: 1,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: TextStyle(
                                //       fontSize: kTenFont,
                                //       fontWeight: kFW700,
                                //       color: Klightgray),
                                // ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                  : const SizedBox(),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Employee Details",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: kFourteenFont,
                    fontWeight: kFW600,
                    color: KdarkText),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                  padding: EdgeInsets.all(10.r),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r), color: Kwhite),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: kFW600,
                                    color: Klightblack),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                payslipdata["Employee"] != null
                                    ? "${payslipdata["Employee"]!["lname"]}. ${payslipdata["Employee"]!["fname"]}"
                                    : "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: kTwelveFont,
                                    fontWeight: kFW700,
                                    color: KdarkText),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Employee No",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: kFW600,
                                    color: Klightblack),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                payslipdata["Employee"] != null
                                    ? payslipdata["Employee"]!["emp_code"]
                                    : "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: kTwelveFont,
                                    fontWeight: kFW700,
                                    color: KdarkText),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Joining Date",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW600,
                                color: Klightblack),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            payslipdata["Employee"] != null
                                ? payslipdata["Employee"]!["date_of_joining"]
                                    .toString()
                                : "-",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: kTwelveFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "PF No",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW600,
                                color: Klightblack),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "GR/GNT/1806702/000/00120121",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: kTwelveFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Bank Name",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW600,
                                color: Klightblack),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            payslipdata["Employee"] != null
                                ? payslipdata["Employee"]!["bank_name"]
                                : "-",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: kTwelveFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Account number",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW600,
                                color: Klightblack),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            payslipdata["Employee"] != null
                                ? payslipdata["Employee"]!["account_number"]
                                    .toString()
                                : "-",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: kTwelveFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
