// ignore_for_file: camel_case_types

import 'package:intl/intl.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:vibeshr/controllers/feedsController.dart';

import '../untils/export_file.dart';

class Story_card extends StatefulWidget {
  Story_card({Key? key}) : super(key: key);

  @override
  State<Story_card> createState() => _StorycardState();
}

class _StorycardState extends State<Story_card> {
  FeedController feedController = Get.find<FeedController>();

  // List postdataPageNation = [];
  Map likesData = {};
  int likingIndex = 0;
  bool isLoading = false;
  bool likeing = false;
  Future createLike(int id, int index) async {
    likesData = {};
    setState(() {
      likeing = true;
    });
    Map data = await Services.createlikes(id);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      likesData = data;
      if (data.isNotEmpty) {
        setState(() {
          feedController.postdataPageNation[0][index]["isLiked"] = 1;
          feedController.postdataPageNation[0][index]["likesCount"] =
              feedController.postdataPageNation[0][index]["likesCount"] + 1;
        });
      } else {
        setState(() {
          feedController.postdataPageNation[0][index]["isLiked"] = 0;
          if (feedController.postdataPageNation[0][index]["likesCount"] > 0) {
            feedController.postdataPageNation[0][index]["likesCount"] =
                feedController.postdataPageNation[0][index]["likesCount"] - 1;
          } else {
            feedController.postdataPageNation[0][index]["likesCount"] = 0;
          }
        });
      }
      // if (data.isEmpty) {
      //   setState(() {
      //     feedController.postdataPageNation[0][index]["isLikedMobileEnd"] = 0;
      //     feedController.postdataPageNation[0][index]["likesCount"] =
      //         feedController.postdataPageNation[0][index]["likesCount"] - 1;
      //   });
      // } else {
      //   setState(() {
      //     feedController.postdataPageNation[0][index]["isLikedMobileEnd"] = 1;
      //     feedController.postdataPageNation[0][index]["likesCount"] =
      //         feedController.postdataPageNation[0][index]["likesCount"] + 1;
      //   });
      // }
      setState(() {
        likeing = false;
      });
      // postListHandler();
    }
  }

  Future postListHandler(int pageNo) async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.postlist(pageNo);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      feedController.postdataPageNation.add(data["rows"]);
    }
    setState(() {
      isLoading = false;
    });
  }

  ///////////////////////
  bool isLoadingDeleted = false;
  deleteStoryPost(int id) async {
    setState(() {
      isLoadingDeleted = true;
    });

    Map value = await Services.deleteStoryPost(id);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
      for (int i = 0; i < feedController.postdataPageNation[0].length; i++) {
        if (id == feedController.postdataPageNation[0][i]["post_id"]) {
          setState(() {
            feedController.postdataPageNation[0]
                .remove(feedController.postdataPageNation[0][i]);
          });
        }
      }
    } else {}
    setState(() {
      isLoadingDeleted = false;
    });
  }
  ////////////////////////

  callLikesHander() {
    for (int i = 0; i < feedController.postdataPageNation[0].length; i++) {
      feedController.postdataPageNation[0][i]["isLikedMobileEnd"] =
          feedController.postdataPageNation[0][i]["isLiked"];
    }
  }

  final String COMMENTS = 'assets/images/comments.svg';
  final String VIEWS = 'assets/images/views.svg';
  final String SHARED = 'assets/images/shared.svg';
  bool isLoaded = false;
  int pageNumber = 0;

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData) {
    return PopupMenuItem(
      value: "1",
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: kTwelveFont, fontWeight: kFW600, color: KdarkText),
          ),
        ],
      ),
    );
  }

  void initState() {
    callLikesHander();
    super.initState();
  }

  String? x;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DynMouseScroll(
          durationMS: 500,
          scrollSpeed: 8,
          builder: (context, controller, physics) => ListView.builder(
              shrinkWrap: true,
              controller: controller,
              // controller: controller,
              physics: NeverScrollableScrollPhysics(),
              itemCount: feedController.postdataPageNation[0].length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Get.toNamed(KStory_fullview,
                    //     arguments: feedController.postdataPageNation[0][index]);
                    //NavigatetoSInglePage
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5.h, bottom: 16.h),
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        color: Kbackground.withOpacity(0.8),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Ktextcolor.withOpacity(0.4),
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 0),
                        //     spreadRadius: 1,
                        //   )
                        // ],
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                    margin: const EdgeInsets.all(5),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13.r),
                                      color: Kwhite,
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            13.r), // Image border
                                        child: feedController.postdataPageNation[
                                                            0][index]["PostedBy"]
                                                        ["profile_pic"] !=
                                                    null &&
                                                feedController.postdataPageNation[
                                                                0][index]
                                                            ["PostedBy"]
                                                        ["profile_pic"] !=
                                                    ""
// <<<<<<< Nayak_fix_bugs_on_fourth
//                                             ? Image(
//                                                 image: NetworkImage(
//                                                   KProfileimage +
//                                                       feedController.postdataPageNation[
//                                                                   0][index]
//                                                               ["PostedBy"]
//                                                           ["profile_pic"],
//                                                 ),
//                                                 errorBuilder: (c, o, s) =>
//                                                     Image.asset(
//                                                   "assets/images/man.png",
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                                 // Center(
//                                                 //   child: Text(
//                                                 //     "Unable to Load Image",
//                                                 //     style: GoogleFonts.gothicA1(
//                                                 //       fontSize: kFourteenFont,
//                                                 //       color: white,
//                                                 //       fontWeight: kFW700,
//                                                 //     ),
//                                                 //   ),
//                                                 // ),
//                                                 fit: BoxFit.fill,
// =======
                                            ? CachedNetworkImage(
                          imageUrl:
                                                KProfileimage +
                                                    feedController
                                                                .postdataPageNation[
                                                            0][index]["PostedBy"]
                                                        ["profile_pic"],
                                                // errorBuilder: (BuildContext context,
                                                //     Object exception,
                                                //     StackTrace? stackTrace) {
                                                //   return Image.asset(
                                                //     "assets/images/man.png",
                                                //     fit: BoxFit.contain,
                                                //   );
                                                // },
                                                fit: BoxFit.cover,
// >>>>>>> master
                                              )
                                            // Image.network(
                                            //     KProfileimage +
                                            //         feedController
                                            //                     .postdataPageNation[
                                            //                 0][index]["PostedBy"]
                                            //             ["profile_pic"],
                                            //     // errorBuilder: (BuildContext context,
                                            //     //     Object exception,
                                            //     //     StackTrace? stackTrace) {
                                            //     //   return Image.asset(
                                            //     //     "assets/images/man.png",
                                            //     //     fit: BoxFit.contain,
                                            //     //   );
                                            //     // },
                                            //     fit: BoxFit.cover,
                                            //   )
                                            : Image.asset(
                                                "assets/images/man.png",
                                                fit: BoxFit.contain,
                                              ))),
                                Positioned(
                                    top: 4.h,
                                    right: 2.w,
                                    child: const CircleAvatar(
                                      backgroundColor: Kwhite,
                                      radius: 6,
                                      child: Center(
                                          child: Icon(Icons.circle_rounded,
                                              size: 10, color: Kgreen)),
                                    ))
                              ],
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: Text(
                                    "${feedController.postdataPageNation[0][index]["PostedBy"]["fname"]}${feedController.postdataPageNation[0][index]["PostedBy"]["lname"]}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: kFourteenFont,
                                        fontWeight: kFW700,
                                        color: KdarkText),
                                  ),
                                ),
                                SizedBox(
                                  height: 7.w,
                                ),
                                Text(
                                  feedController.postdataPageNation[0][index]
                                      ["PostedBy"]["emp_code"],
                                  style: TextStyle(
                                      fontSize: kTwelveFont,
                                      fontWeight: kFW600,
                                      color: Klightblack.withOpacity(0.8)),
                                ),
                                SizedBox(
                                  height: 7.w,
                                ),
                                Text(
                                  DateFormat("dd-MMM-yy").format(DateTime.parse(
                                      feedController.postdataPageNation[0]
                                          [index]["createdAt"])),
                                  style: TextStyle(
                                      fontSize: kTenFont,
                                      fontWeight: kFW500,
                                      color: Klightblack.withOpacity(0.8)),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 220.w,
                                child: Text(
                                  feedController.postdataPageNation[0][index]
                                          ["description"] ??
                                      "-",
                                  style: TextStyle(
                                      fontSize: kFourteenFont,
                                      fontWeight: kFW700,
                                      color: Klightblack),
                                )),
                            feedController.empProfile["emp_id"] ==
                                    feedController.postdataPageNation[0][index]
                                        ["emp_id"]
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      PopupMenuButton(
                                          onSelected: (value) async {
                                            await deleteStoryPost(feedController
                                                    .postdataPageNation[0]
                                                [index]["post_id"]);
                                          },
                                          offset: const Offset(0, 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.more_horiz,
                                              size: 30,
                                            ),
                                          ),
                                          itemBuilder: (ctx) => [
                                                _buildPopupMenuItem(
                                                    'Delete', Icons.delete),
                                              ]
                                          //  itemBuilder
                                          ),
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(DateTime.parse(
                                                feedController
                                                        .postdataPageNation[0]
                                                    [index]["createdAt"]))
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: kFW500,
                                            color: Kiconcolor),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        ),
                        // SizedBox(
                        //   height: 15.h,
                        // ),
                        // Text(
                        //   "https://vibeshr.com/mob-application/",
                        //   textAlign: TextAlign.start,
                        //   style: TextStyle(
                        //       fontSize: kTwelveFont,
                        //       fontWeight: kFW600,
                        //       color: Kbluedark),
                        // ),
                        SizedBox(
                          height: 15.h,
                        ),
                        feedController.postdataPageNation[0][index]["PostFiles"]
                                    .length !=
                                0
                            ? feedController.postdataPageNation[0][index]
                                        ["PostFiles"][0]["file"] !=
                                    "Something went wrong"
                                ? Container(
                                    width: double.infinity,
                                    height: 180.h,

                                    decoration: BoxDecoration(
                                        color: Kwhite,
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Ktextcolor.withOpacity(0.3),
                                        //     blurRadius: 10,
                                        //     offset: const Offset(0, 0),
                                        //     spreadRadius: 2,
                                        //   )
                                        // ],
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: KpostURL +
                                              feedController
                                                          .postdataPageNation[0]
                                                      [index]["PostFiles"][0]
                                                  ["file"],
                                          height: 180.h,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/images/pic.png",
                                            height: 180.h,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    // }),
                                  )
                                : const SizedBox()
                            : const SizedBox(),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    createLike(
                                        feedController.postdataPageNation[0]
                                            [index]["post_id"],
                                        index);
                                    setState(() {
                                      likingIndex = index;
                                      // feedController.postdataPageNation[0]
                                      //         [index]["isLikedMobileEnd"] =
                                      //     !feedController.postdataPageNation[0]
                                      //         [index]["isLikedMobileEnd"];
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      likeing == true && index == likingIndex
                                          ? const SpinKitWave(
                                              color: KOrange,
                                              size: 15,
                                            )
                                          : feedController.postdataPageNation[0]
                                                      [index]["isLiked"] ==
                                                  0
                                              ? const Icon(
                                                  Icons
                                                      .thumb_up_off_alt_outlined,
                                                  color: KdarkText,
                                                )
                                              : const Icon(
                                                  Icons.thumb_up_sharp,
                                                  color: KRed,
                                                ),
                                      // feedController.postdataPageNation[0]
                                      //                     [index][
                                      //                 "isLikedMobileEnd"] !=
                                      //             null &&
                                      //         feedController.postdataPageNation[0]
                                      //                     [index][
                                      //                 "isLikedMobileEnd"] ==
                                      //             1
                                      // ? const Icon(
                                      //     Icons.thumb_up_sharp,
                                      //     color: KRed,
                                      //   )
                                      //     : feedController.postdataPageNation[0][index]["isLikedMobileEnd"] !=
                                      //                 null &&
                                      //             feedController.postdataPageNation[0]
                                      //                         [index]
                                      //                     ["isLikedMobileEnd"] ==
                                      //                 0
                                      // ? const Icon(
                                      //     Icons
                                      //         .thumb_up_off_alt_outlined,
                                      //     color: KdarkText,
                                      //   )
                                      //         : feedController.postdataPageNation[0][index]["isLiked"] == 0
                                      //             ? const Icon(
                                      //                 Icons
                                      //                     .thumb_up_off_alt_outlined,
                                      //                 color: KdarkText,
                                      //               )
                                      //             : const Icon(
                                      //                 Icons.thumb_up_sharp,
                                      //                 color: KRed,
                                      //               ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        feedController.postdataPageNation[0]
                                                            [index]
                                                        ["isLikedMobileEnd"] !=
                                                    null &&
                                                feedController.postdataPageNation[0]
                                                            [index]
                                                        ["isLikedMobileEnd"] ==
                                                    1
                                            ? (int.parse(feedController
                                                    .postdataPageNation[0]
                                                        [index]["likesCount"]
                                                    .toString()))
                                                .toString()
                                            : feedController
                                                .postdataPageNation[0][index]
                                                    ["likesCount"]
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: kTwelveFont,
                                            fontWeight: kFW600,
                                            color: KdarkText),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GetX<FeedController>(
                                    init: FeedController(),
                                    builder: (sController) => GestureDetector(
                                          onTap: () async {
                                            sController.createComment(
                                                sController
                                                        .postdataPageNation[0]
                                                    [index]);
                                            x = await Get.to(
                                                const Comments_view());
                                            setState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                COMMENTS,
                                                color: KCustomDarktwo,
                                              ),
                                              // Image.asset(
                                              //   "assets/images/chat.png",
                                              //   width: 22.w,
                                              // ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                sController
                                                    .postdataPageNation[0]
                                                        [index]["commentsCount"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: kTwelveFont,
                                                    fontWeight: kFW600,
                                                    color: KdarkText),
                                              ),
                                            ],
                                          ),
                                        )),
                                // SizedBox(
                                //   width: 20.w,
                                // ),
                                // GestureDetector(
                                //   onTap: () {},
                                //   child: Row(
                                //     children: [
                                //       SvgPicture.asset(
                                //         VIEWS,
                                //         color: KCustomDarktwo,
                                //       ),
                                //       // Image.asset(
                                //       //   "assets/images/eye.png",
                                //       //   width: 22.w,
                                //       // ),
                                //       SizedBox(
                                //         width: 5.w,
                                //       ),
                                //       Text(
                                //         feedController.postdataPageNation[0]
                                //                 [index]["viewsCount"]
                                //             .toString(),
                                //         style: TextStyle(
                                //             fontSize: kTwelveFont,
                                //             fontWeight: kFW600,
                                //             color: KdarkText),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            Row(
                              children: [
                                // InkWell(
                                //   onTap: ()async {
                                //     String link = await Get.put<DynamicLinkServices>(
                                //             DynamicLinkServices())
                                //         .createDynamicLink(
                                //             false, postdataPageNation[0][index]["post_id"]);
                                //     Share.share("Look at the post :$link");
                                //     // Share.share(
                                //     //     "Description :${postdataPageNation[0][index]["description"]}\n  ${KpostURL + postdataPageNation[0][index]["PostFiles"][0]["file"]}");
                                //   },
                                //   child: SvgPicture.asset(
                                //     SHARED,
                                //     color: KCustomDarktwo,
                                //   ),
                                //   // Image.asset(
                                //   //   "assets/images/share.png",
                                //   //   width: 23.w,
                                //   // ),
                                // ),
                                SizedBox(
                                  width: 10.w,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    );
    // )
    // : const Loading();
  }

  void loadmore() {
    debugPrint("HI");
    setState(() {
      postListHandler(pageNumber + 1);
    });
  }
}
