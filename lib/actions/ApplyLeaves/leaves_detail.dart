// ignore_for_file: camel_case_types

import 'package:vibeshr/untils/export_file.dart';

class leave_detail extends StatefulWidget {
  const leave_detail({super.key});

  @override
  State<leave_detail> createState() => _leave_detailState();
}

class _leave_detailState extends State<leave_detail> {
  Map leaveldetaildata = {};

  bool isLoading = false;
  Future leavelHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.leaveldetail();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      leaveldetaildata = data;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    leavelHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbackground,
      appBar: const VibhoAppBar(
        title: "Leave Detail",
        bColor: Kbackground,
        dontHaveBackAsLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(13.r),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Kwhite,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(13.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Status : ${leavesdata[index]["leave_status"]==0?"In Progress":leavesdata[index]["leave_status"]==1? "Approved":leavesdata[index]["leave_status"]==2?"Rejected By Admin":leavesdata[index]["leave_status"]==0?"Cancelled By You": "-"}" ,
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //       fontSize: kTwelveFont,
                        //       fontWeight: kFW600,
                        //       color: Klightblack),
                        // ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                leaveldetaildata["from_date"].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: kFW700,
                                    color: kblack),
                              ),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                leaveldetaildata["to_date"].toString(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            leaveldetaildata["reason"],
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
      ),
    );
  }
}
