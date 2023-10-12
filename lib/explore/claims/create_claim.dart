import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:vibeshr/untils/export_file.dart';

class Claims extends StatefulWidget {
  const Claims({super.key});

  @override
  State<Claims> createState() => _ClaimsState();
}

class _ClaimsState extends State<Claims> {
  TextEditingController dOBController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? selectedImage;
  String base64Image = "";
  bool isLoading = false;
  Map typesData = {};
  List<String> options = [];
  int choosenTypeData = 0;
  String choosenOption = "";
  DateTime choosenDate = DateTime.now();
  String description = "";
  int? totalAmount;
  String? str;
  Future<void> chooseImage(type) async {
    // ignore: prefer_typing_uninitialized_variables
    var image;
    if (type == "camera") {
      image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
    } else {
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);
    }
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        base64Image = base64Encode(selectedImage!.readAsBytesSync());
      });
      // var value = await Services.profileimage(File(image.path));
      // if (jsonDecode(value["msg"]) != null) {
      //   Fluttertoast.showToast(msg: value["msg"]);
      // } else {
      //   // Get.toNamed(Kapply_leaves);
      // }
    }
  }

  getTypes() async {
    setState(() {
      isLoading = true;
    });

    Map value = await Services.getTypes();
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {
      typesData = value;
      await getOptionsList();
    }
    setState(() {
      isLoading = false;
    });
  }

  var isLoadingExpense = false.obs;

  createClaim() async {
    setState(() {
      isLoadingExpense.value = true;
    });
    Map imageValue = await Services.uploadFileToServer(
        selectedImage!.path, "claim_document");
    String imageData = "";
    try {
      imageData = imageValue["msg"];
    } catch (e) {
      imageData = "";
    }
    Map payload = {
      "claim_type_id": choosenTypeData,
      "date": choosenDate.toString(),
      "amount": int.parse(totalAmount.toString()),
      "comments": description,
      "image": imageData
    };

    Map value = await Services.createClaim(payload);
    if (value["message"] != null) {
      Fluttertoast.showToast(msg: value["message"]);
    } else {
      typesData = value;
      Get.toNamed(KBottom_navigation);
    }
    setState(() {
      isLoadingExpense.value = false;
    });
  }

  getOptionsList() {
    options.clear();
    for (int i = 0; i < typesData["rows"].length; i++) {
      options.add(typesData["rows"][i]["name"]);
    }
  }

  TextEditingController date = TextEditingController();
  @override
  void initState() {
    getTypes();
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbackground,
      // bottomSheet:
      appBar: const VibhoAppBar(
        title: "Create Claim",
        dontHaveBackAsLeading: false,
        bColor: Kbackground,
      ),
      body: SingleChildScrollView(
        child: isLoading == false
            ? Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(13.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Expenses Category",
                          style: GoogleFonts.openSans(
                              fontSize: kFourteenFont,
                              color: Ktextcolor,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 5.h),
                      //                     RichText(
                      // text: TextSpan(
                      //     text: label,
                      //     style: GoogleFonts.openSans(
                      //         fontSize: kFourteenFont,
                      //         color: Ktextcolor,
                      //         fontWeight: FontWeight.w500),)
                      //       children: isMandatory
                      //           ? [
                      //               TextSpan(
                      //                 text: '*',
                      //                 style: GoogleFonts.openSans(
                      //                   fontSize: kFourteenFont,
                      //                   color: KRed,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //               )
                      //             ]
                      //           : []),
                      // ),
                      // CustomDropDown(
                      //     label: "Expenses Category",
                      //     hintText: 'Claim type',
                      //     isMandatory: false,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'This filed not be Empty';
                      //       }
                      //       return null;
                      //     },
                      //     onChanged: (dynamic str) {
                      //       setState(() {
                      //         choosenTypeData = typesData["rows"]
                      //             .where((element) => element["name"] == str)
                      //             .toList()[0]["claim_type_id"];
                      //         choosenOption = typesData["rows"]
                      //             .where((element) => element["name"] == str)
                      //             .toList()[0]["name"];
                      //       });
                      //     },
                      //     options: options),
                      ////////////////////////errordebug
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
                            // onChanged: (String? value) {
                            //   setState(() {
                            //     str = value;
                            //     data.leavetype = str!;
                            //     data.leavetypeid = myLeavesTypes
                            //         .where((element) =>
                            //             element["leave_type_name"] == str)
                            //         .toList()[0]["leave_type_id"];
                            //   });
                            // },
                            onChanged: (String? value) {
                              str = value;
                              setState(() {
                                choosenTypeData = typesData["rows"]
                                    .where((element) => element["name"] == str)
                                    .toList()[0]["claim_type_id"];
                                choosenOption = typesData["rows"]
                                    .where((element) => element["name"] == str)
                                    .toList()[0]["name"];
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
                      //////////////////
                      SizedBox(
                        height: 15.h,
                      ),
                      // Container(
                      //   height: 40.h,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: Kwhite,
                      //     borderRadius: BorderRadius.circular(10.r),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         spreadRadius: 2,
                      //         blurRadius: 10,
                      //         offset: Offset(0, 6),
                      //         color: Ktextcolor.withOpacity(0.2),
                      //       )
                      //     ],
                      //   ),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton2<String>(
                      //       isExpanded: true,
                      //       hint: Text(
                      //         'Claim type',
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           color: Theme.of(context).hintColor,
                      //         ),
                      //       ),
                      //       items: options
                      //           .map((String item) => DropdownMenuItem<String>(
                      //                 value: item,
                      //                 child: Text(
                      //                   item,
                      //                   style: const TextStyle(
                      //                     fontSize: 14,
                      //                   ),
                      //                 ),
                      //               ))
                      //           .toList(),
                      //       value: str,
                      //       onChanged: (dynamic str) {
                      //         setState(() {
                      //           choosenTypeData = typesData["rows"]
                      //               .where((element) => element["name"] == str)
                      //               .toList()[0]["claim_type_id"];
                      //           choosenOption = typesData["rows"]
                      //               .where((element) => element["name"] == str)
                      //               .toList()[0]["name"];
                      //         });
                      //       },
                      //       buttonStyleData: const ButtonStyleData(
                      //         padding: EdgeInsets.symmetric(horizontal: 16),
                      //         height: 40,
                      //         width: 140,
                      //       ),
                      //       menuItemStyleData: const MenuItemStyleData(
                      //         height: 40,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomFormField(
                        keyboardType: TextInputType.none,
                        maxLines: 1,
                        controller: dOBController,
                        hintText: selectedDate != null
                            ? DateFormat.yMMMEd().format(selectedDate)
                            : "Claim Applied Date",
                        //isMandatory: false,
                        labelText: selectedDate != null
                            ? DateFormat.yMMMEd().format(selectedDate)
                            : "Claim Applied Date",
                        readOnly: true,

                        suffix: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      // background: white,
                                      primary: KOrange,
                                      //onPrimary: white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: Kbluedark,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                                choosenDate = selectedDate;
                              });
                            }
                          },
                          child: Image.asset(
                            "assets/images/Group1.png",
                          ),
                        ),
                      ),

                      // CustomFormField(
                      //  // controller: selectedDate,
                      //   keyboardType: TextInputType.none,
                      //     maxLines: 1,
                      //     readOnly: false,
                      // labelText: selectedDate != null
                      //     ? DateFormat.yMMMEd().format(selectedDate)
                      //     : "Transaction Date",
                      //     suffix: GestureDetector(
                      //       onTap: () async {
                      //         final DateTime? picked = await showDatePicker(
                      //             context: context,
                      //             initialDate: selectedDate,
                      //             firstDate: DateTime(2015, 8),
                      //             lastDate: DateTime(2101));
                      //         if (picked != null && picked != selectedDate) {
                      //           setState(() {
                      //             selectedDate = picked;
                      //             choosenDate = selectedDate;
                      //           });
                      //         }
                      //       },
                      //       child: Image.asset(
                      //         "assets/images/Group1.png",
                      //       ),
                      //     ),
                      //     hintText: "dd/mm/yyyy"),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomFormField(
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 15),
                            child: Text(
                              UserSimplePreferences.getCurrency() == "INR"
                                  ? "₹"
                                  : UserSimplePreferences.getCurrency() == "ZAR"
                                      ? "R"
                                      : "",
                              //  "\u{20B9} | ",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: kFW600,
                                  color: kblack),
                            ),
                          ),
                          maxLines: 1,
                          readOnly: false,
                          keyboardType: TextInputType.number,
                          labelText: "Total Amount",
                          validator: (value) {
                            (input) => input.isValidEmail()
                                ? null
                                : "Check your email";
                            if (value!.isEmpty) {
                              return 'Please enter some Amount';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              totalAmount = int.parse(value);
                            });
                          },
                          hintText: "Total Amount"),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Ktextcolor.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                                height: 130.h,
                                width: double.infinity,
                              )
                            : const Text(
                                "",
                                textAlign: TextAlign.center,
                              ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          chooseImage("Gallery");
                        },
                        child: DottedBorder(
                            dashPattern: [8, 2],
                            strokeWidth: 1,
                            color: KOrange,
                            child: Container(
                              height: 35.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: Kwhite,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upload receipt",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: KOrange,
                                        fontWeight: kFW600),
                                  )
                                ],
                              ),
                            )),
                      ),

                      SizedBox(
                        height: 15.h,
                      ),
                      CustomFormField(
                          maxLines: 5,
                          readOnly: false,
                          labelText: "Description",
                          controller: date,
                          validator: (value) {
                            (input) => input.isValidEmail()
                                ? null
                                : "Check your email";
                            if (value!.isEmpty) {
                              return 'Please enter some Description';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                          hintText: "Description"),
                      SizedBox(
                        height: 60.h,
                      ),
                      Column(
                        children: [
                          CustomButton(
                              borderRadius: BorderRadius.circular(30.r),
                              margin: EdgeInsets.all(15.r),
                              width: double.infinity,
                              height: 35.h,
                              Color: KOrange,
                              textColor: Kwhite,
                              fontSize: 13.sp,
                              fontWeight: kFW700,
                              label: "Submit",
                              isLoading: false,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _showDialog(context);
                                }
                              }),
                          CustomButton(
                              borderRadius: BorderRadius.circular(30.r),
                              margin: EdgeInsets.all(10.r),
                              width: double.infinity,
                              height: 35.h,
                              Color: Kbackground,
                              textColor: KOrange,
                              fontSize: 13.sp,
                              fontWeight: kFW700,
                              label: "Cancel",
                              isLoading: false,
                              onTap: () {
                                Get.back();
                                //_showDialog(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: SpinKitWave(
                color: KOrange,
                size: 15,
              )),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 430.h,

              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              // margin: EdgeInsets.only(left: .w,right: 20.w
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Expenses Submitted',
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: 13.sp,
                          fontWeight: kFW900)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                      'Your Expenses has been submitted and ready to be reviewed',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: kTenFont,
                          fontWeight: kFW500)),
                  SizedBox(
                    height: 10.h,
                  ),
                  Image.asset(
                    "assets/images/bill.png",
                    width: 150.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Total Ammount',
                              style: TextStyle(
                                  color: KdarkText.withOpacity(0.5),
                                  fontSize: 11.sp,
                                  fontWeight: kFW900)),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                              UserSimplePreferences.getCurrency() == "INR"
                                  ? "₹ $totalAmount"
                                  : UserSimplePreferences.getCurrency() == "ZAR"
                                      ? "R $totalAmount"
                                      : '$totalAmount',
                              style: TextStyle(
                                  color: kblack,
                                  fontSize: 13.sp,
                                  fontWeight: kFW900)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Claim Applied date',
                              style: TextStyle(
                                  color: KdarkText.withOpacity(0.5),
                                  fontSize: 11.sp,
                                  fontWeight: kFW900)),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text('${DateFormat.yMMMd().format(choosenDate)}',
                              style: TextStyle(
                                  color: KdarkText,
                                  fontSize: 13.sp,
                                  fontWeight: kFW900)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description',
                            style: TextStyle(
                                color: KdarkText.withOpacity(0.5),
                                fontSize: 11.sp,
                                fontWeight: kFW900)),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(description != "" ? description : "-",
                            maxLines: 2,
                            style: TextStyle(
                                color: KdarkText,
                                fontSize: 13.sp,
                                fontWeight: kFW900)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            margin: const EdgeInsets.all(3),
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Ktextcolor.withOpacity(0.3),
                              //     blurRadius: 10,
                              //     offset: const Offset(0, 0),
                              //     spreadRadius: 5, //New
                              //   )
                              // ],
                              borderRadius: BorderRadius.circular(13.r),
                              color: Kwhite,
                            ),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(13.r), // Image border
                                child: selectedImage != null
                                    ? Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      )
                                    : const Text(
                                        "no receipt",
                                        textAlign: TextAlign.center,
                                      ))),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expenses for",
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.normal,
                                color: KdarkText.withOpacity(0.5)),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            choosenOption,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: KdarkText),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(() => isLoadingExpense != false
                      ? const Center(
                          child: SpinKitWave(
                          color: KOrange,
                          size: 15,
                        ))
                      : CustomButton(
                          borderRadius: BorderRadius.circular(30.r),
                          margin: EdgeInsets.all(15.r),
                          width: double.infinity,
                          height: 35.h,
                          Color: KOrange,
                          textColor: Kwhite,
                          fontSize: 13.sp,
                          fontWeight: kFW700,
                          label: "Done",
                          isLoading: false,
                          onTap: () {
                            createClaim();
                          })),
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
