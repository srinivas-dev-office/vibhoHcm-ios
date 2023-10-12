// ignore_for_file: prefer_interpolation_to_compose_strings

import '../../untils/export_file.dart';

class Leaves extends StatefulWidget {
  const Leaves({super.key});

  @override
  State<Leaves> createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> {
  List leavesdata = [];
  Map profile = {};

  bool isLoading = false;
   Map peoplesdata = {};
  List originalList = [];
  Future peoplesListHandler() async {
    setState(() {
      peopleLoading = true;
    });
    Map data = await Services.peopleslist();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      peoplesdata = data;
      originalList = data["rows"];
    }
    setState(() {
      peopleLoading = false;
    });
  }
  bool peopleLoading=false;
  Future leavesListHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.leavelist();
    profile = await Services.employeeprofile();
    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      leavesdata = data["rows"];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    leavesListHandler();
    peoplesListHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomButton(
            margin: const EdgeInsets.all(15),
            height: 40.h,
            width: double.infinity,
            textColor: Kwhite,
            borderRadius: BorderRadius.circular(20.r),
            Color: KOrange,
            fontSize: 13.sp,
            fontWeight: kFW600,
            label: "Apply Leave ",
            isLoading: false,


            onTap: () {
              Get.toNamed(Kleaves,arguments: leavesdata);
              }),
        backgroundColor: Kbackground,
        appBar: const VibhoAppBar(
          bColor: Kbackground,
          title: 'Leaves History',
          dontHaveBackAsLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [


              isLoading==false && peopleLoading==false? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leavesdata.length,
                  itemBuilder: (context, index) {
                    return leavesdata[index]["emp_id"]== profile["emp_id"]?
                    GestureDetector(
                      onTap: (){
                       // Get.toNamed(KLeave_detail);
                      },
                      child: 
                      Container(
                        margin: EdgeInsets.all(13.r),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Kwhite,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w, top: 8.h),
                                  child: Text(
                                    // ignore: unnecessary_null_comparison
                                    profile["Employee"]!=null?profile["Employee"]["fname"]:"No Name",
                                    style: TextStyle(
                                        fontSize: kSixteenFont.sp,
                                        fontWeight: kFW700,
                                        color: kblack),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight:
                                            Radius.circular(8.roundToDouble())),
                                    child: Image.asset(
                                      "assets/images/buble.png",
                                      width: 90.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(13.r),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                       Text(
                                        "Status : " ,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: kTwelveFont,
                                            fontWeight: kFW600,
                                            color: Klightblack,
                                            //Klightblack
                                            ),
                                      ),
                                      Text(
                                        "${leavesdata[index]["leave_status"]==0?"In Progress":leavesdata[index]["leave_status"]==1? "Approved":leavesdata[index]["leave_status"]==2?"Rejected By Admin":leavesdata[index]["leave_status"]==0?"Cancelled By You": "-"}" ,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: kTwelveFont,
                                            fontWeight: kFW600,
                                            color: leavesdata[index]["leave_status"]==0?KOrange:leavesdata[index]["leave_status"]==1?Kgreen:leavesdata[index]["leave_status"]==2?KRed:leavesdata[index]["leave_status"]==0?KRed:Klightblack,
                                            //Klightblack
                                            ),
                                      ),
                                      // Text(
                                      //   leavesdata[index]["leave_status"].toString(),
                                      //   style: TextStyle(
                                      //       fontSize: 13.sp,
                                      //       fontWeight: kFW600,
                                      //       color: Kgreen),
                                      // )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Form Date",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: kTwelveFont,
                                                  fontWeight: kFW600,
                                                  color: Klightblack),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              leavesdata[index]["from_date"].toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: kFW700,
                                                  color: kblack),
                                            ),
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "To Date",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: kTwelveFont,
                                                  fontWeight: kFW600,
                                                  color: Klightblack),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                              leavesdata[index]["to_date"].toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: kFW700,
                                                  color: kblack),
                                            ),
                                          ]),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             "Leave Type",
                                  //             maxLines: 1,
                                  //             overflow: TextOverflow.ellipsis,
                                  //             style: TextStyle(
                                  //                 fontSize: kTwelveFont,
                                  //                 fontWeight: kFW600,
                                  //                 color: Klightblack),
                                  //           ),
                                  //           SizedBox(
                                  //             height: 5.h,
                                  //           ),
                                  //           Text(
                                  //             leavesdata[index]["leave_type"],
                                            
                                  //             maxLines: 1,
                                  //             overflow: TextOverflow.ellipsis,
                                  //             style: TextStyle(
                                  //                 fontSize: 13.sp,
                                  //                 fontWeight: kFW700,
                                  //                 color: kblack),
                                  //           ),
                                  //         ]),
                                  //     Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //             "Leave Days",
                                  //             maxLines: 2,
                                  //             overflow: TextOverflow.ellipsis,
                                  //             style: TextStyle(
                                  //                 fontSize: kTwelveFont,
                                  //                 fontWeight: kFW600,
                                  //                 color: Klightblack),
                                  //           ),
                                  //           SizedBox(
                                  //             height: 5.h,
                                  //           ),
                                  //           Text(
                                  //              leavesdata[index]["leave_days"].toString(),
                                            
                                              
                                  //             maxLines: 3,
                                  //             overflow: TextOverflow.ellipsis,
                                  //             style: TextStyle(
                                  //                 fontSize: 13.sp,
                                  //                 fontWeight: kFW700,
                                  //                 color: kblack),
                                  //           ),
                                  //         ]),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 20.h,
                                  // ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Reason : ",
                                          maxLines: 1,
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
                                           leavesdata[index]["reason"],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: kFW700,
                                              color: kblack),
                                        ),
                                      ]),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ):const SizedBox();
                  }):
                  const Center(
                            child: SpinKitWave(
                            color: KOrange,
                            size: 15,
                          )),

              SizedBox(height: 20.h)
            ],
          ),
        ));
  }
}
///////dont delete it
///
///
// Container(
          //   alignment: Alignment.center,
          //   color: Kbackground,
          //   height: 60,
          //   width: double.infinity,
          //   margin: EdgeInsets.all(13.r),
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
          //                     left: 20.w, right: 20.w, top: 5.h, bottom: 5.h),
          //                 decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(13.r),
          //                     color: current == index ? KOrange : Kwhite,
          //                     border: Border.all(
          //                       color: current == index
          //                           ? KOrange
          //                           : Klightgray.withOpacity(0.5),
          //                     )),
          //                 duration: const Duration(milliseconds: 300),
          //                 child: Text(
          //                   items[index],
          //                   style: TextStyle(
          //                     fontSize: kTwelveFont,
          //                     fontWeight: current == index ? kFW600 : kFW500,
          //                     color: current == index ? Kwhite : Klightgray,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         );
          //       }),
          // ),