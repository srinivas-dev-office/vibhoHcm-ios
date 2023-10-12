// ignore_for_file: camel_case_types

import '../../untils/export_file.dart';

class People_list extends StatefulWidget {
  const People_list({super.key});

  @override
  State<People_list> createState() => _People_listState();
}

class _People_listState extends State<People_list> {
  Map peoplesdata = {};
  List originalList = [];

  bool isLoading = false;
  Future peoplesListHandler() async {
    setState(() {
      isLoading = true;
    });
    Map data = await Services.peopleslist();

    if (data["message"] != null) {
      Fluttertoast.showToast(
        msg: data["message"],
      );
    } else {
      peoplesdata = data;
      originalList = data["rows"];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    peoplesListHandler();
    super.initState();
  }

  FocusNode myfocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kbackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Kwhite,
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 23.w,
              color: KdarkText,
            ),
          ),
          title: Text(
            "People",
            style: TextStyle(
              fontSize: kSixteenFont,
              fontWeight: kFW700,
              color: KdarkText,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(13.r),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  focusNode: myfocus,
                  onChanged: (value) {
                    setState(() {
                      peoplesdata["rows"] = originalList
                          .where((element) => element["Employee"]["fname"]
                              .toString()
                              .toLowerCase()
                              .contains(value.toString().toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () {
                          myfocus.requestFocus();
                        },
                        icon: const Icon(
                          Icons.search,
                          color: kSearchcolor,
                        )),
                    focusColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13.0, horizontal: 10.0),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kSearchcolor.withOpacity(0.2), width: 0.5),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kSearchcolor.withOpacity(0.2), width: 0.5),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kSearchcolor.withOpacity(0.2), width: 0.5),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kSearchcolor.withOpacity(0.2), width: 0.5),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kSearchcolor.withOpacity(0.2), width: 0.5),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    fillColor: kSearchcolor.withOpacity(0.15),
                    filled: true,

                    hintText: "Search Your Mates..",

                    //make hint text
                    hintStyle: TextStyle(
                      color: Klightgray.withOpacity(0.5),
                      fontSize: kTenFont,
                      fontWeight: FontWeight.w600,
                    ),
                    //create lable
                    labelText: 'Search',
                    //lable style
                    labelStyle: TextStyle(
                      color: Klightgray,
                      fontSize: kTenFont,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                isLoading == false
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: peoplesdata["rows"].length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              //Get.toNamed(KPeopledetailed);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              margin: EdgeInsets.only(top: 10.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13.r),
                                color: Kwhite,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Get.toNamed(KProfile);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          height: 55.h,
                                          width: 55.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13.r),
                                            color: Kwhite,
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: peoplesdata["rows"][index]
                                                              ["Employee"]
                                                          ["profile_pic"] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: KProfileimage +
                                                          peoplesdata["rows"]
                                                                      [index]
                                                                  ["Employee"]
                                                              ["profile_pic"],
                                                      height: 55.h,
                                                      width: 55.h,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/images/man.png",
                                                        height: 55.h,
                                                        width: 55.h,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "assets/images/man.png",
                                                      height: 55.h,
                                                      width: 55.h,
                                                      fit: BoxFit.cover,
                                                    )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            peoplesdata["rows"] != null
                                                ? "${peoplesdata["rows"][index]["Employee"]["fname"]} ${peoplesdata["rows"][index]["Employee"]["lname"]}"
                                                : "",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: kFW800,
                                                color: KdarkText),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              text: peoplesdata["rows"] != null
                                                  ? peoplesdata["rows"][index]
                                                      ["role_id"]
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: kFourteenFont,
                                                  fontWeight: kFW500,
                                                  color: Ktextcolor),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: peoplesdata["rows"] !=
                                                          null
                                                      ? " | ${peoplesdata["rows"][index]["Employee"]["emp_code"]}"
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: kTwelveFont,
                                                      fontWeight: kFW900,
                                                      color:
                                                          KdarkText.withOpacity(
                                                              0.6)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 10.h,
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     GestureDetector(
                                          //       onTap: () async {
                                          //         String email = Uri.encodeComponent(
                                          //             "${peoplesdata["rows"][index]["email"]} "
                                          //             // "jane@vibhotech.com"
                                          //             );
                                          //         String subject =
                                          //             Uri.encodeComponent("Hi");
                                          //         String body = Uri.encodeComponent(
                                          //             "Hi! I'm Flutter Developer");
                                          //         print(
                                          //             subject); //output: Hello%20Flutter
                                          //         Uri mail = Uri.parse(
                                          //             "mailto:$email?subject=$subject&body=$body");
                                          //         if (await launchUrl(mail)) {
                                          //           //email app opened
                                          //         } else {
                                          //           //email app is not opened
                                          //         }
                                          //       },
                                          //       child: Text(
                                          //         peoplesdata["rows"] != null
                                          //             ? "${peoplesdata["rows"][index]["email"]} "
                                          //             : "",
                                          //         style: TextStyle(
                                          //             fontSize: 11.sp,
                                          //             fontWeight: kFW800,
                                          //             color: KdarkText
                                          //                 .withOpacity(0.5)),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
GestureDetector(
                                                    onTap: () async {
                                                      String email = Uri.encodeComponent(
                                                          "${peoplesdata["rows"][index]["email"]} "
                                                          // "jane@vibhotech.com"
                                                          );
                                                      String subject =
                                                          Uri.encodeComponent(
                                                              "Hello");
                                                      String body =
                                                          Uri.encodeComponent(
                                                              "Hello! ${peoplesdata["rows"][index]["Employee"]["fname"]} ${peoplesdata["rows"][index]["Employee"]["lname"]}");
                                                      print(
                                                          subject); //output: Hello%20Flutter
                                                      Uri mail = Uri.parse(
                                                          "mailto:$email?subject=$subject&body=$body");
                                                      if (await launchUrl(mail)) {
                                                        //email app opened
                                                      } else {
                                                        //email app is not opened
                                                      }
                                                    },
                                            child: SizedBox(
                                              width: 230.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // SizedBox(
                                                  //   width: 15.w,
                                                  // ),
                                                  SizedBox(
                                                    width: 150.w,
                                                    child: Text(
                                                      peoplesdata["rows"] != null
                                                          ? "${peoplesdata["rows"][index]["email"]} "
                                                          : "",
                                                          maxLines: 2,
                                                      // peoplesdata["rows"] != null
                                                      //     ? "${peoplesdata["rows"][index]["email"]} "
                                                      //     : "",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontWeight: kFW800,
                                                          color:
                                                              KdarkText.withOpacity(
                                                                  0.5)),
                                                    ),
                                                  ),
                                                  Icon(
                                                      Icons.mail,
                                                      size: kSixteenFont,
                                                      color: KOrange,
                                                    ),
                                                  
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      var url = Uri.parse(
                                                          "tel:${peoplesdata["rows"][index]["Employee"]["phone_no"]}");
                                                      if (await canLaunchUrl(
                                                          url)) {
                                                        await launchUrl(url);
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                            child: SizedBox(
                                              width: 230.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [

                                                  Text(

                                                    peoplesdata["rows"] != null
                                                        ? "${peoplesdata["rows"][index]["Employee"]["phone_no_code"]} ${peoplesdata["rows"][index]["Employee"]["phone_no"]}"
                                                        : "",
                                          
                                                    //   $.rows.[]Employee.phone_no
                                                    style: TextStyle(
                                                        fontSize: 11.sp,
                                                        fontWeight: kFW800,
                                                        color:
                                                            KdarkText.withOpacity(
                                                                0.5)),
                                                  ),

 Icon(
                                                      Icons.phone,
                                                      size: kSixteenFont,
                                                      color: Kgreen,
                                                    ),
                                                  
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const SpinKitWave(
                        color: KOrange,
                        size: 25,
                      )
              ],
            ),
          ),
        ));
  }
}
