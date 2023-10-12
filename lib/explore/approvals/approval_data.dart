import 'package:intl/intl.dart';
import 'package:vibeshr/controllers/claimsController.dart';

import '../../untils/export_file.dart';

class Approval_data extends StatefulWidget {
  const Approval_data({super.key});

  @override
  State<Approval_data> createState() => _Approval_dataState();
}

class _Approval_dataState extends State<Approval_data> {
  String clickedOption = "Pending";
  ClaimController claimController = Get.put(ClaimController());

  getData(){
    claimController.leavesData.clear();
    if(clickedOption=="Pending"){
      for(int i=0;i<claimController.leaveslList["rows"].length;i++){
          if(claimController.leaveslList["rows"][i]["leave_status"]==0){
            claimController.leavesData.add(claimController.leaveslList["rows"][i]);
          }
        }
    }else if(clickedOption=="Approved"){
      for(int i=0;i<claimController.leaveslList["rows"].length;i++){
          if(claimController.leaveslList["rows"][i]["leave_status"]==1){
            claimController.leavesData.add(claimController.leaveslList["rows"][i]);
          }
        }
    }else if(clickedOption=="Rejected"){
      for(int i=0;i<claimController.leaveslList["rows"].length;i++){
          if(claimController.leaveslList["rows"][i]["leave_status"]==2){
           claimController. leavesData.add(claimController.leaveslList["rows"][i]);
          }
        }
    }
  }
  
  @override
  void initState() {
    getData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(13.r),
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickedOption = "Pending";
                        getData();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
                      decoration: clickedOption == "Pending"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: KOrange),
                              color: KOrange)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Ktextcolor)),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                                clickedOption == "Pending" ? kFW700 : kFW500,
                            color: clickedOption == "Pending" ? Kwhite : null),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickedOption = "Approved";
                        getData();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
                      decoration: clickedOption == "Approved"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: KOrange),
                              color: KOrange)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Ktextcolor)),
                      child: Text(
                        "Approved",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                                clickedOption == "Approved" ? kFW700 : kFW500,
                            color: clickedOption == "Approved" ? Kwhite : null),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickedOption = "Rejected";
                        getData();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
                      decoration: clickedOption == "Rejected"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: KOrange),
                              color: KOrange)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Ktextcolor)),
                      child: Text(
                        "Rejected",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                                clickedOption == "Rejected" ? kFW700 : kFW500,
                            color: clickedOption == "Rejected" ? Kwhite : null),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: claimController.leavesData.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(top: 10.h),
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
                                  topRight: Radius.circular(8.roundToDouble())),
                              child: Image.asset(
                                "assets/images/buble.png",
                                width: 90.w,
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
                                   claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.leavesData[index]["emp_id"]).toList().isNotEmpty?  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.leavesData[index]["emp_id"]).toList()[0]["username"]:"Slef",
                                  // "-",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: kFW700,
                                      color: Klightgray),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  claimController.leavesData[index]["reason"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      height: 1.2,
                                      letterSpacing: 0.5,
                                      wordSpacing: 0.5,
                                      fontSize: 13.sp,
                                      fontWeight: kFW900,
                                      color: KdarkText),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Start - ${DateFormat("dd MMM yy").format(DateTime.parse(claimController.leavesData[index]["from_date"]))}",
                                     
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: kTenFont,
                                          fontWeight: kFW600,
                                          color: Klightblack),
                                    ),
                                    Text(
                                      "End - ${DateFormat("dd MMM yy").format(DateTime.parse(claimController.leavesData[index]["to_date"]))}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: kTenFont,
                                          fontWeight: kFW600,
                                          color: Klightblack),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Custom_OutlineButton(
                                      height: 28.h,
                                      width: 105.w,
                                      textColor: KOrange,
                                      borderRadius: BorderRadius.circular(8.r),
                                      Color: KOrange,
                                      fontSize: kTenFont,
                                      fontWeight: kFW600,
                                      label: "View More",
                                      isLoading: false,
                                      onTap: () async{
                                        claimController.viewSingleLeave(claimController.leavesData[index],claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.leavesData[index]["emp_id"]).toList().isNotEmpty?  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.leavesData[index]["emp_id"]).toList()[0]["username"]:"Slef");
                                        var x = await Get.toNamed(KApproval_view);
                                        // : {"data":leavesData[index],"name" :  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==leavesData[index]["emp_id"]).toList().isNotEmpty?  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==leavesData[index]["emp_id"]).toList()[0]["username"]:"Slef" });
                                        setState(() {
                                         getData(); 
                                        });

                                      }),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
                })
          ],
        ),
      ),
    );
  }
}

class Claim_Approval_data extends StatefulWidget {
  const Claim_Approval_data({super.key});

  @override
  State<Claim_Approval_data> createState() => _Claim_Approval_dataState();
}

class _Claim_Approval_dataState extends State<Claim_Approval_data> {
  ClaimController claimController = Get.put(ClaimController());

  String clickedOption = "Pending";

  getData(){
    claimController.claimsData.clear();
    if(clickedOption=="Pending"){
      for(int i=0;i<claimController.claimsList["rows"].length;i++){
          if(claimController.claimsList["rows"][i]["is_approved"]=="Pending"){
            claimController.claimsData.add(claimController.claimsList["rows"][i]);
          }
        }
    }else if(clickedOption=="Approved"){
      for(int i=0;i<claimController.claimsList["rows"].length;i++){
          if(claimController.claimsList["rows"][i]["is_approved"]=="Approved"){
            claimController.claimsData.add(claimController.claimsList["rows"][i]);
          }
        }
    }else if(clickedOption=="Rejected"){
      for(int i=0;i<claimController.claimsList["rows"].length;i++){
          if(claimController.claimsList["rows"][i]["is_approved"]=="Rejected"){
            claimController.claimsData.add(claimController.claimsList["rows"][i]);
          }
        }
    }
    else if(clickedOption=="Paid"){
      for(int i=0;i<claimController.claimsList["rows"].length;i++){
          if(claimController.claimsList["rows"][i]["is_approved"]=="Paid"){
            claimController.claimsData.add(claimController.claimsList["rows"][i]);
          }
        }
    }
  }
  
  @override
  void initState() {
    getData();
    super.initState();
  }
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(13.r),
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickedOption = "Pending";
                        getData();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
                      decoration: clickedOption == "Pending"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: KOrange),
                              color: KOrange)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Ktextcolor)),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                                clickedOption == "Pending" ? kFW700 : kFW500,
                            color: clickedOption == "Pending" ? Kwhite : null),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickedOption = "Approved";
                        getData();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
                      decoration: clickedOption == "Approved"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: KOrange),
                              color: KOrange)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Ktextcolor)),
                      child: Text(
                        "Approved",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                                clickedOption == "Approved" ? kFW700 : kFW500,
                            color: clickedOption == "Approved" ? Kwhite : null),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        clickedOption = "Rejected";
                        getData();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, top: 8.h, bottom: 8.h),
                      decoration: clickedOption == "Rejected"
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: KOrange),
                              color: KOrange)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Ktextcolor)),
                      child: Text(
                        "Rejected",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                                clickedOption == "Rejected" ? kFW700 : kFW500,
                            color: clickedOption == "Rejected" ? Kwhite : null),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: claimController.claimsData.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(top: 10.h),
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
                                  topRight: Radius.circular(8.roundToDouble())),
                              child: Image.asset(
                                "assets/images/buble.png",
                                width: 90.w,
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
                                   claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.claimsData[index]["emp_id"]).toList().isNotEmpty?  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.claimsData[index]["emp_id"]).toList()[0]["username"]:"Slef",
                                  // "-",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: kFW700,
                                      color: Klightgray),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  claimController.claimsData[index]["comments"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      height: 1.2,
                                      letterSpacing: 0.5,
                                      wordSpacing: 0.5,
                                      fontSize: 13.sp,
                                      fontWeight: kFW900,
                                      color: KdarkText),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date - ${DateFormat("dd MMM yy").format(DateTime.parse(claimController.claimsData[index]["date"]))}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: kTenFont,
                                          fontWeight: kFW600,
                                          color: Klightblack),
                                    ),
                                    // Text(
                                    //   "End - ${DateFormat("dd MMM yy").format(DateTime.parse(leavesData[index]["to_date"]))}",
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: TextStyle(
                                    //       fontSize: kTenFont,
                                    //       fontWeight: kFW600,
                                    //       color: Klightblack),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Custom_OutlineButton(
                                      height: 28.h,
                                      width: 105.w,
                                      textColor: KOrange,
                                      borderRadius: BorderRadius.circular(8.r),
                                      Color: KOrange,
                                      fontSize: kTenFont,
                                      fontWeight: kFW600,
                                      label: "View More",
                                      isLoading: false,
                                      onTap: () async{
                                        claimController.viewSingleClaim(claimController.claimsData[index],claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.claimsData[index]["emp_id"]).toList().isNotEmpty?  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==claimController.claimsData[index]["emp_id"]).toList()[0]["username"]:"Self");
                                        var x = await Get.toNamed(KClaimsApproval_view
                                        // ,arguments: {"data":claimController.claimsData[index],"name" : 
                                        //  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==leavesData[index]["emp_id"]).toList().isNotEmpty?  claimController.peoplesdata["rows"].where((element) => element["emp_id"]==8).toList()[0]["username"]:
                                        // "Slef" }
                                        );
                                        setState(() {
                                          getData();
                                        });
                                        
                                      }),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
                })
          ],
        ),
      ),
    );
  }
}
