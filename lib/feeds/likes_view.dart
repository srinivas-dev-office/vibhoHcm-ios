// ignore_for_file: camel_case_types

import '../untils/export_file.dart';

class post_likes extends StatefulWidget {
  const post_likes({super.key});

  @override
  State<post_likes> createState() => _post_likesState();
}

class _post_likesState extends State<post_likes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Kbackground,
        appBar: const VibhoAppBar(
          title: "All Likes",
          dontHaveBackAsLeading: false,
          bColor: Kbackground,
        ),
        body: Container(
          margin: EdgeInsets.all(13.r),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10.h),
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Kwhite,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Get.toNamed(KProfile);
                        },
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Ktextcolor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                  spreadRadius: 5, //New
                                )
                              ],
                              borderRadius: BorderRadius.circular(13.r),
                              color: Kwhite,
                            ),
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(13.r), // Image border
                                child: Image.asset(
                                  "assets/images/man.png",
                                  fit: BoxFit.contain,
                                ))),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "data",
                            style: TextStyle(
                                fontSize: kFourteenFont,
                                fontWeight: kFW700,
                                color: KdarkText),
                          ),
                          SizedBox(
                            height: 7.w,
                          ),
                          Text(
                            "data",
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.normal,
                                color: Klightblack.withOpacity(0.5)),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ));
  }
}
