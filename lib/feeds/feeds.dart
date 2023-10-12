// ignore_for_file: camel_case_types, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:vibeshr/controllers/feedsController.dart';

import '../untils/export_file.dart';

class Feeds_screen extends StatefulWidget {
  const Feeds_screen({super.key});

  @override
  State<Feeds_screen> createState() => _Feeds_screenState();
}

class _Feeds_screenState extends State<Feeds_screen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  FeedController feedController = Get.put(FeedController());

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    postListHandler(pageNumber);
    storylistHandler();

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeIn, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  int pageNumber = 0;
  bool isLoading = false;
  Map postdata = {};

  bool isCompleted = false;
  bool isPostLoading = false;
  ScrollController controller = ScrollController();
  Future postListHandler(int pageNo) async {
    setState(() {
      isPostLoading = true;
    });
    Map data = await Services.postlist(pageNo);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      postdata = data;
      feedController.postdataPageNation.add(data["rows"]);
    }
    setState(() {
      isPostLoading = false;
    });
  }
Future postListHandlerAfterPost() async {
  setState(() {
    pageNumber=0;
  });
    Map data = await Services.postlist(pageNumber);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      postdata = data;
      feedController.postdataPageNation[0] = data["rows"];
      setState(() {
        
      });
    }
  }
  Future loadMorepostListHandler() async {
    setState(() {
      pageNumber = pageNumber + 1;
      isLoading = true;
    });
    Map data = await Services.postlist(pageNumber);

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      postdata = data;
      for (int i = 0; i < data["rows"].length; i++) {
        setState(() {
          feedController.postdataPageNation[0].add(data["rows"][i]);
        });
      }
      if (data["rows"].length == 0) {
        setState(() {
          isCompleted = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Map storylistdata = {};
  bool storyisLoading = false;

  Future storylistHandler() async {
    setState(() {
      storyisLoading = true;
    });
    Map data = await Services.storylist();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      storylistdata = data;
    }
    setState(() {
      storyisLoading = false;
    });
  }

  loadMore() {
    debugPrint("loadingMore");
    loadMorepostListHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kwhite,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingAction(),
        ////////appbar
        appBar: VibhoAppBar(
          bColor: Kwhite,
          title: 'Feeds',
          trailing: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(KNotification);
              },
              child: Image.asset(
                "assets/images/bell.png",
                width: 25,
              ),
            ),
          ),
          dontHaveBackAsLeading: true,
        ),
        body: storyisLoading == false && isPostLoading == false
            ? RefreshLoadmore(
                onLoadmore: () async {
                  return loadMore();
                },
                onRefresh: () async {
                  postListHandler(1);
                  storylistHandler();
                },
                scrollController: controller,
                isLastPage: isCompleted,
                child: Container(
                    margin: EdgeInsets.all(13.r),
                    child: Column(
                      children: [
                        Feed_status(
                          storydata: storylistdata,
                        ),
                        feedController.postdataPageNation[0].isNotEmpty
                            ? Story_card(
                                )
                            : const Text("No Feeds"),
                        isLoading == true
                            ? const SpinKitWave(
                                color: KOrange,
                                size: 25,
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: 40.h,
                        )
                      ],
                    )))
            : const SpinKitWave(
                color: KOrange,
                size: 25,
              )
              );
  }

  Widget FloatingAction() {
    return Container(
      margin: EdgeInsets.only(bottom: 90.h),
      child: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Bubble(
          //   title: "Lorem lpsum",
          //   iconColor: KdarkText,
          //   bubbleColor: Kwhite,
          //   icon: Icons.settings,
          //   titleStyle: TextStyle(fontSize: kTwelveFont, color: KdarkText),
          //   onPress: () {
          //     _animationController.reverse();
          //   },
          // ),
          // Floating action menu item
          Bubble(
            title: "Create Story",
            iconColor: KdarkText,
            bubbleColor: Kwhite,
            icon: Icons.post_add,
            titleStyle: TextStyle(fontSize: kTwelveFont, color: KdarkText),
            onPress: () {
              Get.toNamed(KCreate_story);
            },
          ),
          //Floating action menu item
          Bubble(
            title: "Create Post",
            iconColor: Kwhite,
            bubbleColor: KOrange,
            icon: Icons.post_add,
            titleStyle: TextStyle(fontSize: kFourteenFont, color: Kwhite),
            onPress: () async{
             var refresh =  await Get.toNamed(KCreate_post);
             postListHandlerAfterPost();
            },
          ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Kwhite,

        // Flaoting Action button Icon
        iconData: Icons.add,
        backGroundColor: KOrange,
      ),
    );
  }
}
