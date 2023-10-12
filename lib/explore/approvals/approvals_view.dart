// ignore_for_file: camel_case_types

import 'package:intl/intl.dart';
import 'package:vibeshr/controllers/claimsController.dart';
import 'package:vibeshr/untils/export_file.dart';

class Approval_view extends StatefulWidget {
  const Approval_view({super.key});

  @override
  State<Approval_view> createState() => _Approval_viewState();
}

class _Approval_viewState extends State<Approval_view> {
  ClaimController claimController = Get.put(ClaimController());
  bool isLoading = false;
  var approvalConfirm = {};
  @override
  void initState() {
    getApprovalConfirmationAPI();
    super.initState();
  }
  updateLeaveClaimStats(String status,String reason,int leaveid)async{
        setState(() {
      isLoading = true;
    });
    Map payload = {
      "leave_status":status,
      "reason":reason
    };
    Map data = await Services.hrUpdateEmployeesLeaves(payload,leaveid);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      setState(() {
         claimController.leaveSingleDataView.value = data;
          claimController.updateLeaveUpdatedValue(data);
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  getApprovalConfirmationAPI()async{
        setState(() {
      isLoading = true;
    });
    Map data = await Services.hrRequestApprovalConfigs();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      approvalConfirm = data;
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      appBar: const VibhoAppBar(
        title: "Full View",
        dontHaveBackAsLeading: false,
        bColor: Kwhite,
      ),
      body:isLoading==false? SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(18.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(3),
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r),
                          color: Kwhite,
                        ),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(13.r), // Image border
                            child: Image.asset("assets/images/man.png"))),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: kFW600,
                                  color: KdarkText.withOpacity(0.5)),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              claimController.leaveSingleDataViewPersonName.value,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: kFW700,
                                  color: KdarkText),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        claimController.leaveSingleDataView["leave_status"] == 1
                            ? CustomButton(
                                height: 25.h,
                                width: 100.w,
                                fontSize: kTenFont,
                                fontWeight: kFW700,
                                Color: Kgreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.r),
                                Padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 3.h,
                                    bottom: 3.h),
                                textColor: Kgreen,
                                label: "Approved",
                                isLoading: false,
                                onTap: () {
                                })
                            : claimController.leaveSingleDataView["leave_status"] == 2 ? CustomButton(
                                height: 25.h,
                                width: 100.w,
                                fontSize: kTenFont,
                                fontWeight: kFW700,
                                Color: KRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.r),
                                Padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 3.h,
                                    bottom: 3.h),
                                textColor: KRed,
                                label: "Rejected",
                                isLoading: false,
                                onTap: () {
                                  updateLeaveClaimStats("Reject","Leave Rejected",claimController.leaveSingleDataView["employee_leaves_lid"]);
                                }):const SizedBox()
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Start Date",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: kFW600,
                              color: Klightblack.withOpacity(0.8),
                            )),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                            DateFormat("dd MMM yy")
                                .format(DateTime.parse(claimController.leaveSingleDataView["from_date"])),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW700,
                              color: KdarkText,
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 100.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("End Date",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: kFW600,
                              color: Klightblack.withOpacity(0.8),
                            )),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                            DateFormat("dd MMM yy")
                                .format(DateTime.parse(claimController.leaveSingleDataView["to_date"])),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW700,
                              color: KdarkText,
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reason",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: kFW600,
                          color: Klightblack.withOpacity(0.8),
                        )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(claimController.leaveSingleDataView["reason"] != "" ? claimController.leaveSingleDataView["reason"] : "-",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: kFW700,
                          color: KdarkText,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Leave Type",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: kFW600,
                          color: Klightblack.withOpacity(0.8),
                        )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                        claimController.leaveSingleDataView["leave_type"] != ""
                            ? claimController.leaveSingleDataView["leave_type"]
                            : "-",
                        style: TextStyle(
                          height: 1.2,
                          letterSpacing: 0.5,
                          fontSize: 13.sp,
                          fontWeight: kFW700,
                          color: KdarkText,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                claimController.leaveSingleDataView["leave_status"] == 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Approved Date",
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: kFW600,
                                color: Klightblack.withOpacity(0.8),
                              )),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                              claimController.leaveSingleDataView["approved_date"]==null?"-":DateFormat("dd MMM yy").format(
                                  DateTime.parse(claimController.leaveSingleDataView["approved_date"])),
                              style: TextStyle(
                                height: 1.2,
                                letterSpacing: 0.5,
                                fontSize: 13.sp,
                                fontWeight: kFW700,
                                color: KdarkText,
                              )),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 200.h,
                ),
                Column(
                  children: [
                    approvalConfirm["leaves"]["write"]==true? claimController.leaveSingleDataView["leave_status"] != 1
                        ? CustomButton(
                            borderRadius: BorderRadius.circular(30.r),
                            margin: EdgeInsets.all(15.r),
                            width: double.infinity,
                            height: 35.h,
                            Color: KOrange,
                            textColor: Kwhite,
                            fontSize: 13.sp,
                            fontWeight: kFW700,
                            label: "Approve",
                            isLoading: false,
                            onTap: () {
                              updateLeaveClaimStats("Approve","Leave Granted",claimController.leaveSingleDataView["employee_leaves_lid"]);
                            })
                        : const SizedBox():const SizedBox(),
                   approvalConfirm["leaves"]["write"]==true? claimController.leaveSingleDataView["leave_status"] != 2
                        ? CustomButton(
                        borderRadius: BorderRadius.circular(30.r),
                        margin: EdgeInsets.all(10.r),
                        width: double.infinity,
                        height: 35.h,
                        Color: Kwhite,
                        textColor: KOrange,
                        fontSize: 13.sp,
                        fontWeight: kFW700,
                        label: "Decline",
                        isLoading: false,
                        onTap: () {
                          updateLeaveClaimStats("Reject","Leave Rejected",claimController.leaveSingleDataView["employee_leaves_lid"]);
                          // _showDialog(context);
                        }):const SizedBox():const SizedBox(),
                  ],
                ),
              ],
            )),
      ):const SpinKitWave(
                      color: KOrange,
                      size: 25,
                    ),
    );
  }
}


class ClaimApproval_view extends StatefulWidget {
  const ClaimApproval_view({super.key});

  @override
  State<ClaimApproval_view> createState() => _ClaimApproval_viewState();
}

class _ClaimApproval_viewState extends State<ClaimApproval_view> {
    ClaimController claimController = Get.put(ClaimController());
  // var fullInfo = Get.arguments["data"];
  // var name = Get.arguments["name"];
  bool isLoading = false;
  var approvalConfirm = {};
  @override
  void initState() {
    getApprovalConfirmationAPI();
    super.initState();
  }
    updateLeaveClaimStats(String status,String reason,int claimid)async{
        setState(() {
      isLoading = true;
    });
    Map payload = {
      "is_approved":status,
      "comments":reason
    };
    Map data = await Services.hrUpdateEmployeesClaim(payload,claimid);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      setState(() {
          claimController.claimSingleDataView.value = data;
          claimController.updateClaimUpdatedValue(claimController.claimSingleDataView);
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  getApprovalConfirmationAPI()async{
        setState(() {
      isLoading = true;
    });
    Map data = await Services.hrRequestApprovalConfigs();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      approvalConfirm = data;
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      appBar: const VibhoAppBar(
        title: "Full View",
        dontHaveBackAsLeading: false,
        bColor: Kwhite,
        dorefresh:true
      ),
      body:isLoading==false? SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(18.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(3),
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r),
                          color: Kwhite,
                        ),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(13.r), // Image border
                            child: Image.asset("assets/images/man.png"))),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: kFW600,
                                  color: KdarkText.withOpacity(0.5)),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              claimController.claimSingleDataViewPersonName.value,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: kFW700,
                                  color: KdarkText),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        claimController.claimSingleDataView["is_approved"] == "Approved"
                            ? CustomButton(
                                height: 25.h,
                                width: 100.w,
                                fontSize: kTenFont,
                                fontWeight: kFW700,
                                Color: Kgreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.r),
                                Padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 3.h,
                                    bottom: 3.h),
                                textColor: Kgreen,
                                label: "Approved",
                                isLoading: false,
                                onTap: () {})
                            : claimController.claimSingleDataView["is_approved"] == "Rejected" ? CustomButton(
                                height: 25.h,
                                width: 100.w,
                                fontSize: kTenFont,
                                fontWeight: kFW700,
                                Color: KRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.r),
                                Padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 3.h,
                                    bottom: 3.h),
                                textColor: KRed,
                                label: "Rejected",
                                isLoading: false,
                                onTap: () {}):
                                claimController.claimSingleDataView["is_approved"] == "Pending" ? CustomButton(
                                height: 25.h,
                                width: 100.w,
                                fontSize: kTenFont,
                                fontWeight: kFW700,
                                Color: KRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.r),
                                Padding: EdgeInsets.only(
                                    left: 8.w,
                                    right: 8.w,
                                    top: 3.h,
                                    bottom: 3.h),
                                textColor: KRed,
                                label: "Pending",
                                isLoading: false,
                                onTap: () {}):const SizedBox()
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: kFW600,
                              color: Klightblack.withOpacity(0.8),
                            )),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                            DateFormat("dd MMM yy")
                                .format(DateTime.parse(claimController.claimSingleDataView["date"])),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW700,
                              color: KdarkText,
                            )),
                      ],
                    ),
                    SizedBox(
                      width: 100.w,
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text("End Date",
                    //         style: TextStyle(
                    //           fontSize: 11.5.sp,
                    //           fontWeight: kFW600,
                    //           color: Klightblack.withOpacity(0.8),
                    //         )),
                    //     SizedBox(
                    //       height: 5.h,
                    //     ),
                    //     Text(
                    //         DateFormat("dd MMM yy")
                    //             .format(DateTime.parse(fullInfo["to_date"])),
                    //         style: TextStyle(
                    //           fontSize: 13.sp,
                    //           fontWeight: kFW700,
                    //           color: KdarkText,
                    //         )),
                    //   ],
                    // ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Comment",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: kFW600,
                          color: Klightblack.withOpacity(0.8),
                        )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(claimController.claimSingleDataView["comments"] != "" ? claimController.claimSingleDataView["comments"] : "-",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: kFW700,
                          color: KdarkText,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Claim Amount",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: kFW600,
                          color: Klightblack.withOpacity(0.8),
                        )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                        claimController.claimSingleDataView["amount"].toString(),
                        style: TextStyle(
                          height: 1.2,
                          letterSpacing: 0.5,
                          fontSize: 13.sp,
                          fontWeight: kFW700,
                          color: KdarkText,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                // fullInfo["leave_status"] == 1
                //     ? Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text("Approved Date",
                //               style: TextStyle(
                //                 fontSize: 11.5.sp,
                //                 fontWeight: kFW600,
                //                 color: Klightblack.withOpacity(0.8),
                //               )),
                //           SizedBox(
                //             height: 5.h,
                //           ),
                //           Text(
                //               DateFormat("dd MMM yy").format(
                //                   DateTime.parse(fullInfo["approved_date"])),
                //               style: TextStyle(
                //                 height: 1.2,
                //                 letterSpacing: 0.5,
                //                 fontSize: 13.sp,
                //                 fontWeight: kFW700,
                //                 color: KdarkText,
                //               )),
                //         ],
                //       )
                //     : const SizedBox(),
                SizedBox(
                  height: 200.h,
                ),
                Column(
                  children: [
                    approvalConfirm["leaves"]["write"]==true? claimController.claimSingleDataView["is_approved"] != "Rejected"
                        ? CustomButton(
                            borderRadius: BorderRadius.circular(30.r),
                            margin: EdgeInsets.all(15.r),
                            width: double.infinity,
                            height: 35.h,
                            Color: KOrange,
                            textColor: Kwhite,
                            fontSize: 13.sp,
                            fontWeight: kFW700,
                            label: "Approve",
                            isLoading: false,
                            onTap: () {
                               updateLeaveClaimStats("Approved","Claim Approved",claimController.claimSingleDataView["claim_id"]);
                            })
                        : const SizedBox():const SizedBox(),
                   approvalConfirm["leaves"]["write"]==true? claimController.claimSingleDataView["is_approved"] == "Rejected"
                        ? CustomButton(
                        borderRadius: BorderRadius.circular(30.r),
                        margin: EdgeInsets.all(10.r),
                        width: double.infinity,
                        height: 35.h,
                        Color: Kwhite,
                        textColor: KOrange,
                        fontSize: 13.sp,
                        fontWeight: kFW700,
                        label: "Decline",
                        isLoading: false,
                        onTap: () {
                           updateLeaveClaimStats("Rejected","Claim Rejected",claimController.claimSingleDataView["claim_id"]);
                        }):const SizedBox():const SizedBox(),
                  ],
                ),
              ],
            )),
      ):const SpinKitWave(
                      color: KOrange,
                      size: 25,
                    ),
    );
  }
}
