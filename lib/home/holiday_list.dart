// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';

import '../untils/export_file.dart';

class Holiday extends StatefulWidget {
  const Holiday({super.key});

  @override
  State<Holiday> createState() => _HolidayState();
}

class _HolidayState extends State<Holiday> {
  Map Requestdata = {};
  List holydays = [];
  Map UpcommingHolydaysdata = {};

  bool isLoading = false;
  Future RequestListHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.employeehome();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      Requestdata = data["holidays"];
      UpcommingHolydaysdata = data["holidays"];
      getUpCommingHolyDays(UpcommingHolydaysdata);
    }
    setState(() {
      isLoading = false;
    });
  }

  getUpCommingHolyDays(Map UpcommingHolydaysdataList) {
    setState(() {
      holydays = UpcommingHolydaysdataList["rows"]
          .where((element) =>
              DateTime.parse(element["date"]).month >= DateTime.now().month &&
              DateTime.parse(element["date"]).day >= DateTime.now().day)
          .toList();
    });
    for (int j = 0; j < holydays.length; j++) {
      holydays.sort((a, b) {
        return DateTime.parse(a["date"]).compareTo(DateTime.parse(b["date"]));
      });
    }
    debugPrint("Upcomming Holydays COunt = ${holydays.length}");
  }

  @override
  void initState() {
    RequestListHandler();
    super.initState();
  }

  List Holidays = [
    {
      "name": "Attendance",
      "Subname": "Lorem Ipsum",
      "image": "assets/images/mu.png",
      "Subimage": "assets/images/arrow.png",
      "color": KPurple,
      // "route": KAttendance
    },
    {
      "name": "Leave",
      "Subname": "Lorem Ipsum",
      "image": "assets/images/ind.png",
      "Subimage": "assets/images/arrow.png",
      "color": KOrange,
      // "route": KRecharge
    },
    {
      "name": "Reimbursement",
      "Subname": "Lorem Ipsum",
      "image": "assets/images/gen.png",
      "Subimage": "assets/images/arrow.png",
      "color": Kgreen,
    },
    {
      "name": "Performance",
      "Subname": "Lorem Ipsum",
      "image": "assets/images/das.png",
      "Subimage": "assets/images/arrow.png",
      "color": KDarkskyblue,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Holidays",
          style: TextStyle(
              fontSize: kSixteenFont, fontWeight: kFW700, color: KdarkText),
        ),
        SizedBox(
          height: 20.h,
        ),
        isLoading == false
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: holydays.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 0.95.h,
                    crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      // height: 90,
                      // width: 90,
                      //  padding: EdgeInsets.all(10.r),
                      padding:
                          EdgeInsets.only(left: 10.w, right: 10.w, top: 18.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 0),
                              color: KOrange.withOpacity(0.2),
                            )
                          ],
                          color: Kwhite),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holydays[index]["name"],
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: kFourteenFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          holydays[index]["is_active"] == 1
                              ? Text(
                                  "Holiday",
                                  style: TextStyle(
                                      fontSize: kTwelveFont,
                                      fontWeight: kFW700,
                                      color: KdarkText),
                                )
                              : SizedBox(),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            // ignore: unnecessary_null_comparison
                            holydays[index]["date"] != "" &&
                                    holydays[index]["date"] != null
                                ? DateFormat.yMMMd()
                                    .format(
                                        DateTime.parse(holydays[index]["date"]))
                                    .toString()
                                : "jhgh",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                "assets/images/leave.png",
                                width: 60.w,
                              ))
                        ],
                      ));
                },
              )
            : const Center(
                child: SpinKitWave(
                color: KOrange,
                size: 15,
              ))
      ],
    );
  }
}
