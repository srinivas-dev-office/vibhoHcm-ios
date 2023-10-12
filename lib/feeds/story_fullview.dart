import 'package:intl/intl.dart';
import 'package:vibeshr/untils/export_file.dart';

// ignore: camel_case_types
class Story_fullview extends StatefulWidget {
  const Story_fullview({super.key});

  @override
  State<Story_fullview> createState() => _Story_fullviewState();
}

class _Story_fullviewState extends State<Story_fullview> {
  final String COMMENTS = 'assets/images/comments.svg';
  final String VIEWS = 'assets/images/views.svg';
  final String SHARED = 'assets/images/shared.svg';
  Map postData = Get.arguments;
  bool isLoaded = false;
  Map likesData = {};
  Future createLike(int id) async {
    likesData = {};

    Map data = await Services.createlikes(id);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      likesData = data;
      if (data.isEmpty) {
        setState(() {
          postData["isLikedMobileEnd"] = 0;
          postData["likesCount"] = postData["likesCount"] - 1;
        });
      } else {
        setState(() {
          postData["isLikedMobileEnd"] = 1;
          postData["likesCount"] = postData["likesCount"] + 1;
        });
      }

      // postListHandler();
    }
  }

  Map postdata = {};
  List postdataFromAPI = [];
  bool storyisLoading = false;

  Future postListHandler(String id) async {
    setState(() {
      storyisLoading = true;
    });
    Map data = await Services.postSingleView(id);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      postData = data;
    }
    setState(() {
      storyisLoading = false;
    });
  }

  @override
  void initState() {
    if (Get.arguments["id"] != null) {
      postListHandler(Get.arguments["id"].toString());
    } else {
      storyisLoading = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      appBar: VibhoAppBar(
        bColor: Kwhite,
        title: "Post View",
        dontHaveBackAsLeading: Get.arguments['id']==null? false:true,
      ),
      body: storyisLoading == false
          ? Container(
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
                                  child: postData["PostedBy"]["profile_pic"] !=
                                          null&&postData["PostedBy"]["profile_pic"] !=
                                          ""
                                      ? CachedNetworkImage(
                          imageUrl:
                                          KProfileimage +
                                              postData["PostedBy"]
                                                  ["profile_pic"],
                                                          errorWidget: (context, url, error) =>  
                                                  Image.asset(
                                                "assets/images/pic.png",
                                                height: 180.h,
                                                fit: BoxFit.cover,
                                              ),

                                          fit: BoxFit.cover,
                                        )
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
                          Text(
                            "${postData["PostedBy"]["fname"]}${postData["PostedBy"]["lname"]}",
                            style: TextStyle(
                                fontSize: kFourteenFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                          SizedBox(
                            height: 7.w,
                          ),
                          Text(
                            postData["PostedBy"]["emp_code"].toString(),
                            style: TextStyle(
                                fontSize: kTwelveFont,
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
                            postData["description"] ?? "-",
                            style: TextStyle(
                                fontSize: kFourteenFont,
                                fontWeight: kFW700,
                                color: Klightblack),
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // PopupMenuButton(
                          //     onSelected: (value) async {
                          //       // await deleteStoryPost(
                          //       //     postData["post_id"]);
                          //     },
                          //     offset: Offset(0, 20),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(15),
                          //     ),
                          //     child: GestureDetector(
                          //       child: Icon(
                          //         Icons.more_horiz,
                          //         size: 30,
                          //       ),
                          //     ),
                          //     itemBuilder: (ctx) => [
                          //           //_buildPopupMenuItem('Delete', Icons.delete),
                          //         ]
                          //     //  itemBuilder
                          //     ),
                          Text(
                            DateFormat.yMMMd()
                                .format(DateTime.parse(postData["createdAt"]))
                                .toString(),
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW500,
                                color: Kiconcolor),
                          ),
                        ],
                      )
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
                  postData["PostFiles"].length != 0
                      ? postData["PostFiles"][0]["file"] !=
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
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: ListView.builder(
                                  itemCount: postData["PostFiles"].length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, fileindex) {
                                    return Container(
                                      // margin: EdgeInsets.only(left: 10.w),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child:
                                              // Image.asset(
                                              //       "assets/images/pic.png",
                                              //       height: 180.h,
                                              //       fit: BoxFit.cover,
                                              //     ),
CachedNetworkImage(
                          imageUrl:
                                          
                                            KpostURL + 
                                                postData["PostFiles"][0]
                                                    ["file"],
                                            height: 180.h,
                                            fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) =>  Image.asset(
                                                "assets/images/pic.png",
                                                height: 180.h,
                                                fit: BoxFit.cover,
                                              ),
                                            
                                            
                                          )),
                                    );
                                  }))
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
                              createLike(postData["post_id"]);
                            },
                            child: Row(
                              children: [
                                postData["isLikedMobileEnd"] != null &&
                                        postData["isLikedMobileEnd"] == 1
                                    ? const Icon(
                                        Icons.favorite,
                                        color: KRed,
                                      )
                                    : postData["isLiked"] == 0
                                        ? const Icon(
                                            Icons.favorite_border_outlined,
                                            color: KdarkText,
                                          )
                                        : const Icon(
                                            Icons.favorite,
                                            color: KRed,
                                          ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  postData["isLikedMobileEnd"] != null &&
                                          postData["isLikedMobileEnd"] == 1
                                      ? (int.parse(postData["likesCount"]
                                              .toString()))
                                          .toString()
                                      : postData["likesCount"] == null
                                          ? postData["PostLikes"]
                                              .length
                                              .toString()
                                          : postData["likesCount"].toString(),
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
                          GestureDetector(
                            onTap: () {
                              // Get.toNamed(KComments);
                              Get.toNamed(KComments,
                                  arguments: postData["post_id"]);
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
                                  postData["commentsCount"] == null
                                      ? postData["PostComments"]
                                          .length
                                          .toString()
                                      : postData["commentsCount"].toString(),
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
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  VIEWS,
                                  color: KCustomDarktwo,
                                ),
                                // Image.asset(
                                //   "assets/images/eye.png",
                                //   width: 22.w,
                                // ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  postData["viewsCount"] == null
                                      ? postData["PostViews"].length.toString()
                                      : postData["viewsCount"].toString(),
                                  style: TextStyle(
                                      fontSize: kTwelveFont,
                                      fontWeight: kFW600,
                                      color: KdarkText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // InkWell(
                          //   onTap: () async {
                          //     String link = await Get.put<DynamicLinkServices>(
                          //             DynamicLinkServices())
                          //         .createDynamicLink(
                          //             false, postData["post_id"]);
                          //     Share.share("Look at the post :$link");
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
            )
          : const SpinKitWave(
                      color: KOrange,
                      size: 25,
                    ),
    );
  }
}
