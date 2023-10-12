import 'dart:io';

import 'package:vibeshr/controllers/feedsController.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../untils/export_file.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

enum MediaType {
  image,
  video;
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();

  List<File> selectedImages = [];
  final picker = ImagePicker();
  MediaType _mediaType = MediaType.image;
  ServiceController serviceController = Get.put(ServiceController());
  FeedController feedController = Get.find<FeedController>();

  String? imagePath;
  bool isLoading = false;
  Map createpostData = {};

  createpost() async {
    setState(() {
      isLoading = true;
    });
    var data =
        await Services.uploadFileToServer(selectedImages[0].path, "post");
    Map payload = {
      "celebrate_id": serviceController.celebrateID ?? 0,
      "description": serviceController.celebrateText,
      "files": [
        {"file": data["msg"]}
      ]
    };
    Map postData = await Services.createPost(payload);

    if (postData["message"] != null) {
      Fluttertoast.showToast(
        msg: postData["message"],
      );
    } else {
      createpostData = postData;
      Fluttertoast.showToast(
        msg: "Post Success",
      );
      Get.back();
    }
    setState(() {
      isLoading = false;
    });
  }

////////Profile
  Map profiledata = {};

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

  @override
  void initState() {
    selectedImages.clear();
    serviceController.celebratepost.clear();
    profileListApi();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbackground,
      bottomSheet: isLoading == false
          ? CustomButton(
              borderRadius: BorderRadius.circular(30.r),
              margin: EdgeInsets.all(15.r),
              width: double.infinity,
              height: 38.h,
              Color: KOrange,
              textColor: Kwhite,
              fontSize: 13.sp,
              fontWeight: kFW700,
              label: "Create Post",
              isLoading: false,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  createpost();
                }
              })
          : const Center(
              child: SpinKitWave(
                color: KOrange,
                size: 15,
              ),
            ),
      appBar: const VibhoAppBar(bColor: Kbackground, title: "New Post"),
      body: Container(
        margin: EdgeInsets.all(13.r),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Kwhite),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.all(5),
                                height: 45.h,
                                width: 45.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13.r),
                                  color: Kwhite,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        13.r), // Image border
                                    child: profiledata["profile_pic"] != null &&
                                            profiledata["profile_pic"] != ""
                                        ? CachedNetworkImage(
                          imageUrl:
                                            KProfileimage +
                                                profiledata["profile_pic"],
                                            // errorBuilder: (BuildContext context,
                                            //     Object exception, StackTrace? stackTrace) {
                                            //   return Image.asset(
                                            //     "assets/images/man.png",
                                            //     fit: BoxFit.contain,
                                            //   );
                                            // },
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/images/man.png",
                                            fit: BoxFit.contain,
                                          ))),
                            SizedBox(
                              width: 6.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profiledata.isNotEmpty
                                      ? "${profiledata["fname"]} ${profiledata["lname"]}"
                                      : "-",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: kFW700,
                                      color: KdarkText),
                                ),
                                SizedBox(
                                  height: 7.w,
                                ),
                                Text(
                                  profiledata.isNotEmpty
                                      ? "${profiledata["Designation"]["designation_name"]}"
                                      : "-",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Klightblack.withOpacity(0.5)),
                                ),
                              ],
                            )
                          ],
                        ),
                        TextFormField(
                          cursorColor: KOrange,
                          controller: serviceController.celebratepost,
                          autofillHints: const [AutofillHints.email],
                          onEditingComplete: () =>
                              TextInput.finishAutofillContext(),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "What do you want to talk about?",
                              hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: kFW900,
                                  color: Ktextcolor.withOpacity(0.5))),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text ';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              serviceController.celebrateText = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 200.h,
                          color: Kbackground,
                          child: ListView.builder(
                              itemCount: selectedImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        (imagePath != null)
                                            ? Image.file(
                                                selectedImages[index],
                                                width: 300.w,
                                                height: 300.h,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 300,
                                                height: 300,
                                                color: Colors.grey[300]!,
                                              ),
                                        // Image.file(selectedImages[index],fit: BoxFit.contain,height: 200.w,),
                                        Positioned(
                                          right: 5.w,
                                          top: 3,
                                          child: InkWell(
                                            child: CircleAvatar(
                                              radius: 12.r,
                                              backgroundColor: Kwhite,
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 16.r,
                                                color: KdarkText,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedImages.replaceRange(
                                                    index, index + 1, []);
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ));
                              }),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Custom_textButton(
                                label: "Photos",
                                onTap: () {
                                  setState(() {
                                    _mediaType = MediaType.image;
                                    pickMedia(ImageSource.gallery);
                                  });
                                  //  getImages();
                                },
                                images: "assets/images/galley.png"),
                            SizedBox(
                              width: 50.w,
                            ),
                            // Custom_textButton(
                            //     label: "Video",
                            //     onTap: () {
                            //       setState(() {
                            //         _mediaType = MediaType.video;
                            //         pickMedia(ImageSource.gallery);
                            //       });
                            //     },
                            //     images: "assets/images/galley.png"),
                            Custom_textButton(
                                label: "Celebrate",
                                onTap: () {
                                  Get.toNamed(KCelebrates);
                                },
                                images: "assets/images/party.png"),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickMedia(ImageSource source) async {
    // selectedImages.clear();
    XFile? file;
    if (_mediaType == MediaType.image) {
      file = await ImagePicker().pickImage(source: source);
    } else {
      file = await ImagePicker().pickVideo(source: source);
    }
    if (file != null) {
      imagePath = file.path;
      selectedImages.add(File(file.path));
      if (_mediaType == MediaType.video) {
        imagePath = await VideoThumbnail.thumbnailFile(
            video: file.path,
            imageFormat: ImageFormat.PNG,
            quality: 100,
            maxWidth: 300,
            maxHeight: 300);
      }
      setState(() {});
    }
  }
}
