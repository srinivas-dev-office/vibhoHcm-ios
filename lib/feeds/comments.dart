// ignore_for_file: prefer_const_constructors, sort_child_properties_last, camel_case_types

import 'package:comment_tree/comment_tree.dart';
import 'package:vibeshr/controllers/feedsController.dart';

import '../untils/export_file.dart';
import 'package:intl/intl.dart';

class Comments_view extends StatefulWidget {
  const Comments_view({super.key});

  @override
  State<Comments_view> createState() => _Comments_viewState();
}

class commontdata {
  String postid = '';
  String comment = '';
}

class Subcommontdata {
  int postCommentid = -1;
  String comment = '';
  String nameOfPerson = '';
}

class _Comments_viewState extends State<Comments_view> {
  TextEditingController commentController = TextEditingController();
  FeedController feedController = Get.find<FeedController>();

  int subCommentid = -1;
  bool isLoading = false;
  commontdata data = commontdata();
  Subcommontdata subCommentData = Subcommontdata();
  /////getcomments
  List commentdata = [];
  Future commentListHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.commentlist();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      commentdata = data["rows"];
    }
    setState(() {
      isLoading = false;
    });
  }

////////////////////////////DeletePostComments
  bool isLoadingDeleted = false;
  deletePostComment(int id) async {
    setState(() {
      isLoadingDeleted = true;
    });

    Map value = await Services.deletePostComments(id);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
      for (int i = 0; i < commentdata.length; i++) {
        if (id == commentdata[i]["post_comment_id"]) {
          setState(() {
            commentdata.remove(commentdata[i]);
          });
        }
      }
    } else {}
    setState(() {
      isLoadingDeleted = false;
    });
  }

/////post comments
  Future createcommentHandler() async {
    setState(() {
      isLoading = true;
    });
    Map payload = {
      "post_id": feedController.postidtoCreateComment["post_id"],
      "description": data.comment,
    };

    Map value = await Services.createcomment(payload);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {
      Get.back(result: "refresh");
    }
    print(value);
    setState(() {
      isLoading = false;
    });
  }

  ///.////Sub comments
  Future createsubcommentHandler() async {
    setState(() {
      isLoading = true;
    });
    Map payload = {
      "post_comment_id": subCommentData.postCommentid,
      "post_id": feedController.postidtoCreateComment["post_id"],
      "description": subCommentData.comment,
    };

    Map value = await Services.createsubcomment(payload);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {
      Get.back();
    }
    print(value);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    commentListHandler();
    super.initState();
  }

  FocusNode myfocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbackground,
      bottomSheet: Container(
        margin: EdgeInsets.all(13.r),
        child: CustomFormField(
            maxLines: 1,
            readOnly: false,
            labelText: "Comment",
            focusNode: myfocus,
            controller: commentController,
            hintText: "comment",
            onChanged: (value) {
              subCommentData.postCommentid == -1
                  ? data.comment = value
                  : subCommentData.comment = value;
            },
            prefix: Padding(
              padding: EdgeInsets.only(top: 12.h, left: 5),
              child: Text(
                "${subCommentData.nameOfPerson}",
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
            suffix: InkWell(
              onTap: () {
                subCommentData.postCommentid == -1
                    ? {
                        createcommentHandler(),
                        feedController.incrementCommentCount(
                            feedController.postidtoCreateComment["post_id"]),
                      }
                    : createsubcommentHandler();
              },
              child: Icon(
                Icons.send,
                color: KOrange,
              ),
            )),
      ),
      appBar: const VibhoAppBar(
        title: "Comments",
        bColor: Kbackground,
        dashboard: false,
      ),
      body: isLoading == false
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: commentdata.length,
                      itemBuilder: (context, index) {
                        return commentdata[index]["post_id"] ==
                                feedController.postidtoCreateComment["post_id"]
                            ? Container(
                                child: CommentTreeWidget<Comment, Comment>(
                                  Comment(
                                      avatar: 'assets/images/man.png',
                                      userName: 'null',
                                      content: "main"),
                                  [
                                    for (int i = 0;
                                        i <
                                            commentdata[index]
                                                    ["PostSubComments"]
                                                .length;
                                        i++) ...[
                                      Comment(
                                          avatar: 'assets/images/man.png',
                                          userName: 'null',
                                          content: commentdata[index]
                                                      ["PostSubComments"][i]
                                                  ["description"]
                                              .toString())
                                    ]
                                  ],
                                  treeThemeData: TreeThemeData(
                                      lineColor: Ktextcolor, lineWidth: 1),
                                  avatarRoot: (context, data) => PreferredSize(
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: KOrange,
                                      // backgroundImage:
                                      //     AssetImage('assets/images/man.png'),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: commentdata[index]
                                                            ['PostCommentedBy']
                                                        ["profile_pic"] !=
                                                    null &&
                                                commentdata[index]
                                                            ['PostCommentedBy']
                                                        ["profile_pic"] !=
                                                    ""
// <<<<<<< Nayak_fix_bugs_on_fourth
//                                             ? Image(
//                                                 image: NetworkImage(
//                                                   KProfileimage +
//                                                       commentdata[index][
//                                                               'PostCommentedBy']
//                                                           ["profile_pic"],
//                                                   // KProfileimage +
//                                                   //     feedController.postdataPageNation[
//                                                   //                 0][index]
//                                                   //             ["PostedBy"]
//                                                   //         ["profile_pic"],
//                                                 ),
//                                                 errorBuilder: (c, o, s) =>
//                                                     Image.asset(
//                                                   "assets/images/man.png",
//                                                   fit: BoxFit.cover,
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
// =======
                                            ? CachedNetworkImage(
                                                      imageUrl:
                                                KProfileimage +
                                                    commentdata[index]
                                                            ['PostCommentedBy']
                                                        ["profile_pic"],

// >>>>>>> master
                                                fit: BoxFit.fill,
                                              )
                                            // Image.network(
                                            //     KProfileimage +
                                            //         commentdata[index]
                                            //                 ['PostCommentedBy']
                                            //             ["profile_pic"],

                                            //     fit: BoxFit.fill,
                                            //     height: 40,
                                            //     width: 40,
                                            //     // errorBuilder: (BuildContext context,
                                            //     //     Object exception, StackTrace? stackTrace) {
                                            //     //   return Image.asset(
                                            //     //     "assets/images/pic.png",
                                            //     //      height: 180.h,
                                            //     // fit: BoxFit.cover,
                                            //     //   );
                                            //     // },
                                            //   )
                                            : Image.asset(
                                                "assets/images/man.png",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    preferredSize: Size.fromRadius(18),
                                  ),
                                  avatarChild: (context, data) => PreferredSize(
                                    child: CircleAvatar(
                                      radius: 20,
                                      // backgroundColor: KOrange.withOpacity(0.5),
                                      // backgroundImage: ,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: commentdata[index]
                                                            ['PostCommentedBy']
                                                        ["profile_pic"] !=
                                                    null &&
                                                commentdata[index]
                                                            ['PostCommentedBy']
                                                        ["profile_pic"] !=
                                                    ""
                                            ? CachedNetworkImage(
                                                      imageUrl:
                                                KProfileimage +
                                                    commentdata[index]
                                                            ['PostCommentedBy']
                                                        ["profile_pic"],

                                                fit: BoxFit.fill,
                                                height: 40,
                                                width: 40,
                                                // errorBuilder: (BuildContext context,
                                                //     Object exception, StackTrace? stackTrace) {
                                                //   return Image.asset(
                                                //     "assets/images/pic.png",
                                                //      height: 180.h,
                                                // fit: BoxFit.cover,
                                                //   );
                                                // },
                                              )
                                            : Image.asset(
                                                "assets/images/man.png",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    preferredSize: Size.fromRadius(12),
                                  ),
                                  contentChild: (context, data) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${commentdata[index]['PostSubComments'][0]['PostSubCommentBy']["fname"]}${commentdata[index]['PostSubComments'][0]['PostSubCommentBy']["lname"]}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: KdarkText
                                                                .withOpacity(
                                                                    0.8)),
                                                  ),
                                                  SizedBox(
                                                    width: 5.h,
                                                  ),
                                                  Text(
                                                    //'yyyy-MM-dd HH:mm:ss'
                                                    DateFormat('yyyy-MMM-dd')
                                                        .format(DateTime.parse(
                                                            commentdata[index][
                                                                    'PostSubComments']
                                                                [
                                                                0]["updatedAt"])),

                                                    //  'Reminder for Interview in next 30 min',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        ?.copyWith(
                                                            fontSize: kTenFont,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: KdarkText
                                                                .withOpacity(
                                                                    0.8)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              // Text(
                                              //  "${commentdata[index]['PostSubComments'][0]["updatedAt"]}",
                                              //   style: Theme.of(context)
                                              //       .textTheme
                                              //       .caption
                                              //       ?.copyWith(
                                              //           fontWeight:
                                              //               FontWeight.w600,
                                              //           color: KdarkText
                                              //               .withOpacity(0.8)),
                                              // ),

                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '${data.content}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Ktextcolor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // DefaultTextStyle(
                                        //   style: Theme.of(context).textTheme.caption!.copyWith(
                                        //       color: Colors.grey[700], fontWeight: FontWeight.bold),
                                        //   child: Padding(
                                        //     padding: EdgeInsets.only(top: 4),
                                        //     child: Row(
                                        //       children: [
                                        //         SizedBox(
                                        //           width: 8,
                                        //         ),
                                        //         Text('Like'),
                                        //         SizedBox(
                                        //           width: 24,
                                        //         ),
                                        //         Text('Reply'),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    );
                                  },
                                  contentRoot: (context, data) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${commentdata[index]['PostCommentedBy']['fname']}${commentdata[index]['PostCommentedBy']['lname']}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: KOrange),
                                                  ),
                                                  Text(
                                                    //'yyyy-MM-dd HH:mm:ss'
                                                    DateFormat('yyyy-MMM-dd')
                                                        .format(DateTime.parse(
                                                            commentdata[index]
                                                                ["updatedAt"])),

                                                    //  'Reminder for Interview in next 30 min',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption
                                                        ?.copyWith(
                                                            fontSize: kTenFont,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: KdarkText
                                                                .withOpacity(
                                                                    0.8)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                commentdata[index] != null
                                                    ? '${commentdata[index]['description']}'
                                                    : "-",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        fontSize: 11.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DefaultTextStyle(
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        subCommentData
                                                                .postCommentid =
                                                            commentdata[index][
                                                                "post_comment_id"];
                                                        subCommentData
                                                                .nameOfPerson =
                                                            commentdata[index][
                                                                    "PostCommentedBy"]
                                                                ["fname"];
                                                      });
                                                      setState(() {
                                                        myfocus.requestFocus();
                                                      });
                                                    },
                                                    child: Text('Reply')),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                feedController.empProfile[
                                                            "username"] ==
                                                        commentdata[index][
                                                                'PostCommentedBy']
                                                            ["emp_code"]
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          feedController
                                                              .decreementCommentCount(
                                                                  feedController
                                                                          .postidtoCreateComment[
                                                                      "post_id"]);

                                                          await deletePostComment(
                                                              commentdata[index]
                                                                  [
                                                                  'post_comment_id']
                                                              //claimData["claim_id"],
                                                              );
                                                          // Get.toNamed(
                                                          //     KBottom_navigation);
                                                        },
                                                        //                     onTap: (value) async {
                                                        //   await deleteStoryPost(
                                                        //       postdataPageNation[0][index]["post_id"]);
                                                        // },
                                                        // onTap: () {},
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: KRed),
                                                        ))
                                                    : SizedBox()
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              )
                            : SizedBox();
                      }),
                  SizedBox(
                    height: 70.h,
                  ),
                ],
              ),
            )
          : const Center(
              child: SpinKitWave(
              color: KOrange,
              size: 15,
            )),
    );
  }
}
