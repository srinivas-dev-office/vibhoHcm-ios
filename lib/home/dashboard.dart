import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:vibeshr/untils/export_file.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    homepageApi();
    hrConfigs();
    getFeedback();
    profileListApi();
    super.initState();
  }

  Map feedbackData = {};
  getFeedback() async {
    Map data = await Services.getFeedback();
    feedbackData = data;
  }

  Map profiledata = {};
  Map hrconfigs = {};

  bool isLoading = false;
  bool isProfileLoading = false;
  Future profileListApi() async {
    setState(() {
      isProfileLoading = true;
    });
    Map data = await Services.employeeprofile();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      profiledata = data["Employee"];
    }
    setState(() {
      isProfileLoading = false;
    });
  }

  hrConfigs() async {
    setState(() {
      isProfileLoading = true;
    });
    Map data = await Services.hrRequestApprovalConfigs();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      hrconfigs = data;
    }
    setState(() {
      isProfileLoading = false;
    });
  }

  Map homedata = {};

  Future homepageApi() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.employeehome();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      homedata = data;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    // UpgradeAlert(
    //     child: 
        Scaffold(
      backgroundColor: Kwhite,
      //  backgroundColor: Kbackground,
      appBar: const HomeAppBar(),
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 90.h),
          child: FloatingActionButton(
            backgroundColor: KOrange,
            onPressed: () async{
             await Get.toNamed(Kchat);
             setState(() {
               
             });
            },
            child: Icon(
              Icons.chat,
              color: Kwhite,
              size: 25.r,
            ),
          )),
      body: DynMouseScroll(
          durationMS: 500,
          scrollSpeed: 8,
          mobilePhysics: AlwaysScrollableScrollPhysics(),
          builder: (context, controller, physics) => ListView(
                controller: controller,
                physics: physics,
                children: [
                  isLoading == false && isProfileLoading == false
                      ? Container(
                          margin: EdgeInsets.all(13.r),
                          child: Column(
                            children: [
                              const Welcome_card(),
                              SizedBox(
                                height: 25.h,
                              ),
                              Login_time(
                                homedir: homedata,
                              ),
                              SizedBox(
                                height: 23.h,
                              ),
                              const Requests_Screen(),
                              SizedBox(
                                height: 20.h,
                              ),
                              Categories_Screen(
                                homedir: profiledata,
                                hrconfigs: hrconfigs,
                                feedback: feedbackData,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              const Holiday(),
                            ],
                          ),
                        )
                      : const Center(
                          child: SpinKitWave(
                            color: KOrange,
                            size: 25,
                          ),
                        )
                ],
              )

          // SingleChildScrollView(
          //     child: isLoading == false && isProfileLoading == false
          //         ?
          //         Container(
          //             margin: EdgeInsets.all(13.r),
          //             child: Column(
          //               children: [
          //                 const Welcome_card(),
          //                 SizedBox(
          //                   height: 25.h,
          //                 ),
          //                 Login_time(
          //                   homedir: homedata,
          //                 ),
          //                 SizedBox(
          //                   height: 23.h,
          //                 ),
          //                 const Requests_Screen(),
          //                 SizedBox(
          //                   height: 20.h,
          //                 ),
          //                 Categories_Screen(
          //                     homedir: profiledata, hrconfigs: hrconfigs),
          //                 SizedBox(
          //                   height: 20.h,
          //                 ),
          //                 const Holiday(),
          //               ],
          //             ),
          //           )

          //         : const Center(
          //             child: SpinKitWave(
          //               color: KOrange,
          //               size: 25,
          //             ),
          //           )
          //           ),

          ),
    );
   // );
  }
}
