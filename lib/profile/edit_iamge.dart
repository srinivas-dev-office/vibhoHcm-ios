import 'dart:convert';
import 'dart:io';

import '../untils/export_file.dart';

class Profile_image extends StatefulWidget {
  const Profile_image({super.key});

  @override
  State<Profile_image> createState() => _ProfileimageState();
}

class _ProfileimageState extends State<Profile_image> {
  File? selectedImage;
  String base64Image = "";
  ServiceController controller = Get.put(ServiceController());

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
      var value = await Services.profileimage(File(image.path));
      controller.profileImageData = value["msg"];
      // Fluttertoast.showToast(msg: value["msg"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80.r),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 6),
            color: Ktextcolor.withOpacity(0.5),
          )
        ],
        //border: Border.all(color: Ktextcolor)
        //color: Kwhite,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ClipOval(
              child: selectedImage != null
                  ? Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    )
                  : Image.asset(
                      "assets/images/man.png",
                      fit: BoxFit.contain,
                    )),
          Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () {
                    chooseImage("Gallery");
                  },
                  child: CircleAvatar(
                    backgroundColor: KOrange,
                    radius: 18,
                    child: Image.asset(
                      "assets/images/photo.png",
                      width: 19.w,
                    ),
                  ))),
        ],
      ),
    );
    // Stack(
    //   children: [
    //     Container(
    //       height: 95.h,
    //       decoration: BoxDecoration(
    //         border: Border.all(color: Kwhite, width: 1.0),
    //         borderRadius: const BorderRadius.all(Radius.circular(80.0)),
    //       ),
    //       child: Row(
    //         // clipBehavior: Clip.none,
    //         // fit: StackFit.expand,
    //         children: [
    //           ClipOval(

    //                 child: selectedImage != null
    //                     ? Image.file(
    //                         selectedImage!,
    //                         fit: BoxFit.cover,
    //                         height: 100,
    //                         width: 100,
    //                       )
    //                     : Image.asset(
    //                         "assets/images/man.png,
    //                         fit: BoxFit.contain,
    //                       )),

    //           SizedBox(
    //             width: 5.w,
    //           ),
    //           GestureDetector(
    //             onTap: () {
    //               chooseImage("Gallery");
    //             },
    //             child: Text(
    //               "Change Photo",
    //               style: TextStyle(
    //                   fontSize: 14.sp, fontWeight: kFW700, color: KdarkText),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
