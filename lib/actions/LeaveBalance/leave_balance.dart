// ignore_for_file: non_constant_identifier_names

import '../../untils/export_file.dart';

class Leavebalance extends StatefulWidget {
  const Leavebalance({super.key});

  @override
  State<Leavebalance> createState() => _LeavebalanceState();
}

class _LeavebalanceState extends State<Leavebalance> {
  List Setting_list = [
    {
      "name": "Paternlty Leave",
      "Subimage": "assets/images/arrow.png",
      "Subname": "07",

      //"color": KPurple,
      // "route": KAttendance
    },
    {
      "name": "LWP",
      "Subimage": "assets/images/arrow.png",
      "Subname": "07",
    },
    {
      "name": "Comp Off",
      "Subimage": "assets/images/arrow.png",
      "Subname": "07",
    },
    {
      "name": "Privilega Leave",
      "Subimage": "assets/images/arrow.png",
      "Subname": "07",
    },
    {
      "name": "Sick Leave",
      "Subimage": "assets/images/arrow.png",
      "Subname": "07",
    },
    {
      "name": "Check for Updates",
      "Subimage": "assets/images/arrow.png",
      "Subname": "07",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbackground,
      bottomNavigationBar: CustomButton(
          margin: EdgeInsets.all(10.r),
          borderRadius: BorderRadius.circular(20.r),
          Color: KOrange,
          height: 40.h,
          label: "Apply",
          textColor: Kwhite,
          fontWeight: kFW900,
          fontSize: 13.sp,
          isLoading: false,
          onTap: () {}),
      appBar: VibhoAppBar(
        bColor: Kwhite,
        title: 'Leave Balance',
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
                  // Get.toNamed(Setting_list[i]["route"]),
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Kwhite,
                      boxShadow: [
                        BoxShadow(
                          color: Ktextcolor.withOpacity(0.01),
                          blurRadius: 5,
                          offset: const Offset(0, 0),
                          spreadRadius: 2,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10.r)),
                  //margin: EdgeInsets.all(13.r),
                  child: ListTile(
                    title: Text(
                      Setting_list[i]["name"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.sp, fontWeight: kFW500, color: Klight),
                    ),
                    // subtitle: Text(
                    //   Setting[i]["name"],
                    // ),
                    subtitle: Text(
                      "07",
                      //Setting_list[i]["Subtext"],
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: KdarkText),
                    ),
                    trailing: Image.asset(
                      Setting_list[i]["Subimage"],
                      height: 30.h,
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
