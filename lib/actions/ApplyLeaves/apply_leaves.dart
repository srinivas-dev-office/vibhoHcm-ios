// ignore_for_file: camel_case_types, unused_field

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../untils/export_file.dart';

class Apply_leave extends StatefulWidget {
  const Apply_leave({super.key});

  @override
  State<Apply_leave> createState() => _Apply_leaveState();
}

class leavesdata {
  int leavetypeid = 0;
  String leavetype = '';
  String fromdate = '';
  String todate = '';
  String reason = '';
}

class _Apply_leaveState extends State<Apply_leave> {
  //  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;

  // @override
  // void initState() {
  //   _cnt = SingleValueDropDownController();
  //   _cntMulti = MultiValueDropDownController();
  //   super.initState();
  // }

  @override
  void dispose() {
    _cnt.dispose();
    _cntMulti.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController reasoncontroller = TextEditingController();
  bool isLoading = false;
  List appliedLeaves = [];
  leavesdata data = leavesdata();
  Future leavesHandler() async {
    setState(() {
      isLoading = true;
    });
    Map payload = {
      "leave_type_id": data.leavetypeid,
      "leave_type": data.leavetype,
      "from_date": _range.toString().split(" - ")[0],
      "to_date": _range.toString().split(" - ")[1],
      "reason": data.reason,
    };
    Map checkAvilablityPayload = {
      "leave_type_id": data.leavetypeid,
      "from_date": _range.toString().split(" - ")[0],
      "to_date": _range.toString().split(" - ")[1],
    };

    Map value = await Services.createLeaveV2(payload);
    Map checkAvilablity =
        await Services.checkAvilablity(checkAvilablityPayload);

    print(value);
    setState(() {
      isLoading = false;
    });
    _showMyDialog(value, checkAvilablity);
  }

  List<DateTime> appledLeavesDates = [];
  getAppliedLeaves() {
    setState(() {
      isLoading = true;
    });
    appledLeavesDates.clear();
    for (int i = 0; i < appliedLeaves.length; i++) {
      if (appliedLeaves[i]["from_date"] != "0000-00-00" &&
          appliedLeaves[i]["to_date"] != "0000-00-00") {
        List<DateTime> betweenDates = getLeavesInBetween(
            DateTime.parse(appliedLeaves[i]["from_date"]),
            DateTime.parse(appliedLeaves[i]["to_date"]));
        for (int j = 0; j < betweenDates.length; j++) {
          setState(() {
            appledLeavesDates.add(betweenDates[j]);
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  getLeavesInBetween(DateTime startDate, DateTime endDate) {
    final daysToGenerate = endDate.difference(startDate).inDays + 1;
    return List.generate(
        daysToGenerate, (i) => startDate.add(Duration(days: i)));
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${args.value.startDate} -'
            // ignore: lines_longer_than_80_chars
            ' ${args.value.endDate ?? args.value.startDate}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  bool validateLeaves() {
    var data = getLeavesInBetween(
        DateTime.parse(_range.toString().split(' - ')[0].trim()),
        DateTime.parse(_range.toString().split(' - ')[1].trim()));
    if (data[0].weekday == 7 ||
        data[data.length - 1].weekday == 7 ||
        data[0].weekday == 6 ||
        data[data.length - 1].weekday == 6) {
      Fluttertoast.showToast(msg: "Leave Can't Apply On Weekends");
      return false;
    } else {
      for (int i = 0; i < data.length; i++) {
        for (int j = 0; j < appledLeavesDates.length; j++) {
          if (data[i] == appledLeavesDates[j]) {
            Fluttertoast.showToast(msg: "Leave Already Applied");
            return false;
          }
        }
      }
    }

    return true;
  }

  getLeavesListFromApi() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.leavelist();
    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      appliedLeaves = data["rows"];
      getAppliedLeaves();
    }
    setState(() {
      isLoading = false;
    });
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? str;
  List myLeavesTypes = [];
  List<String> options = [];
  getLeavesListTypes() async {
    options.clear();
    setState(() {
      isLoading = true;
    });
    Map data = await Services.getLeavesListTypes();
    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      myLeavesTypes = data["rows"];
      for (int i = 0; i < myLeavesTypes.length; i++) {
        if (myLeavesTypes[i]["is_active"] == 1) {
          options.add(myLeavesTypes[i]["leave_type_name"]);
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getLeavesListTypes();
    getLeavesListFromApi();
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar:
      backgroundColor: Kwhite,
      appBar: const VibhoAppBar(
        bColor: Kwhite,
        title: 'Apply Leave',
        dontHaveBackAsLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.all(13.r),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Leave type",
                    style: GoogleFonts.openSans(
                        fontSize: kFourteenFont,
                        color: Ktextcolor,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 10.h),
                // CustomDropDown(
                //   label: 'Leave type',
                //   hintText: 'Leave type',
                //   isMandatory: true,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'This filed not be Empty';
                //     }
                //     return null;
                //   },
                //   onChanged: (dynamic str) {
                //     setState(() {
                //       data.leavetype = str;
                //       data.leavetypeid = myLeavesTypes
                //           .where((element) => element["leave_type_name"] == str)
                //           .toList()[0]["leave_type_id"];
                //     });
                //   },
                //   options: options,
                // ),
                Container(
                  height: 40.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Kwhite,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                        color: Ktextcolor.withOpacity(0.2),
                      )
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: options
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: str,
                      //     onChanged: (dynamic str) {
                      //   setState(() {
                      //     data.leavetype = str;
                      //     data.leavetypeid = myLeavesTypes
                      //         .where((element) => element["leave_type_name"] == str)
                      //         .toList()[0]["leave_type_id"];
                      //   });
                      // },
                      onChanged: (String? value) {
                        setState(() {
                          str = value;
                          data.leavetype = str!;
                          data.leavetypeid = myLeavesTypes
                              .where((element) =>
                                  element["leave_type_name"] == str)
                              .toList()[0]["leave_type_id"];
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 140,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                    ),
                  ),
                ),
                // DropDownTextField(

                //     clearOption: false,
                //     textFieldFocusNode: textFieldFocusNode,
                //     searchFocusNode: searchFocusNode,
                //     // searchAutofocus: true,
                //     dropDownItemCount: options.length,
                //     searchShowCursor: false,
                //     enableSearch: false,
                //     searchKeyboardType: TextInputType.number,
                //     dropDownList:
                //     DropDownValueModel(name: 'name1', value: "value1")
                //     ,

                //     // DropDownValueModel(name: 'name1', value: "value1"),
                //     // DropDownValueModel(
                //     //     name: 'name2',
                //     //     value: "value2",
                //     //     toolTipMsg:
                //     //         "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                //     // DropDownValueModel(name: 'name3', value: "value3"),
                //     // DropDownValueModel(
                //     //     name: 'name4',
                //     //     value: "value4",
                //     //     toolTipMsg:
                //     //         "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                //     // DropDownValueModel(name: 'name5', value: "value5"),
                //     // DropDownValueModel(name: 'name6', value: "value6"),
                //     // DropDownValueModel(name: 'name7', value: "value7"),
                //     //  DropDownValueModel(name: 'name8', value: "value8"),
                //     onChanged: (dynamic str) {
                //       setState(() {
                //         data.leavetype = str;
                //         data.leavetypeid = myLeavesTypes
                //             .where(
                //                 (element) => element["leave_type_name"] == str)
                //             .toList()[0]["leave_type_id"];
                //       });
                //     }
                //     //  onChanged: (val) {},
                //     ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Kwhite,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                          color: Ktextcolor.withOpacity(0.2),
                        )
                      ],
                    ),
                    child: isLoading == false
                        ? SfDateRangePicker(
                            enablePastDates: false,
                            initialSelectedDates: appledLeavesDates,
                            startRangeSelectionColor: KOrange,
                            selectionColor: KOrange,
                            rangeSelectionColor: KOrange.withOpacity(0.3),
                            endRangeSelectionColor: KOrange,
                            view: DateRangePickerView.month,
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.range,
                          )
                        : const Center(
                            child: SpinKitWave(
                            color: KOrange,
                            size: 15,
                          ))
                          ),
                SizedBox(
                  height: 20.h,
                ),
                CustomFormField(
                  maxLines: 8,
                  readOnly: false,
                  labelText: "Reason",
                  controller: reasoncontroller,
                  hintText: "Reason",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This filed not be Empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      data.reason = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),
                CustomButton(
                    margin: const EdgeInsets.all(15),
                    height: 38.h,
                    width: double.infinity,
                    textColor: Kwhite,
                    borderRadius: BorderRadius.circular(20.r),
                    Color: KOrange,
                    fontSize: 13.sp,
                    fontWeight: kFW600,
                    label: "Sumbit",
                    isLoading: false,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        bool isnotalreadyApplied = validateLeaves();
                        if (isnotalreadyApplied) {
                          leavesHandler();
                        }
                        // leavesHandler();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(Map value, Map checkAvilablity) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 240.h,

              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              // margin: EdgeInsets.only(left: .w,right: 20.w
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Image.asset(
                    "assets/images/leaves.png",
                    color: KOrange,
                    width: 50.w,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text('Apply Leave',
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: 14.sp,
                          fontWeight: kFW900)),
                  SizedBox(
                    height: 8.h,
                  ),
                  value["message"] != null
                      ? Text(value["message"],
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: KdarkText,
                              fontSize: kTenFont,
                              fontWeight: kFW500))
                      : value["leave_status"] != null
                          ? Text("Leave Applied",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: KdarkText,
                                  fontSize: kTenFont,
                                  fontWeight: kFW500))
                          : const SizedBox(),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // checkAvilablity["msg"] != ""
                  //     ? Text(checkAvilablity["msg"],
                  //         maxLines: 2,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             color: KdarkText,
                  //             fontSize: kTenFont,
                  //             fontWeight: kFW500))
                  //     : value["leave_status"] != null
                  //         ? Text("Leave Type - " + value["leave_type"],
                  //             maxLines: 2,
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 color: KdarkText,
                  //                 fontSize: kTenFont,
                  //                 fontWeight: kFW500))
                  //         : const SizedBox(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                          borderRadius: BorderRadius.circular(15.r),
                          margin: EdgeInsets.all(10.r),
                          width: 110.w,
                          height: 35.h,
                          Color: KOrange,
                          textColor: Kwhite,
                          fontSize: 12.sp,
                          fontWeight: kFW700,
                          label: "Ok",
                          isLoading: false,
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
