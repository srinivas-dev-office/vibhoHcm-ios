// ignore_for_file: unused_field

import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../untils/export_file.dart';

class Attendances extends StatefulWidget {
  const Attendances({super.key});

  @override
  State<Attendances> createState() => _AttendancesState();
}

class _AttendancesState extends State<Attendances> {
  final DateTime _chosenDate = DateTime.now();
  final DateRangePickerController _controller = DateRangePickerController();

  bool isLoading = false;
  Map attendanceInfoData = {};
  DateTime? selectedDate;
  getCalenderInfo(DateTime date) async {
    setState(() {
      isLoading = true;
      _controller.view = DateRangePickerView.month;
    });

    Map value = await Services.attendanceinfo(date);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {
      attendanceInfoData = value;
      getDatesList(attendanceInfoData);
    }
    print(value);
    setState(() {
      isLoading = false;
    });
  }

  List<DateTime> absentdates = [];
  List<DateRangePickerCellDetails> listofAllDates = [];
  List<DateTime> presentdates = [];
  List<DateTime> holydaysdates = [];
  List<DateTime> restDaysdates = [];
  List<DateTime> allDaysdates = [];
  getDatesList(Map getDatesList) {
    absentdates.clear();
    presentdates.clear();
    holydaysdates.clear();
    restDaysdates.clear();
    allDaysdates.clear();
    for (int i = 0; i < getDatesList["rows"].length; i++) {
      allDaysdates.add(DateTime.parse(
          getCorrectDateFormat(getDatesList["rows"][i]["date"])));
      // listofAllDates.add(DateRangePickerCellDetails(bounds: ,date: DateTime.parse(
      //         getCorrectDateFormat(getDatesList["rows"][i]["date"]))));
      if (getDatesList["rows"][i]["status"] == "O" ||
          getDatesList["rows"][i]["status"] == "o") {
        setState(() {
          if(DateTime.parse(
              getCorrectDateFormat(getDatesList["rows"][i]["date"])).day<DateTime.now().day)
          absentdates.add(DateTime.parse(
              getCorrectDateFormat(getDatesList["rows"][i]["date"])));
        });
      }
      if (getDatesList["rows"][i]["status"] == "P" ||
          getDatesList["rows"][i]["status"] == "p") {
        setState(() {
          presentdates.add(DateTime.parse(
              getCorrectDateFormat(getDatesList["rows"][i]["date"])));
        });
      }
      if (getDatesList["rows"][i]["status"] == "H" ||
          getDatesList["rows"][i]["status"] == "h") {
        setState(() {
          holydaysdates.add(DateTime.parse(
              getCorrectDateFormat(getDatesList["rows"][i]["date"])));
        });
      }
      if (getDatesList["rows"][i]["status"] == "R" ||
          getDatesList["rows"][i]["status"] == "r") {
        setState(() {
          restDaysdates.add(DateTime.parse(
              getCorrectDateFormat(getDatesList["rows"][i]["date"])));
        });
      }
    }
  }

  bool isSpecialDay(DateTime date) {
    if (date.day == 20 || date.day == 21 || date.day == 24 || date.day == 25) {
      return true;
    }
    return false;
  }

  bool isHolyDate(DateTime date) {
    return holydaysdates.where((element) => element == date).toList().isNotEmpty
        ? true
        : false;
  }

  bool isWorkingDay(DateTime date) {
    return presentdates.where((element) => element == date).toList().isNotEmpty
        ? true
        : false;
  }

  String getCorrectDateFormat(String dateformat) {
    List<String> date = dateformat.split('-');
    date[1] = int.parse(date[1]) > 9 ? date[1].toString() : "0${date[1]}";
    String newDate = "${date[0]}-${date[1]}-${date[2]}";
    return newDate;
  }

  final String CALENDERS = 'assets/images/calenders.svg';
  @override
  void initState() {
    selectedDate = DateTime.now();
    getCalenderInfo(DateTime.now());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      appBar: const VibhoAppBar(
        bColor: Kwhite,
        title: 'Attendance Info',
        dontHaveBackAsLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(13.r),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(13.r),
              margin: EdgeInsets.all(13.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Kwhite,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                    color: Ktextcolor.withOpacity(0.2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  Text(
                    "Select Month & Year",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: KOrange.withOpacity(0.7),
                    ),
                  ),
                  // SizedBox(
                  //   width: 50.w,
                  // ),
                  GestureDetector(
                    onTap: () async {
                      showMonthPicker(
                        backgroundColor: Kwhite,
                        selectedMonthBackgroundColor: KOrange.withOpacity(0.5),
                        roundedCornersRadius: 10,
                        headerColor: KOrange,
                        unselectedMonthTextColor: Ktextcolor,
                        context: context,
                        initialDate: DateTime.now(),
                        confirmWidget: Text(
                          "OK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: KOrange.withOpacity(0.7),
                          ),
                        ),
                        cancelWidget: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: KOrange.withOpacity(0.7),
                          ),
                        ),
                      ).then((date) {
                        if (date != null) {
                          if(date.month>DateTime.now().month){
                             Fluttertoast.showToast(msg: "Upcomming Months can'b be selected");
                          }else{
                            setState(() {
                            _controller.selectedDate = date;
                            _controller.displayDate = date;
                            selectedDate = date;
                            getCalenderInfo(date);
                          });
                          }
                          
                        }
                      });
                    },
                    child: SvgPicture.asset(CALENDERS,
                        semanticsLabel: 'Acme Logo'),
                    // Image.asset(
                    //   "assets/images/Group.png",
                    //   width: 23.w,
                    // ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            selectedDate != null
                ? isLoading == false
                    ? Container(
                        padding: EdgeInsets.only(bottom: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Kwhite,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 6),
                              color: Ktextcolor.withOpacity(0.2),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            SfDateRangePicker(
                              rangeTextStyle: TextStyle(
                                color: KOrange,
                              ),
                              controller: _controller,
                              navigationDirection:
                                  DateRangePickerNavigationDirection.horizontal,
                              enablePastDates: false,
                              allowViewNavigation: false,
                              startRangeSelectionColor: KOrange,
                              selectionColor: KOrange,
                              initialSelectedDates: allDaysdates,
                              initialDisplayDate: selectedDate,
                              monthViewSettings:
                                  DateRangePickerMonthViewSettings(
                                      blackoutDates: absentdates,
                                      // weekendDays: const [7, 6],
                                      specialDates: holydaysdates),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                  weekendTextStyle:
                                      const TextStyle(color: const Color(0xFFB6B6B6)),
                                  // weekendDatesDecoration: BoxDecoration(
                                  //     //color: Klightgray,
                                  //     border:
                                  //         Border.all(color: const Color(0xFFB6B6B6), width: 1),
                                  //     shape: BoxShape.circle),
                                  blackoutDateTextStyle:
                                      const TextStyle(color: KRed,fontWeight: FontWeight.bold),
                                  textStyle: const TextStyle(
                                    color: Klightgray,
                                  ),
                                  specialDatesTextStyle:
                                      const TextStyle(color: Kbluedark)),
                            ),
                            SfDateRangePicker(
                              rangeTextStyle: TextStyle(
                                color: KOrange,
                              ),
                              controller: _controller,
                              navigationDirection:
                                  DateRangePickerNavigationDirection.horizontal,
                              enablePastDates: false,
                              allowViewNavigation: false,
                              startRangeSelectionColor: KOrange,
                              selectionColor: KOrange,
                              initialSelectedDates: allDaysdates,
                              initialDisplayDate: selectedDate,
                              monthViewSettings:
                                  DateRangePickerMonthViewSettings(
                                      blackoutDates: presentdates,
                                      // weekendDays: const [7, 6],
                                      specialDates: holydaysdates),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                  weekendTextStyle:
                                      const TextStyle(color: Color(0xFFB6B6B6)),
                                  // weekendDatesDecoration: BoxDecoration(
                                  //     //color: Klightgray,
                                  //     border:
                                  //         Border.all(color: const Color(0xFFB6B6B6), width: 1),
                                  //     shape: BoxShape.circle),
                                  blackoutDateTextStyle:
                                      const TextStyle(color: Kgreen),
                                  textStyle: const TextStyle(
                                    color: Klightgray,
                                  ),
                                  specialDatesTextStyle:
                                      const TextStyle(color: Kbluedark)),
                            )
                            ,Container(
                              color: Colors.transparent,
                              height: 300.h,
                            )
                          ],
                        ))
                    : const Center(
                        child: SpinKitWave(
                          color: KOrange,
                          size: 25,
                        ),
                      )
                : const SizedBox(),
            SizedBox(
              height: 15.h,
            ),
            Container(
              padding: EdgeInsets.all(15.r),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                  color: Ktextcolor.withOpacity(0.2),
                )
              ], borderRadius: BorderRadius.circular(10.r), color: Kwhite),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 5.r,
                                backgroundColor: KRed,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Absent",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: KdarkText,
                                    fontWeight: kFW500),
                              )
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 5.r,
                                backgroundColor: Kbluedark,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Holiday",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: KdarkText,
                                    fontWeight: kFW500),
                              )
                            ],
                          )
                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 5.r,
                          //       backgroundColor: Ktextcolor,
                          //     ),
                          //     SizedBox(
                          //       width: 10.w,
                          //     ),
                          //     Text(
                          //       "Rest Day",
                          //       style: TextStyle(
                          //           fontSize: 13.sp,
                          //           color: KdarkText,
                          //           fontWeight: kFW500),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 5.r,
                                backgroundColor: Kgreen,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Present",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: KdarkText,
                                    fontWeight: kFW500),
                              )
                            ],
                          ),
                          SizedBox(height: 10.h),
                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 5.r,
                          //       backgroundColor: Kbluedark,
                          //     ),
                          //     SizedBox(
                          //       width: 10.w,
                          //     ),
                          //     Text(
                          //       "Holiday",
                          //       style: TextStyle(
                          //           fontSize: 13.sp,
                          //           color: KdarkText,
                          //           fontWeight: kFW500),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [

                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
