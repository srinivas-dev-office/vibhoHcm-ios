// ignore_for_file: camel_case_types

import '../untils/export_file.dart';

class Welcome_card extends StatefulWidget {
  const Welcome_card({super.key});

  @override
  State<Welcome_card> createState() => _WelcomecardState();
}

class _WelcomecardState extends State<Welcome_card> {
  Map profiledata = {};

  bool isLoading = false;
  Future profileListHandler() async {
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
      UserSimplePreferences.setUserdata(userData: data.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    profileListHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.r),
        color: Kwhite,
        boxShadow: [
          BoxShadow(
            color: Ktextcolor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 0),
            spreadRadius: 2, //New
          )
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Get.toNamed(KProfile);
            },
            child: Container(
                margin: const EdgeInsets.all(5),
                height: 50.h,
                width: 50.h,
                decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Ktextcolor.withOpacity(0.3),
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 0),
                  //     spreadRadius: 3, //New
                  //   )
                  // ],
                  borderRadius: BorderRadius.circular(13.r),
                  color: Kwhite,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.r), // Image border
                    child: profiledata["profile_pic"] != null &&
                            profiledata["profile_pic"] != ""
                        ? CachedNetworkImage(
                          imageUrl:
                            KProfileimage + profiledata["profile_pic"],
                                                                                      errorWidget: (context, url, error) =>  
                                                  Image.asset(
                                "assets/images/man.png",
                                fit: BoxFit.contain,
                                              ),
                            
                            
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/man.png",
                            fit: BoxFit.contain,
                          ))),
          ),
          SizedBox(
            width: 5.w,
          ),
          SizedBox(
            width: 220.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: "Hi!👋 ",
                    style: TextStyle(
                        fontSize: kSixteenFont,
                        fontWeight: kFW400,
                        color: KdarkText),
                    children: <TextSpan>[
                      TextSpan(
                        text: profiledata.isNotEmpty
                            ? "${profiledata["fname"]} ${profiledata["lname"]}"
                            : "-",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: kSixteenFont,
                            fontWeight: kFW700,
                            color: KdarkText),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.w,
                ),
                Text(
                  profiledata.isNotEmpty
                      ? profiledata["Designation"]["designation_name"]
                      : "-",
                  style: TextStyle(
                      fontSize: kTwelveFont,
                      fontWeight: FontWeight.normal,
                      color: Klightblack),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
