// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:intl/intl.dart';

import '../../untils/export_file.dart';

class Expenses_Details extends StatefulWidget {
  const Expenses_Details({super.key});

  @override
  State<Expenses_Details> createState() => _Expenses_DetailsState();
}

class _Expenses_DetailsState extends State<Expenses_Details> {
  @override
  bool isLoadingDeleted = false;
  deleteClaim(int id) async {
    setState(() {
      isLoadingDeleted = true;
    });

    Map value = await Services.deleteClaim(id);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
      Get.back();
    } else {}
    setState(() {
      isLoadingDeleted = false;
    });
  }

  HttpClient createHttpClient(SecurityContext? context) {
    return createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }

  Map claimData = Get.arguments;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbackground,
      appBar: const VibhoAppBar(
        bColor: Kbackground,
        title: "Expenses Details",
        dontHaveBackAsLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(13.r),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(13.r),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.r), color: Kwhite),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.all(13.r),
                      height: 180.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.r),
                        //border: Border.all(color: Ktextcolor)
                        //color: Kwhite,
                      ),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12.r), // Image border
                          child: claimData["ClaimDocuments"].length > 0
                              ? claimData["ClaimDocuments"][0] != null
                                  ?
                                  //   Image.file(
                                  //   File(claimData["ClaimDocuments"][0]["file_name_path"]),
                                  //   fit: BoxFit.cover,
                                  //   height: 100,
                                  //   width: 100,
                                  // )
                                  CachedNetworkImage(
                                      imageUrl: KClaimsimage +
                                          claimData["ClaimDocuments"][0]
                                              ["file_name_path"],
                                      height: 180.h,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        "assets/images/logo.png",
                                        fit: BoxFit.contain,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(child: Text("No Recepit"))
                              : const Center(child: Text("No Recepit")))),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Total Ammount',
                              style: TextStyle(
                                  color: KdarkText.withOpacity(0.5),
                                  fontSize: 11.sp,
                                  fontWeight: kFW900)),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                              UserSimplePreferences.getCurrency() == "INR"
                                  ? "₹ ${claimData["amount"]}" ?? ""
                                  : UserSimplePreferences.getCurrency() == "ZAR"
                                      ? "R ${claimData["amount"]}" ?? ""
                                      : '${claimData["amount"]}' ?? "",
                              style: TextStyle(
                                  color: KdarkText,
                                  fontSize: 13.sp,
                                  fontWeight: kFW900)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Claim Applied date',
                              style: TextStyle(
                                  color: KdarkText.withOpacity(0.5),
                                  fontSize: 11.sp,
                                  fontWeight: kFW900)),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                              DateFormat.yMMMd()
                                      .format(DateTime.parse(
                                          claimData["createdAt"]))
                                      .toString() ??
                                  "",
                              style: TextStyle(
                                  color: KdarkText,
                                  fontSize: 13.sp,
                                  fontWeight: kFW900)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description',
                              style: TextStyle(
                                  color: KdarkText.withOpacity(0.5),
                                  fontSize: 11.sp,
                                  fontWeight: kFW900)),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                              claimData["comments"] != ""
                                  ? claimData["comments"] ?? ""
                                  : "No Comments",
                              maxLines: 2,
                              style: TextStyle(
                                  color: KdarkText,
                                  fontSize: 13.sp,
                                  fontWeight: kFW900)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comments',
                              style: TextStyle(
                                  color: KdarkText.withOpacity(0.5),
                                  fontSize: 11.sp,
                                  fontWeight: kFW900)),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                              claimData["accepted_rejected_comments"] != ""
                                  ? claimData["accepted_rejected_comments"] ??
                                      ""
                                  : "No Comments",
                              maxLines: 2,
                              style: TextStyle(
                                  color: KdarkText,
                                  fontSize: 13.sp,
                                  fontWeight: kFW900)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            // Container(
            //   padding: EdgeInsets.all(10.r),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(13.r),
            //     color: Kwhite,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Ktextcolor.withOpacity(0.2),
            //         blurRadius: 10,
            //         offset: const Offset(0, 0),
            //         spreadRadius: 2, //New
            //       )
            //     ],
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           GestureDetector(
            //             onTap: () {
            //               // Get.toNamed(KProfile);
            //             },
            //             child: Container(
            //                 margin: const EdgeInsets.all(5),
            //                 height: 50.h,
            //                 width: 50.h,
            //                 decoration: BoxDecoration(
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Ktextcolor.withOpacity(0.3),
            //                       blurRadius: 10,
            //                       offset: const Offset(0, 0),
            //                       spreadRadius: 5, //New
            //                     )
            //                   ],
            //                   borderRadius: BorderRadius.circular(13.r),
            //                   color: Kwhite,
            //                 ),
            //                 child: ClipRRect(
            //                     borderRadius:
            //                         BorderRadius.circular(13.r), // Image border
            //                     child: Image.asset(
            //                       "assets/images/man.png",
            //                       fit: BoxFit.contain,
            //                     ))),
            //           ),
            //           SizedBox(
            //             width: 5.w,
            //           ),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "data",
            //                 style: TextStyle(
            //                     fontSize: 13.sp,
            //                     fontWeight: FontWeight.bold,
            //                     color: KdarkText),
            //               ),
            //               SizedBox(
            //                 height: 7.w,
            //               ),
            //               Text(
            //                 claimData["comments"] != ""
            //                     ? claimData["comments"]
            //                     : "No Comments",
            //                 style: TextStyle(
            //                     fontSize: kTwelveFont,
            //                     fontWeight: FontWeight.normal,
            //                     color: Klightblack.withOpacity(0.5)),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //       Text(
            //         claimData["is_approved"],
            //         style: TextStyle(
            //             fontSize: 11.sp,
            //             fontWeight: kFW600,
            //             color: Kgreen.withOpacity(0.7)),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 80.h,
            ),
            Column(
              children: [
                CustomButton(
                    borderRadius: BorderRadius.circular(30.r),
                    margin: EdgeInsets.all(15.r),
                    width: double.infinity,
                    height: 35.h,
                    Color: KOrange,
                    textColor: Kwhite,
                    fontSize: 13.sp,
                    fontWeight: kFW700,
                    label: "Back",
                    isLoading: false,
                    onTap: () {
                      Get.back();
                    }),
                claimData["is_approved"] == "Pending"
                    ? CustomButton(
                        borderRadius: BorderRadius.circular(30.r),
                        margin: EdgeInsets.all(15.r),
                        width: double.infinity,
                        height: 35.h,
                        Color: Kbackground,
                        textColor: KOrange,
                        fontSize: 13.sp,
                        fontWeight: kFW700,
                        label: "Delete",
                        isLoading: false,
                        onTap: () async {
                          await deleteClaim(
                            claimData["claim_id"],
                          );
                          Get.toNamed(KBottom_navigation);
                        })
                    : const SizedBox()
              ],
            )
          ],
        ),
      )),
    );
  }
}
