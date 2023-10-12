// ignore_for_file: camel_case_types, sort_child_properties_last

import '../untils/export_file.dart';

class Bottom_navigation extends StatefulWidget {
  const Bottom_navigation({super.key});

  @override
  State<Bottom_navigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottom_navigation> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  DateTime timeBackPressed = DateTime.now();
  final String HOMES = 'assets/images/homes.svg';
  final String FEEDS = 'assets/images/feeds.svg';
  final String SELECTEDFEEDS = 'assets/images/selectedfeeds.svg';
  final String SELECTEDHOMES = 'assets/images/selectedhomes.svg';
  final String SELECTEDPROFILES = 'assets/images/selectedprofiles.svg';
  final String PROFILES = 'assets/images/profiles.svg';
  final String SELECTEDACTIONS = 'assets/images/selectedactions.svg';
  final String ACTIONS = 'assets/images/actions.svg';
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(seconds: 2);
          timeBackPressed = DateTime.now();

          if (isExitWarning) {
            const message = 'Press back again to exit';
            Fluttertoast.showToast(
              msg: message,
              fontSize: kTwelveFont,
              textColor: KdarkText,
              backgroundColor: Kwhite,
            );
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
            extendBody: true,
            body: PageView(
              children: _buildThreePageViewChildren(),
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(
                  () {
                    _pageIndex = index;
                  },
                );
              },
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(10.r),
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(10, 0),
                    color: Ktextcolor.withOpacity(0.2),
                  )
                ],
                borderRadius: BorderRadius.circular(30.r),
                color: Kwhite,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: BottomNavigationBar(
                  elevation: 10,
                  backgroundColor: Kwhite,
                  selectedItemColor: KOrange,
                  unselectedItemColor: Klightgray,
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                  type: BottomNavigationBarType.fixed,
                  items: _buildThreeItems(),
                  onTap: (int index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  },
                  currentIndex: _pageIndex,
                ),
              ),
            )));
  }

  List<Widget> _buildThreePageViewChildren() {
    return <Widget>[
      const DashBoard(),
      const Feeds_screen(),
      const Action_screen(),
      Profile_view(
        BACK: 1,
      ),
    ];
  }

  List<BottomNavigationBarItem> _buildThreeItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: SvgPicture.asset(
            _pageIndex == 0 ? SELECTEDHOMES : HOMES,
            width: _pageIndex == 0 ? 16.w : 14.w,
            // color: _pageIndex == 0 ? KOrange : Klightgray
          ),
        ),
        // ImageIcon(
        //     SvgPicture.asset(
        //                           HOMES,
        //                           color: currentTab == 0 ? KOrange : Klightgray,
        //                           width: currentTab == 0
        //                               ? kSixteenFont
        //                               : kTwelveFont,
        //                         ),
        //   //  AssetImage("assets/images/home.png"),
        //   size: 25.w,
        // ),

        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: SvgPicture.asset(
            _pageIndex == 1 ? SELECTEDFEEDS : FEEDS,
            width: _pageIndex == 1 ? 20.w : 16.w,
            //   color: _pageIndex == 1 ? KOrange : Klightgray
          ),
        ),
        label: 'Feeds',
      ),

      // BottomNavigationBarItem(
      //   icon: ImageIcon(
      //     AssetImage(
      //       "assets/images/profile1.png",
      //     ),
      //     size: 20.w,
      //   ),
      //   label: 'Profile',
      // ),
      BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: SvgPicture.asset(
            _pageIndex == 2 ? SELECTEDACTIONS : ACTIONS,
            width: _pageIndex == 2 ? 20.w : 16.w,
            //  color: _pageIndex == 3 ? KOrange : Klightgray
          ),
        ),
        label: 'Actions',
      ),
      BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: SvgPicture.asset(
            _pageIndex == 3 ? SELECTEDPROFILES : PROFILES,
            width: _pageIndex == 3 ? 24.w : 9.w,
            // color: _pageIndex == 2 ? KOrange : Klightgray
          ),
        ),
        label: 'Profile',
      ),
      // BottomNavigationBarItem(
      //   icon: ImageIcon(
      //     const AssetImage("assets/images/fire.png"),
      //     size: 20.w,
      //   ),
      //   label: 'Action',
      // ),
    ];
  }
}

// class _BottomnavigationState extends State<Bottom_navigation> {
//   DateTime timeBackPressed = DateTime.now();
//   int currentTab = 0; // to keep track of active tab index
//   final List<Widget> screens = [
//     const DashBoard(),
//     const Feeds_screen(),
//     const Profile_view(),
//     const Action_screen(),
//     // const Home_Screen(),
//     // const AllServiesScreen(),
//     // const Chat_Screen(),
//     // const Menu_Screen(),
//   ]; // to store nested tabs
//   final PageStorageBucket bucket = PageStorageBucket();
//   Widget currentScreen = const DashBoard();
//   // Our first view in viewport
//   final String HOMES = 'assets/images/homes.svg';
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           final difference = DateTime.now().difference(timeBackPressed);
//           final isExitWarning = difference >= const Duration(seconds: 2);
//           timeBackPressed = DateTime.now();

//           if (isExitWarning) {
//             const message = 'Press back again to exit';
//             Fluttertoast.showToast(
//               msg: message,
//               fontSize: kTwelveFont,
//               textColor: KdarkText,
//               backgroundColor: Kwhite,
//             );
//             return false;
//           } else {
//             SystemNavigator.pop();
//             return true;
//           }
//         },
//         child: SafeArea(
//             child: Scaffold(
//           body: PageStorage(
//             child: currentScreen,
//             bucket: bucket,
//           ),
//           // floatingActionButton: FloatingActionButton(
//           //   backgroundColor: Colors.white,
//           //   elevation: 3,
//           //   child: Image.asset(
//           //     'assets/images/scan.png',
//           //     width: 33.w,
//           //   ),
//           //   onPressed: () {
//           //     Get.toNamed(KQrcode);
//           //   },
//           // ),
//           // floatingActionButtonLocation:
//           //     FloatingActionButtonLocation.miniCenterDocked,
//           bottomNavigationBar: Container(
//             margin: EdgeInsets.all(10.r),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30.r),
//               color: Kwhite,
//             ),
//             height: 70.h,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30.r),
//               child: BottomAppBar(
//                 shape: const CircularNotchedRectangle(),
//                 notchMargin: 0,
//                 elevation: 0,
//                 child: Container(
//                   height: 60,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(
//                             width: 5.w,
//                           ),
//                           MaterialButton(
//                             minWidth: 40,
//                             onPressed: () {
//                               setState(() {
//                                 currentScreen =
//                                     const DashBoard(); // if user taps on this dashboard tab will be active
//                                 currentTab = 0;
//                               });
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 SvgPicture.asset(
//                                   HOMES,
//                                   color: currentTab == 0 ? KOrange : Klightgray,
//                                   width: currentTab == 0
//                                       ? kSixteenFont
//                                       : kTwelveFont,
//                                 ),
//                                 // Image.asset(
//                                 //   'assets/images/home.png',
//                                 //   width: 20.w,
//                                 //   color: currentTab == 0 ? KOrange : Klightgray,
//                                 // ),
//                                 Text(
//                                   'Home',
//                                   style: GoogleFonts.inter(
//                                     fontSize: kTwelveFont,
//                                     //  fontSize: currentTab == 0 ? 13.sp : 11.sp,
//                                     fontWeight: kFW500,
//                                     color:
//                                         currentTab == 0 ? KOrange : Klightgray,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // SizedBox(
//                           //   width: 3.w,
//                           // ),
//                           MaterialButton(
//                             minWidth: 40,
//                             onPressed: () {
//                               setState(() {
//                                 currentScreen =
//                                     const Feeds_screen(); // if user taps on this dashboard tab will be active
//                                 currentTab = 1;
//                               });
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 currentTab == 1
//                                     ? Image.asset('assets/images/feed.png',
//                                         width: 23.w, color: KOrange)
//                                     : Image.asset(
//                                         'assets/images/feed.png',
//                                         width: 18.w,
//                                         color: Klightgray,
//                                       ),
//                                 Text(
//                                   'Feeds',
//                                   style: GoogleFonts.inter(
//                                     fontSize: currentTab == 1 ? 13.sp : 11.sp,
//                                     fontWeight:
//                                         currentTab == 1 ? kFW600 : kFW500,
//                                     color:
//                                         currentTab == 1 ? KOrange : Klightgray,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Right Tab bar icons
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           MaterialButton(
//                             minWidth: 40,
//                             onPressed: () {
//                               setState(() {
//                                 currentScreen =
//                                     const Profile_view(); // if user taps on this dashboard tab will be active
//                                 currentTab = 2;
//                               });
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Image.asset(
//                                   'assets/images/profile1.png',
//                                   width: 25.w,
//                                   color: currentTab == 2 ? KOrange : Klightgray,
//                                 ),
//                                 Text(
//                                   'Profile',
//                                   style: GoogleFonts.inter(
//                                     fontSize: currentTab == 2 ? 13.sp : 11.sp,
//                                     fontWeight:
//                                         currentTab == 2 ? kFW600 : kFW500,
//                                     color:
//                                         currentTab == 2 ? KOrange : Klightgray,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 15.w,
//                           ),
//                           MaterialButton(
//                             minWidth: 40,
//                             onPressed: () {
//                               setState(() {
//                                 currentScreen =
//                                     const Action_screen(); // if user taps on this dashboard tab will be active
//                                 currentTab = 3;
//                               });
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 currentTab == 3
//                                     ? Image.asset(
//                                         'assets/images/fire.png',
//                                         width: 20.w,
//                                         color: KOrange,
//                                       )
//                                     : Image.asset(
//                                         'assets/images/fire.png',
//                                         width: 20.w,
//                                         color: Klightgray,
//                                       ),
//                                 Text(
//                                   'Menu',
//                                   style: GoogleFonts.inter(
//                                     fontSize: currentTab == 3 ? 13.sp : 11.sp,
//                                     fontWeight:
//                                         currentTab == 3 ? kFW600 : kFW500,
//                                     color:
//                                         currentTab == 3 ? KOrange : Klightgray,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 12.w,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )));
//   }
// }
