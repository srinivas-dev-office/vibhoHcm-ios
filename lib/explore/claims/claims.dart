// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:intl/intl.dart';

import '../../untils/export_file.dart';

class Reimbursement_view extends StatefulWidget {
  const Reimbursement_view({super.key});

  @override
  State<Reimbursement_view> createState() => _Reimbursement_viewState();
}

class _Reimbursement_viewState extends State<Reimbursement_view> {
  @override
  bool isLoading = false;
  Map claimsData = {};

  getClaimsList() async {
    setState(() {
      isLoading = true;
    });

    Map value = await Services.getClaimList();
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {
      claimsData = value;
      getFinalData();
    }
    setState(() {
      isLoading = false;
    });
  }

  String totalAmount = "0";
  String pendingAmount = "0";
  String approvalAmount = "0";

  getFinalData() {
    for (int i = 0; i < claimsData["rows"].length; i++) {
      if (claimsData["rows"][i]["is_approved"] == "Approved") {
        approvalAmount =
            (int.parse(approvalAmount) + claimsData["rows"][i]["amount"])
                .toString();
      }
      if (claimsData["rows"][i]["is_approved"] == "Pending") {
        pendingAmount =
            (int.parse(pendingAmount) + claimsData["rows"][i]["amount"])
                .toString();
      }
      if (claimsData["rows"][i]["is_approved"] == "Paid") {
        totalAmount = (int.parse(totalAmount) + claimsData["rows"][i]["amount"])
            .toString();
      }
    }
  }

  @override
  void initState() {
    getClaimsList();
    super.initState();
  }

  Widget build(BuildContext context) {
    late final TabContainerController _controller;
    return Scaffold(
      backgroundColor: Kbackground,
      bottomSheet: CustomButton(
          borderRadius: BorderRadius.circular(30.r),
          margin: EdgeInsets.all(15.r),
          width: double.infinity,
          height: 38.h,
          Color: KOrange,
          textColor: Kwhite,
          fontSize: 13.sp,
          fontWeight: kFW700,
          label: "Create Claim",
          isLoading: false,
          onTap: () {
            Get.toNamed(KClaims);
          }),
      appBar: const VibhoAppBar(
        title: "Claims",
        bColor: Kbackground,
      ),
      body: Container(
        margin: EdgeInsets.all(13.r),
        child: isLoading == false
            ? SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        left: 13.w, right: 13.w, top: 20.h, bottom: 16.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: KdarkText),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Custom_text(
                          titlelabel: "Total Expenses",
                          sublabel: UserSimplePreferences.getCurrency() == "INR"
                              ? "₹ $totalAmount"
                              : UserSimplePreferences.getCurrency() == "ZAR"
                                  ? "R $totalAmount"
                                  : totalAmount.toString(),
                          TitleColor: Kwhite,
                          Titlefontsize: 11.sp,
                          SubColor: Kgreen,
                          Subfontsize: kSixteenFont,
                        ),
                        Custom_text(
                          titlelabel: "Approved",
                          sublabel: UserSimplePreferences.getCurrency() == "INR"
                              ? "₹ $approvalAmount"
                              : UserSimplePreferences.getCurrency() == "ZAR"
                                  ? "R $approvalAmount"
                                  : approvalAmount.toString(),
                          // UserSimplePreferences.getCurrency() == "INR"
                          //     ? "₹ $approvalAmount"
                          //     : "R $approvalAmount",
                          TitleColor: Kwhite,
                          Titlefontsize: 11.sp,
                          SubColor: Kwhite,
                          Subfontsize: kSixteenFont,
                        ),
                        Custom_text(
                          titlelabel: "Pending",
                          sublabel: UserSimplePreferences.getCurrency() == "INR"
                              ? '₹ $pendingAmount'
                              : UserSimplePreferences.getCurrency() == "ZAR"
                                  ? 'R $pendingAmount'
                                  : pendingAmount.toString(),
                          // UserSimplePreferences.getCurrency() == "INR"
                          //     ? '₹ $pendingAmount'
                          //     : 'R $pendingAmount',
                          //'₹ $pendingAmount',
                          TitleColor: Kwhite,
                          Titlefontsize: 11.sp,
                          SubColor: KRed,
                          Subfontsize: kSixteenFont,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: 438.h,
                    margin: EdgeInsets.only(
                      top: 10.h,
                    ),
                    child: TabContainer(
                      // selectedTextStyle:TextStyle(fontSize: 13.sp) ,
                      color: Kwhite,
                      tabs: const [
                        'Pending',
                        'Approved',
                        'Paid',
                        'Rejected',
                      ],
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: claimsData["rows"].length,
                            itemBuilder: ((context, index) {
                              return claimsData["rows"][index]["is_approved"] ==
                                      "Pending"
                                  ? GestureDetector(
                                      onTap: () {
                                        Get.toNamed(KExpenses_details,
                                            arguments: claimsData["rows"]
                                                [index]);
                                      },
                                      child: Container(
                                          alignment: Alignment.topCenter,
                                          padding: EdgeInsets.all(10.r),
                                          margin: EdgeInsets.all(10.r),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: Kbackground),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      claimsData["rows"] != null
                                                          ? claimsData["rows"]
                                                                      [index]
                                                                  ["ClaimType"]
                                                              ["name"]
                                                          : "",
                                                      style: TextStyle(
                                                          color: KdarkText,
                                                          fontSize:
                                                              kFourteenFont,
                                                          fontWeight: kFW900)),
                                                  Text(
                                                      DateFormat.yMMMd()
                                                          .format(
                                                              DateTime.parse(
                                                            claimsData["rows"]
                                                                [index]["date"],
                                                          ))
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: KdarkText
                                                              .withOpacity(0.5),
                                                          fontSize: kTwelveFont,
                                                          fontWeight: kFW700))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                  claimsData["rows"] != null
                                                      ? claimsData["rows"]
                                                          [index]["comments"]
                                                      : SizedBox(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color:
                                                          KdarkText.withOpacity(
                                                              0.5),
                                                      fontSize: 11.sp,
                                                      fontWeight: kFW900)),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      UserSimplePreferences
                                                                  .getCurrency() ==
                                                              "INR"
                                                          ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                          : UserSimplePreferences
                                                                      .getCurrency() ==
                                                                  "ZAR"
                                                              ? 'R ${claimsData["rows"][index]["amount"]}'
                                                              : claimsData["rows"]
                                                                          [
                                                                          index]
                                                                      ["amount"]
                                                                  .toString(),

                                                      // UserSimplePreferences
                                                      //             .getCurrency() ==
                                                      //         "INR"
                                                      //     ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                      //     : 'R ${claimsData["rows"][index]["amount"]}',

                                                      //   '₹ ${claimsData["rows"][index]["amount"]}',
                                                      style: TextStyle(
                                                          color: KdarkText,
                                                          fontSize: 15.sp,
                                                          fontWeight: kFW900)),
                                                  // Image.asset(
                                                  //   "assets/images/Vector.png",
                                                  //   width: 30.w,
                                                  // )
                                                ],
                                              ),
                                            ],
                                          )),
                                    )
                                  : SizedBox();
                            })),
                        Container(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: claimsData["rows"].length,
                              itemBuilder: ((context, index) {
                                return claimsData["rows"][index]
                                            ["is_approved"] ==
                                        "Approved"
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.toNamed(KExpenses_details,
                                              arguments: claimsData["rows"]
                                                  [index]);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            margin: EdgeInsets.all(10.r),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: Kbackground,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        claimsData["rows"]
                                                                    [index]
                                                                ["ClaimType"]
                                                            ["name"],
                                                        style: TextStyle(
                                                            color: KdarkText,
                                                            fontSize:
                                                                kFourteenFont,
                                                            fontWeight:
                                                                kFW900)),
                                                    Text(
                                                        DateFormat.yMMMd()
                                                            .format(
                                                                DateTime.parse(
                                                              claimsData["rows"]
                                                                      [index]
                                                                  ["date"],
                                                            ))
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: KdarkText
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize:
                                                                kTwelveFont,
                                                            fontWeight: kFW700))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(
                                                    claimsData["rows"] != null
                                                        ? claimsData["rows"]
                                                            [index]["comments"]
                                                        : SizedBox(),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: KdarkText
                                                            .withOpacity(0.5),
                                                        fontSize: 11.sp,
                                                        fontWeight: kFW900)),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        UserSimplePreferences
                                                                    .getCurrency() ==
                                                                "INR"
                                                            ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                            : UserSimplePreferences
                                                                        .getCurrency() ==
                                                                    "ZAR"
                                                                ? 'R ${claimsData["rows"][index]["amount"]}'
                                                                : claimsData["rows"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "amount"]
                                                                    .toString(),

                                                        // UserSimplePreferences
                                                        //             .getCurrency() ==
                                                        //         "INR"
                                                        //     ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                        //     : 'R ${claimsData["rows"][index]["amount"]}',

                                                        //   '₹ ${claimsData["rows"][index]["amount"]}',
                                                        style: TextStyle(
                                                            color: KdarkText,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                kFW900)),
                                                    // Image.asset(
                                                    //   "assets/images/Vector.png",
                                                    //   width: 30.w,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            )),
                                      )
                                    : SizedBox();
                              })),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: claimsData["rows"].length,
                              itemBuilder: ((context, index) {
                                return claimsData["rows"][index]
                                            ["is_approved"] ==
                                        "Paid"
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.toNamed(KExpenses_details,
                                              arguments: claimsData["rows"]
                                                  [index]);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(10.r),
                                            margin: EdgeInsets.all(10.r),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              color: Kgreen.withOpacity(0.3),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        claimsData["rows"]
                                                                    [index]
                                                                ["ClaimType"]
                                                            ["name"],
                                                        style: TextStyle(
                                                            color: KdarkText,
                                                            fontSize:
                                                                kFourteenFont,
                                                            fontWeight:
                                                                kFW900)),
                                                    Text(
                                                        DateFormat.yMMMd()
                                                            .format(
                                                                DateTime.parse(
                                                              claimsData["rows"]
                                                                      [index]
                                                                  ["date"],
                                                            ))
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: KdarkText
                                                                .withOpacity(
                                                                    0.5),
                                                            fontSize:
                                                                kTwelveFont,
                                                            fontWeight: kFW700))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Text(
                                                    claimsData["rows"] != null
                                                        ? claimsData["rows"]
                                                            [index]["comments"]
                                                        : SizedBox(),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: KdarkText
                                                            .withOpacity(0.5),
                                                        fontSize: 11.sp,
                                                        fontWeight: kFW900)),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        UserSimplePreferences
                                                                    .getCurrency() ==
                                                                "INR"
                                                            ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                            : UserSimplePreferences
                                                                        .getCurrency() ==
                                                                    "ZAR"
                                                                ? 'R ${claimsData["rows"][index]["amount"]}'
                                                                : claimsData["rows"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "amount"]
                                                                    .toString(),

                                                        // UserSimplePreferences
                                                        //             .getCurrency() ==
                                                        //         "INR"
                                                        //     ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                        //     : 'R ${claimsData["rows"][index]["amount"]}',

                                                        //   '₹ ${claimsData["rows"][index]["amount"]}',
                                                        style: TextStyle(
                                                            color: KdarkText,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                kFW900)),
                                                    // Image.asset(
                                                    //   "assets/images/Vector.png",
                                                    //   width: 30.w,
                                                    // )
                                                  ],
                                                ),
                                              ],
                                            )),
                                      )
                                    : SizedBox();
                              })),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: claimsData["rows"].length,
                              itemBuilder: ((context, index) {
                                return claimsData["rows"][index]
                                            ["is_approved"] ==
                                        "Rejected"
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.toNamed(KExpenses_details,
                                              arguments: claimsData["rows"]
                                                  [index]);
                                        },
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                              alignment: Alignment.topCenter,
                                              padding: EdgeInsets.all(10.r),
                                              margin: EdgeInsets.all(10.r),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color: KRed.withOpacity(0.3),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          claimsData["rows"]
                                                                      [index]
                                                                  ["ClaimType"]
                                                              ["name"],
                                                          style: TextStyle(
                                                              color: KdarkText,
                                                              fontSize:
                                                                  kFourteenFont,
                                                              fontWeight:
                                                                  kFW900)),
                                                      Text(
                                                          DateFormat.yMMMd()
                                                              .format(DateTime
                                                                  .parse(
                                                                claimsData["rows"]
                                                                        [index]
                                                                    ["date"],
                                                              ))
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: KdarkText
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontSize:
                                                                  kTwelveFont,
                                                              fontWeight:
                                                                  kFW700))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Text(
                                                      claimsData["rows"] != null
                                                          ? claimsData["rows"]
                                                                  [index]
                                                              ["comments"]
                                                          : SizedBox(),
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: KdarkText
                                                              .withOpacity(0.5),
                                                          fontSize: 11.sp,
                                                          fontWeight: kFW900)),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          UserSimplePreferences
                                                                      .getCurrency() ==
                                                                  "INR"
                                                              ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                              : UserSimplePreferences
                                                                          .getCurrency() ==
                                                                      "ZAR"
                                                                  ? 'R ${claimsData["rows"][index]["amount"]}'
                                                                  : claimsData["rows"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "amount"]
                                                                      .toString(),

                                                          // UserSimplePreferences
                                                          //             .getCurrency() ==
                                                          //         "INR"
                                                          //     ? '₹ ${claimsData["rows"][index]["amount"]}'
                                                          //     : 'R ${claimsData["rows"][index]["amount"]}',

                                                          //  '₹ ${claimsData["rows"][index]["amount"]}',
                                                          style: TextStyle(
                                                              color: KdarkText,
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  kFW900)),
                                                      // Image.asset(
                                                      //   "assets/images/Vector.png",
                                                      //   width: 30.w,
                                                      // )
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      )
                                    : SizedBox();
                              })),
                        ),
                      ],
                    ),
                  ), //TabBar
                ],
              ))
            : SpinKitWave(
                color: KOrange,
                size: 25,
              ),
      ),
    );
  }
}
