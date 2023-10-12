// ignore_for_file: camel_case_types

import 'package:geocoding/geocoding.dart';

import '../untils/export_file.dart';

class Profile_view extends StatefulWidget {
  final int BACK;
  const Profile_view({super.key, required this.BACK});

  @override
  State<Profile_view> createState() => _Profile_viewState();
}

class _Profile_viewState extends State<Profile_view> {
  @override
  void initState() {
    profileListApi();
    _determinePosition();
    super.initState();
  }

  ServiceController serviceController = Get.put(ServiceController());

  bool isPermissionGiven = false;
  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 350.h,

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
                  Text('Location Permission',
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: 14.sp,
                          fontWeight: kFW900)),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text('Please allow location permission for the Attendance',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: KdarkText,
                          fontSize: kTenFont,
                          fontWeight: kFW500)),
                  SizedBox(
                    height: 15.h,
                  ),
                  Image.asset(
                    "assets/images/location.png",
                    width: 150.w,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Custom_OutlineButton(
                          borderRadius: BorderRadius.circular(15.r),
                          margin: EdgeInsets.all(10.r),
                          width: 110.w,
                          height: 35.h,
                          Color: KOrange,
                          textColor: KOrange,
                          fontSize: 12.sp,
                          fontWeight: kFW700,
                          label: "Cancel",
                          isLoading: false,
                          onTap: () {
                            setState(() {
                              isPermissionGiven = false;
                            });
                            Navigator.of(context).pop();
                          }),
                      CustomButton(
                          borderRadius: BorderRadius.circular(15.r),
                          margin: EdgeInsets.all(10.r),
                          width: 110.w,
                          height: 35.h,
                          Color: KOrange,
                          textColor: Kwhite,
                          fontSize: 11.sp,
                          fontWeight: kFW700,
                          label: "Continue",
                          isLoading: false,
                          onTap: () {
                            setState(() {
                              isPermissionGiven = true;
                            });
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

  _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      } else {
        await _showMyDialog();
        if (isPermissionGiven == true) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        } else {
          Fluttertoast.showToast(
            msg: "Denined Location Will Failed To Upload Attendance",
          );
        }
      }
    } else {
      setState(() {
        isPermissionGiven = true;
      });
    }

    setState(() {
      isLoading = false;
    });

    return await Geolocator.getCurrentPosition();
  }

  String? _currentAddress;
  void _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    Position position = await _determinePosition();
    setState(() {
      serviceController.position = position;
      serviceController.latittude = serviceController.position!.latitude;
      serviceController.longitude = serviceController.position!.longitude;
      _getAddressFromLatLng(position);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(serviceController.position!.latitude,
            serviceController.position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea},${place.postalCode}';
        serviceController.address.value = _currentAddress.toString();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Map profiledata = {};

  bool isLoading = false;
  Future profileListApi() async {
    setState(() {
      isLoading = true;
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
      isLoading = false;
    });
  }

  List<String> interests = [
    'Singing',
    'Exploring Places',
    'Storytelling',
    'Influencer',
  ];

  final String LOCATION = 'assets/images/location.svg';

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) async {
    /// _determinePosition();
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        _determinePosition();
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        _determinePosition();
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kwhite,
        appBar: VibhoAppBar(
            bColor: Kwhite,
            title: 'Profile',
            trailing: Padding(
              padding: EdgeInsets.only(right: 15.w, top: 5.h),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(KSetting);
                },
                child: Image.asset(
                  "assets/images/setting1.png",
                  width: 25.w,
                ),
              ),
            ),
            //

            dontHaveBackAsLeading: widget.BACK == 1 ? true : false),
        body: SingleChildScrollView(
// <<<<<<< Nayak_fix_bugs_on_fourth
            child: Container(
          margin: EdgeInsets.all(15.r),
          child: profiledata["profile_pic"] != null
              //profiledata != null
              ? Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(5),
                        height: 90.h,
                        width: 90.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.r),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 6),
                              color: Ktextcolor.withOpacity(0.5),
                            )
                          ],
                          //border: Border.all(color: Ktextcolor)
                          //color: Kwhite,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(80.r),
                            // Image border
                            child: profiledata["profile_pic"] != null &&
                                    profiledata["profile_pic"] != ""
                                ? Image.network(
                                    KProfileimage + profiledata["profile_pic"],
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        "assets/images/man.png",
                                        fit: BoxFit.contain,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/man.png",
                                    fit: BoxFit.contain,
                                  ))),
// =======
//           child: Container(
//             margin: EdgeInsets.all(15.r),
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                     margin: const EdgeInsets.all(5),
//                     height: 90.h,
//                     width: 90.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(80.r),
//                       boxShadow: [
//                         BoxShadow(
//                           spreadRadius: 2,
//                           blurRadius: 10,
//                           offset: Offset(0, 6),
//                           color: Ktextcolor.withOpacity(0.5),
//                         )
//                       ],
//                       //border: Border.all(color: Ktextcolor)
//                       //color: Kwhite,
//                     ),
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(80.r),
//                         // Image border
//                         child: profiledata["profile_pic"] != null &&
//                                 profiledata["profile_pic"] != ""
//                             ? CachedNetworkImage(
//                                 imageUrl:
//                                     KProfileimage + profiledata["profile_pic"],
//                                 errorWidget: (context, url, error) =>
//                                     Image.asset(
//                                   "assets/images/man.png",
//                                   fit: BoxFit.contain,
//                                 ),
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.asset(
//                                 "assets/images/man.png",
//                                 fit: BoxFit.contain,
//                               ))),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Text(
//                   profiledata["fname"] != null
//                       ? "${profiledata["fname"]} ${profiledata["lname"]}"
//                       : "-",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 16.sp, fontWeight: kFW700, color: KdarkText),
//                 ),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 RichText(
//                   textAlign: TextAlign.center,
//                   text: TextSpan(
//                     text: profiledata["Designation"] != null
//                         ? "${profiledata["Designation"]["designation_name"]} | "
//                         : "-",
//                     style: TextStyle(
//                         fontSize: 13.sp,
//                         fontWeight: kFW400,
//                         color: Klightblack.withOpacity(0.8)),
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: profiledata["emp_code"] != null
//                             ? profiledata["emp_code"]
//                             : "-",
//                         style: TextStyle(
//                             fontSize: 13.sp,
//                             fontWeight: kFW900,
//                             color: KOrange),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // SvgPicture.asset(LOCATION,
//                     //           color: KOrange,
//                     //           fit: BoxFit.fill,
//                     //           semanticsLabel: 'Acme Logo'),
//                     Image.asset(
//                       "assets/images/pray.png",
//                       width: 20,
//                       color: KOrange,
//                       fit: BoxFit.fill,
//                     ),
// >>>>>>> master
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      profiledata["fname"] != null
                          ? "${profiledata["fname"]} ${profiledata["lname"]}"
                          : "-",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: kFW700,
                          color: KdarkText),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: profiledata["Designation"] != null
                            ? "${profiledata["Designation"]["designation_name"]} | "
                            : "-",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: kFW400,
                            color: Klightblack.withOpacity(0.8)),
                        children: <TextSpan>[
                          TextSpan(
                            text: profiledata["emp_code"] != null
                                ? profiledata["emp_code"]
                                : "-",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: kFW900,
                                color: KOrange),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(LOCATION,
                        //           color: KOrange,
                        //           fit: BoxFit.fill,
                        //           semanticsLabel: 'Acme Logo'),
                        Image.asset(
                          "assets/images/pray.png",
                          width: 20,
                          color: KOrange,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          profiledata.isNotEmpty
                              ? profiledata["permanent_address"]
                                  .toString()
                                  .trim()
                              : "-",
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW800,
                              color: Klightblack),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.toNamed(KEditProfile);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                          width: 90.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: KDarkskyblue.withOpacity(0.15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset(LOCATION,
                              //     color: KCustomDarktwo,
                              //     fit: BoxFit.fill,
                              //     semanticsLabel: 'Acme Logo'),
                              Image.asset(
                                "assets/images/write.png",
                                width: 18,
                                fit: BoxFit.fill,
                              ),

                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Klightblack.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                        margin: EdgeInsets.all(5.r),
                        padding: EdgeInsets.all(10.r),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.r),
                          color: Kwhite,
                          boxShadow: [
                            BoxShadow(
                              color: Ktextcolor.withOpacity(0.15),
                              blurRadius: 5,
                              offset: const Offset(0, 7),
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: kFW700,
                                  color: KdarkText),
                            ),

                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              profiledata["comments"] != null
                                  ? profiledata["comments"]
                                  : "-",
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  height: 1.1.h,
                                  fontSize: 11.sp,
                                  fontWeight: kFW600,
                                  color: KCustomDarktwo.withOpacity(0.7)),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            // Text(
                            //   "Interests",
                            //   style: TextStyle(
                            //       fontSize: 15.sp,
                            //       fontWeight: kFW700,
                            //       color: KdarkText),
                            // ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   //height: MediaQuery.of(context).size.height * 0.0,
                            //   child: Wrap(
                            //       children: interests
                            //           .map((interest) => Container(
                            //                 margin: EdgeInsets.only(
                            //                     right: 10.w, top: 10.h),
                            //                 decoration: BoxDecoration(
                            //                     borderRadius:
                            //                         BorderRadius.circular(12.r),
                            //                     border: Border.all(
                            //                         color:
                            //                             Kgreen.withOpacity(0.2))),
                            //                 padding: EdgeInsets.symmetric(
                            //                     horizontal: MediaQuery.of(context)
                            //                             .size
                            //                             .width *
                            //                         0.040,
                            //                     vertical: MediaQuery.of(context)
                            //                             .size
                            //                             .height *
                            //                         0.0035),
                            //                 child: Text(interest,
                            //                     style: TextStyle(
                            //                         fontSize: 11.5.sp,
                            //                         fontWeight: kFW600,
                            //                         color: Klightblack.withOpacity(
                            //                             0.9))),
                            //               ))
                            //           .toList()),
                            // ),
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Show Location",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: kFW900,
                              color: KdarkText),
                        ),
                        Switch(
                          onChanged: toggleSwitch,
                          value: isPermissionGiven,
                          activeColor: KOrange,
                          activeTrackColor: KOrange.withOpacity(0.7),
                          inactiveThumbColor: Klightgray,
                          inactiveTrackColor: Klightgray.withOpacity(0.5),
                        )
                      ],
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(top: 250.h),
                  child: SpinKitWave(
                    color: KOrange,
                    size: 25,
                  ),
                ),
        )));
  }
}
