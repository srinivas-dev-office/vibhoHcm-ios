// ignore_for_file: camel_case_types, non_constant_identifier_names

import '../untils/export_file.dart';

class Setting_view extends StatefulWidget {
  const Setting_view({super.key});

  @override
  State<Setting_view> createState() => _Setting_viewState();
}

class _Setting_viewState extends State<Setting_view> {
  List Setting_list = [
    {
      "name": "My Profile",
      "Subimage": "assets/images/arrow.svg",
      "subname": "Lorem Epson is a Dummy Text",
      "route": KProfile,
      //"color": KPurple,
      // "route": KAttendance
    },
    {
      "name": "Security",
      "Subimage": "assets/images/arrow.svg",
      "subname": "Lorem Epson is a Dummy Text",
      "route": KSecurity,
      //"color": KOrange,
      // "route": KRecharge
    },
    {
      "name": "Notification",
      "Subimage": "assets/images/arrow.svg",
      "subname": "Lorem Epson is a Dummy Text",
      "route": KNotification,
      // "color": Kgreen,
    },
    {
      "name": "Privacy Policy",
      "Subimage": "assets/images/arrow.svg",
      "subname": "Lorem Epson is a Dummy Text",
      "route": Kpolicy,
    },
    {
      "name": "Terms and Conditions",
      "Subimage": "assets/images/arrow.svg",
      "subname": "Lorem Epson is a Dummy Text",
      "route": Kterms_services
      // "color": KDarkblue,
    },
    {
      "name": "Check for Updates",
      "Subimage": "assets/images/arrow.svg",
      "subname": "Lorem Epson is a Dummy Text",
      "route": Kupdates,
      // "color": Kpink,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      // bottomNavigationBar: CustomButton(
      //     margin: EdgeInsets.all(10.r),
      //     borderRadius: BorderRadius.circular(20.r),
      //     Color: KOrange,
      //     height: 40.h,
      //     label: "Log Out",
      //     textColor: Kwhite,
      //     fontWeight: kFW900,
      //     fontSize: 13.sp,
      //     isLoading: false,
      //     onTap: () {
      //       UserSimplePreferences.clearAllData();
      //       Get.toNamed(KLogin_id);
      //     }),
      appBar: VibhoAppBar(
        bColor: Kwhite,
        title: 'Settings',
        dontHaveBackAsLeading: false,
        trailing: GestureDetector(
          onTap: () {
            // Get.toNamed(KProfile);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 15.w, top: 5.h),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/bell.png",
                  width: 25,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(13.r),
          child: Column(children: [
            for (int i = 0; i < Setting_list.length; i++)
              GestureDetector(
                onTap: () => {
                  Get.toNamed(Setting_list[i]["route"]),
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Kwhite,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                          color: Ktextcolor.withOpacity(0.2),
                        )
                      ],
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Ktextcolor.withOpacity(0.01),
                      //     blurRadius: 5,
                      //     offset: const Offset(0, 0),
                      //     spreadRadius: 2,
                      //   )
                      // ],
                      borderRadius: BorderRadius.circular(10.r)),
                  //margin: EdgeInsets.all(13.r),
                  child: ListTile(
                    title: Text(
                      Setting_list[i]["name"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: KdarkText),
                    ),
                    // subtitle: Text(
                    //   Setting[i]["name"],
                    // ),
                    // subtitle: Text(
                    //   //"Lorem Epson is a Dummy Text",
                    //    Setting_list[i]["Subtext"],
                    //   maxLines: 2,
                    //   textAlign: TextAlign.left,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //       fontSize: kTenFont,
                    //       fontWeight: kFW500,
                    //       color: Klight),
                    // ),
                    trailing: SvgPicture.asset(Setting_list[i]["Subimage"],
                        color: KOrange,
                        alignment: Alignment.bottomLeft,
                        fit: BoxFit.fill,
                        semanticsLabel: 'Acme Logo'),
                  ),
                ),
              ),
            SizedBox(
              height: 120.h,
            ),
            CustomButton(
                margin: EdgeInsets.all(10.r),
                borderRadius: BorderRadius.circular(20.r),
                Color: KOrange,
                height: 40.h,
                label: "Log Out",
                textColor: Kwhite,
                fontWeight: kFW900,
                fontSize: 13.sp,
                isLoading: false,
                onTap: () {
                  UserSimplePreferences.clearAllData();
                  Get.toNamed(Kwebaddress_login);
                }),
          ]),
        ),
      ),
    );
  }
}
