// ignore_for_file: camel_case_types

import '../untils/export_file.dart';

class Security_view extends StatefulWidget {
  const Security_view({super.key});

  @override
  State<Security_view> createState() => _Security_viewState();
}

class _Security_viewState extends State<Security_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kbackground,
        appBar: const VibhoAppBar(
          bColor: Kbackground,
          title: 'Security',
          dontHaveBackAsLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.all(10.r),
                        padding: EdgeInsets.only(
                            left: 10.w, right: 10.w, top: 15.h, bottom: 5.h),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Ktextcolor.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 0),
                                spreadRadius: 2, //New
                              )
                            ],
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: const LinearGradient(
                                colors: [KdarkText, Klightgray],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center)),
                        child: Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/finger.png",
                              height: 28.h,
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 125.w,
                              child: Text(
                                "Biometric",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: kFW900,
                                    color: Kwhite),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: 105.w,
                              child: Text(
                                "Active",
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: kTenFont,
                                    fontWeight: kFW900,
                                    color: Kgreen),
                              ),
                            ),
                            SizedBox(height: 5.h,),
                            SvgPicture.asset("assets/images/arrow.svg",
                                color: KOrange,
                                alignment: Alignment.bottomLeft,
                               
                                fit: BoxFit.fill,
                                semanticsLabel: 'Acme Logo')
                            // Image.asset(
                            //   "assets/images/arrow.png",
                            //   height: 30.h,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {             // AppSettings.openAppSettings();
},
                      child: Container(
                        margin: EdgeInsets.all(10.r),
                        padding: EdgeInsets.only(
                            left: 10.w, right: 10.w, top: 15.h, bottom: 5.h),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Ktextcolor.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 0),
                                spreadRadius: 2, //New
                              )
                            ],
                            borderRadius: BorderRadius.circular(12.r),
                            color: Kwhite),
                        child: Column(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/face.png",
                              height: 28.h,
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 125.w,
                              child: Text(
                                "Facial Recognition",
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: kFW600,
                                    color: KdarkText),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: 105.w,
                              child: Text(
                                "In-Active",
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: kTenFont,
                                    fontWeight: kFW800,
                                    color: KRed),
                              ),
                            ),
                             SizedBox(height: 5.h,),
                            SvgPicture.asset("assets/images/arrow.svg",
                                color: KOrange,
                                alignment: Alignment.bottomLeft,
                               
                                fit: BoxFit.fill,
                                semanticsLabel: 'Acme Logo')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
