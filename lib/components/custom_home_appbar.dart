import '../untils/export_file.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(55.h), // here the desired height
      child: AppBar(
        //titleSpacing: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(
          "assets/images/logo.png",
          width: 100.w,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(KNotification);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Image.asset(
                "assets/images/bell.png",
                width: 25,
              ),
            ),
          )
        ],
        backgroundColor: Kwhite,
        // backgroundColor: Kbackground,
      ),
    );
  }
}
