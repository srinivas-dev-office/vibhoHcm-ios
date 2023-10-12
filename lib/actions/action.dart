// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../untils/export_file.dart';

class Action_screen extends StatefulWidget {
  const Action_screen({super.key});

  @override
  State<Action_screen> createState() => _ActionscreenState();
}

class _ActionscreenState extends State<Action_screen> {
  List Actions = [
    // {
    //   "name": "Apply Regularization",
    //   "Subimage": "assets/images/arrow.png",
    //   "image": "assets/images/accept.png",
    //   "route": KRegularization,
    //   //"color": KPurple,
    //   // "route": KAttendance
    // },
    {
      "name": "Attendance info",
      "Subimage": "assets/images/arrow.svg",
      "image": "assets/images/menu.png",
      "route": KAttendance,
      //"color": KOrange,
      // "route": KRecharge
    },
    // {
    //   "name": "Employee Swipes",
    //   "Subimage": "assets/images/arrow.png",
    //   "image": "assets/images/user.png",
    //   "route": KEmployee_swipe,
    //   // "color": Kgreen,
    // },
    // {
    //   "name": "Calender",
    //   "Subimage": "assets/images/arrow.png",
    //   "image": "assets/images/data1.png",
    //   "route": KHolidayCalender,
    // },
    {
      "name": "TimeSheet",
      "Subimage": "assets/images/arrow.svg",
      "image": "assets/images/doc.png",
      "route": KTime_sheet,
      //"color": Kpink,
    },
    {
      "name": "Apply Leaves",
      "Subimage": "assets/images/arrow.svg",
      "image": "assets/images/cup.png",
      "route": Kleaves
      // "color": KDarkblue,
    },
    {
      "name": "Apply Claim",
      "Subimage": "assets/images/arrow.svg",
      "image": "assets/images/claims.png",
      "route": KClaims,
      //"color": Kpink,
    },
    // {
    //   "name": "Leave Balance",
    //   "Subimage": "assets/images/arrow.png",
    //   "image": "assets/images/balance.png",
    //   "route": KLeave_Balance,
    //   // "color": Kpink,
    // },
    // {
    //   "name": "Apply Regsignation",
    //   "Subimage": "assets/images/arrow.png",
    //   "image": "assets/images/cup.png",
    //   "route": KRegsignation,
    //   //"color": Kpink,
    // },
    {
      "name": "PaySlips",
      "Subimage": "assets/images/arrow.svg",
      "image": "assets/images/doc.png",
      "route": KPayslips,
      //"color": Kpink,
    },
    // {
    //   "name": "YTP Reports",
    //   "Subimage": "assets/images/arrow.png",
    //   "image": "assets/images/file.png",
    //   "route": KYTP_Resports,
    //   //"color": Kpink,
    // },
    {
      "name": "Settings",
      "Subimage": "assets/images/arrow.svg",
      "image": "assets/images/settings.png",
      "route": KSetting,
      //"color": Kpink,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      appBar: VibhoAppBar(
        bColor: Kwhite,
        title: 'Action',
        dontHaveBackAsLeading: true,
        trailing: GestureDetector(
          onTap: () {
            // Get.toNamed(KProfile);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 15.w, top: 5.h),
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
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(13.r),
          child: Column(children: [
            for (int i = 0; i < Actions.length; i++)
              GestureDetector(
                onTap: () => {
                  Get.toNamed(Actions[i]["route"]),
                  if (Actions[i]["name"] == "Apply Regularization") {}
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Kwhite,
                      boxShadow: [
                        BoxShadow(
                          color: Ktextcolor.withOpacity(0.0),
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                          spreadRadius: 2,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10.r)),
                  //margin: EdgeInsets.all(13.r),
                  child: ListTile(
                    leading: Image.asset(
                      Actions[i]["image"],
                      height: 23.h,
                      //color: Actions[i]["color"],
                    ),
                    title: Text(
                      Actions[i]["name"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: kFW600,
                          color: Klight),
                    ),
                    trailing: SvgPicture.asset(Actions[i]["Subimage"],
                          color: KOrange,
                          fit: BoxFit.fill,
                          semanticsLabel: 'Acme Logo'),
                    // Image.asset(
                    //   Actions[i]["Subimage"],
                    //   height: 30.h,
                    // ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
