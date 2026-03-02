import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/dash_board_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'home_screens/home_screen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<DashBoardController>(
      init: DashBoardController(),
      builder: (controller) {
        final bool isHome = controller.selectedDrawerIndex.value == 0;

        return Scaffold(
          // Drawer kept (hamburger disabled only on Home for demo)
          drawer: buildAppDrawer(context, controller),
          drawerEnableOpenDragGesture: false,
          // For Home: No AppBar (we draw top bar over map)
          // For other pages: keep old AppBar
          appBar: isHome ? null : AppBar(
            backgroundColor: AppColors.qlypDeepPurple,
            centerTitle: true,
            title: Text(
              controller.drawerItems[controller.selectedDrawerIndex.value]
                  .title
                  .tr,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            leading: Builder(
              builder: (context) {
                return InkWell(
                  onTap: () => {} /*Scaffold.of(context).openDrawer()*/,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 20,
                      top: 20,
                      bottom: 20,
                    ),
                    child:
                    SvgPicture.asset('assets/icons/ic_humber.svg'),
                  ),
                );
              },
            ),
          ),

          body: WillPopScope(
            onWillPop: controller.onWillPop,
            child: isHome
                ? Stack(
              clipBehavior: Clip.none,
              children: [
                const Positioned.fill(child: HomeScreen()),

                // TOP BAR (hamburger disabled)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // disabled for meeting
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.qlypDark.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                              ),
                            ),
                            child: Icon(
                              Icons.menu_rounded,
                              color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.qlypDark.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.qlypPrimaryLight.withOpacity(0.10),
                              ),
                            ),
                            child: Text(
                              "USD 0.00",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.qlypPrimaryLight.withOpacity(0.90),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.qlypDark.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                            ),
                          ),
                          child: Icon(
                            Icons.my_location_rounded,
                            size: 20,
                            color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ✅ GO button (OUTSIDE bottom status stack - FIXED)
                StreamBuilder(
                  stream: FireStoreUtils.fireStore
                      .collection(CollectionName.driverUsers)
                      .doc(FireStoreUtils.getCurrentUid())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.data() == null) {
                      return const SizedBox.shrink();
                    }

                    final driverModel =
                    DriverUserModel.fromJson(snapshot.data!.data()!);
                    final bool isOnline = driverModel.isOnline == true;

                    Future<void> goOnline() async {
                      ShowToastDialog.showLoader("Please wait".tr);

                      if (driverModel.documentVerification == false &&
                          Constant.isVerifyDocument == true) {
                        ShowToastDialog.closeLoader();
                        await _showAlertDialog(context, "document");
                        return;
                      } else if (driverModel.vehicleInformation == null ||
                          driverModel.serviceId == null) {
                        ShowToastDialog.closeLoader();
                        await _showAlertDialog(context, "vehicleInformation");
                        return;
                      } else {
                        driverModel.isOnline = true;
                        await FireStoreUtils.updateDriverUser(driverModel);
                        ShowToastDialog.closeLoader();
                      }
                    }

                    // Show GO only when OFFLINE
                    if (isOnline) return const SizedBox.shrink();

                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 130, // ✅ above status bar
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: goOnline,
                            borderRadius: BorderRadius.circular(100),
                            child: Ink(
                              width: 59,
                              height: 59,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.centerRight,
                                  colors: [
                                    AppColors.qlypMutedRose,
                                    AppColors.qlypMutedRose,
                                    AppColors.qlypMutedRose,
                                  ],
                                  stops: [0.0, 0.55, 1.0],
                                ),
                              ),

                              /*    decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    AppColors.qlypPrimaryLight,
                                    AppColors.qlypSecondaryLight,
                                    AppColors.qlypMutedRose,
                                  ],
                                  stops: [0.0, 0.55, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    AppColors.qlypMutedRose.withOpacity(0.35),
                                    blurRadius: 22,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),*/
                              child: Center(
                                child: Text(
                                  "Go".tr,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.qlypSecondaryLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // BOTTOM STATUS (tap to go offline when online)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder(
                    stream: FireStoreUtils.fireStore
                        .collection(CollectionName.driverUsers)
                        .doc(FireStoreUtils.getCurrentUid())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const SizedBox.shrink();
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 22),
                          child: Constant.loader(
                              isDarkTheme: themeChange.getThem()),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data?.data() == null) {
                        return const SizedBox.shrink();
                      }

                      final driverModel =
                      DriverUserModel.fromJson(snapshot.data!.data()!);
                      final bool isOnline = driverModel.isOnline == true;

                      Future<void> goOffline() async {
                        ShowToastDialog.showLoader("Please wait".tr);
                        driverModel.isOnline = false;
                        await FireStoreUtils.updateDriverUser(driverModel);
                        ShowToastDialog.closeLoader();
                      }

                      return SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: GestureDetector(
                            onTap: isOnline ? goOffline : null,
                            child: Container(
                              height: 62,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.qlypDark.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isOnline ? "You're online".tr : "You're offline".tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.qlypPrimaryLight
                                      .withOpacity(0.92),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
                : controller.getDrawerItemWidget(controller.selectedDrawerIndex.value),
          ),



          /*body: WillPopScope(
            onWillPop: controller.onWillPop,
            child: isHome
                ? Stack(
              children: [
                const Positioned.fill(child: HomeScreen()),

                // TOP BAR (hamburger disabled)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // disabled for meeting
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.qlypDark.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                              ),
                            ),
                            child: Icon(
                              Icons.menu_rounded,
                              color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.qlypDark.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors.qlypPrimaryLight.withOpacity(0.10),
                              ),
                            ),
                            child: Text(
                              "USD 0.00",
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.qlypPrimaryLight.withOpacity(0.90),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.qlypDark.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                            ),
                          ),
                          child: Icon(
                            Icons.my_location_rounded,
                            size: 20,
                            color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BOTTOM STATUS + GO (same old logic)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder(
                    stream: FireStoreUtils.fireStore
                        .collection(CollectionName.driverUsers)
                        .doc(FireStoreUtils.getCurrentUid())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return const SizedBox.shrink();
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 22),
                          child: Constant.loader(isDarkTheme: themeChange.getThem()),
                        );
                      }

                      final driverModel =
                      DriverUserModel.fromJson(snapshot.data!.data()!);
                      final bool isOnline = driverModel.isOnline == true;

                      Future<void> goOnline() async {
                        ShowToastDialog.showLoader("Please wait".tr);

                        if (driverModel.documentVerification == false &&
                            Constant.isVerifyDocument == true) {
                          ShowToastDialog.closeLoader();
                          await _showAlertDialog(context, "document");
                          return;
                        } else if (driverModel.vehicleInformation == null ||
                            driverModel.serviceId == null) {
                          ShowToastDialog.closeLoader();
                          await _showAlertDialog(context, "vehicleInformation");
                          return;
                        } else {
                          driverModel.isOnline = true;
                          await FireStoreUtils.updateDriverUser(driverModel);
                          ShowToastDialog.closeLoader();
                        }
                      }

                      Future<void> goOffline() async {
                        ShowToastDialog.showLoader("Please wait".tr);
                        driverModel.isOnline = false;
                        await FireStoreUtils.updateDriverUser(driverModel);
                        ShowToastDialog.closeLoader();
                      }

                      return SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              GestureDetector(
                                onTap: isOnline ? goOffline : null,
                                child: Container(
                                  height: 62,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.qlypDark.withOpacity(0.92),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isOnline
                                        ? "You're online".tr
                                        : "You're offline".tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.qlypPrimaryLight
                                          .withOpacity(0.92),
                                    ),
                                  ),
                                ),
                              ),
                              if (!isOnline)
                                Positioned(
                                  bottom: 72,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: goOnline,
                                      borderRadius: BorderRadius.circular(100),
                                      child: Ink(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              AppColors.qlypPrimaryLight,
                                              AppColors.qlypSecondaryLight,
                                              AppColors.qlypMutedRose,
                                            ],
                                            stops: [0.0, 0.55, 1.0],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.qlypMutedRose
                                                  .withOpacity(0.35),
                                              blurRadius: 22,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Go".tr,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.qlypDark,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
                : controller.getDrawerItemWidget(controller.selectedDrawerIndex.value),
          ),*/

        );
      },
    );
  }

  // ✅ SAME alert dialog logic (unchanged)
  Future<void> _showAlertDialog(BuildContext context, String type) async {
    final controllerDashBoard = Get.put(DashBoardController());
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'To start earning with QlYP you need to fill in your personal information'
                      .tr,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'.tr),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text('Yes'.tr),
              onPressed: () {
                if (type == "document") {
                  if (Constant.isVerifyDocument == true) {
                    controllerDashBoard.onSelectItem(8);
                  } else {
                    controllerDashBoard.onSelectItem(7);
                  }
                } else {
                  if (Constant.isVerifyDocument == true) {
                    controllerDashBoard.onSelectItem(9);
                  } else {
                    controllerDashBoard.onSelectItem(8);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ✅ Drawer unchanged (same as your old code)
  Drawer buildAppDrawer(BuildContext context, DashBoardController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var drawerOptions = <Widget>[];
    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      drawerOptions.add(
        InkWell(
          onTap: () {
            controller.onSelectItem(i);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: i == controller.selectedDrawerIndex.value
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SvgPicture.asset(
                    d.icon,
                    width: 20,
                    color: i == controller.selectedDrawerIndex.value
                        ? themeChange.getThem()
                        ? Colors.black
                        : Colors.white
                        : themeChange.getThem()
                        ? Colors.white
                        : AppColors.drawerIcon,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    d.title.tr,
                    style: GoogleFonts.poppins(
                      color: i == controller.selectedDrawerIndex.value
                          ? themeChange.getThem()
                          ? Colors.black
                          : Colors.white
                          : themeChange.getThem()
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: FutureBuilder<DriverUserModel?>(
              future: FireStoreUtils.getDriverProfile(
                FireStoreUtils.getCurrentUid(),
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Constant.loader(isDarkTheme: themeChange.getThem());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      DriverUserModel driverModel = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              height: Responsive.width(18, context),
                              width: Responsive.width(18, context),
                              imageUrl: driverModel.profilePic.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Constant.loader(isDarkTheme: themeChange.getThem()),
                              errorWidget: (context, url, error) =>
                                  Image.network(Constant.userPlaceHolder),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              driverModel.fullName.toString(),
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              driverModel.email.toString(),
                              style: GoogleFonts.poppins(),
                            ),
                          )
                        ],
                      );
                    }
                  default:
                    return Text('Error'.tr);
                }
              },
            ),
          ),
          Column(children: drawerOptions),
        ],
      ),
    );
  }
}

class _HomeDemoLayout extends StatelessWidget {
  final DarkThemeProvider themeChange;
  final Future<void> Function(BuildContext, String) showAlertDialog;

  const _HomeDemoLayout({
    required this.themeChange,
    required this.showAlertDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: HomeScreen(),
        ),

        // ✅ TOP BAR (hamburger disabled for now)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Row(
              children: [
                // Hamburger (disabled)
                InkWell(
                  onTap: () {
                    // ✅ Disabled for 1st meeting (as requested)
                    // Scaffold.of(context).openDrawer();
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.qlypDark.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                      ),
                    ),
                    child: Icon(
                      Icons.menu_rounded,
                      color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // USD badge (keep text untouched)
                Expanded(
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.qlypDark.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.qlypPrimaryLight.withOpacity(0.10),
                      ),
                    ),
                    child: Text(
                      "USD 0.00",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.qlypPrimaryLight.withOpacity(0.90),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Location icon (no action for now)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.qlypDark.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                    ),
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    size: 20,
                    color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ✅ BOTTOM STATUS + GO button (old dashboard functionality)
        Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder(
            stream: FireStoreUtils.fireStore
                .collection(CollectionName.driverUsers)
                .doc(FireStoreUtils.getCurrentUid())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const SizedBox.shrink();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Constant.loader(isDarkTheme: themeChange.getThem()),
                );
              }

              final driverModel =
              DriverUserModel.fromJson(snapshot.data!.data()!);
              final bool isOnline = driverModel.isOnline == true;

              // ✅ SAME OLD "ONLINE" logic (unchanged)
              Future<void> goOnline() async {
                ShowToastDialog.showLoader("Please wait".tr);

                if (driverModel.documentVerification == false &&
                    Constant.isVerifyDocument == true) {
                  ShowToastDialog.closeLoader();
                  await showAlertDialog(context, "document");
                  return;
                } else if (driverModel.vehicleInformation == null ||
                    driverModel.serviceId == null) {
                  ShowToastDialog.closeLoader();
                  await showAlertDialog(context, "vehicleInformation");
                  return;
                } else {
                  driverModel.isOnline = true;
                  await FireStoreUtils.updateDriverUser(driverModel);
                  ShowToastDialog.closeLoader();
                }
              }

              // ✅ SAME OLD "OFFLINE" logic (unchanged)
              Future<void> goOffline() async {
                ShowToastDialog.showLoader("Please wait".tr);
                driverModel.isOnline = false;
                await FireStoreUtils.updateDriverUser(driverModel);
                ShowToastDialog.closeLoader();
              }

              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Bottom status (covers any bottom bar behind it)
                      GestureDetector(
                        onTap: isOnline ? goOffline : null,
                        child: Container(
                          height: 62,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.qlypDark.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isOnline ? "You're online".tr : "You're offline".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.qlypPrimaryLight.withOpacity(0.92),
                            ),
                          ),
                        ),
                      ),

                      // GO button above status (only when offline)
                      if (!isOnline)
                        Positioned(
                          bottom: 50,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: goOnline,
                              borderRadius: BorderRadius.circular(100),
                              child: Ink(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      AppColors.qlypPrimaryLight,
                                      AppColors.qlypSecondaryLight,
                                      AppColors.qlypMutedRose,
                                    ],
                                    stops: [0.0, 0.55, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.qlypMutedRose.withOpacity(0.35),
                                      blurRadius: 22,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Go".tr,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.qlypDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}



/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/dash_board_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.lightprimary,
              title: controller.selectedDrawerIndex.value == 0
                  ? StreamBuilder(
                      stream: FireStoreUtils.fireStore.collection(CollectionName.driverUsers).doc(FireStoreUtils.getCurrentUid()).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong'.tr);
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Constant.loader(isDarkTheme: themeChange.getThem());
                        }

                        DriverUserModel driverModel = DriverUserModel.fromJson(snapshot.data!.data()!);
                        return Container(
                          width: Responsive.width(50, context),
                          height: Responsive.height(5.5, context),
                          decoration: const BoxDecoration(
                            color: AppColors.darkBackground,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                alignment: Alignment(driverModel.isOnline == true ? -1 : 1, 0),
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: Responsive.width(26, context),
                                  height: Responsive.height(8, context),
                                  decoration: BoxDecoration(
                                    color: themeChange.getThem() ? AppColors.darksecondprimary : AppColors.lightsecondprimary,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ShowToastDialog.showLoader("Please wait");
                                  if (driverModel.documentVerification == false && Constant.isVerifyDocument == true) {
                                    ShowToastDialog.closeLoader();
                                    _showAlertDialog(context, "document");
                                  } else if (driverModel.vehicleInformation == null || driverModel.serviceId == null) {
                                    ShowToastDialog.closeLoader();
                                    _showAlertDialog(context, "vehicleInformation");
                                  } else {
                                    driverModel.isOnline = true;
                                    await FireStoreUtils.updateDriverUser(driverModel);

                                    ShowToastDialog.closeLoader();
                                  }
                                },
                                child: Align(
                                  alignment: const Alignment(-1, 0),
                                  child: Container(
                                    width: Responsive.width(26, context),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Online'.tr,
                                      style: GoogleFonts.poppins(color: driverModel.isOnline == true ? Colors.black : Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  driverModel.isOnline = false;
                                  await FireStoreUtils.updateDriverUser(driverModel);

                                  ShowToastDialog.closeLoader();
                                },
                                child: Align(
                                  alignment: const Alignment(1, 0),
                                  child: Container(
                                    width: Responsive.width(26, context),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Offline'.tr,
                                      style: GoogleFonts.poppins(color: driverModel.isOnline == false ? Colors.black : Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : Text(
                      controller.drawerItems[controller.selectedDrawerIndex.value].title.tr,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
              centerTitle: true,
              leading: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
                    child: SvgPicture.asset('assets/icons/ic_humber.svg'),
                  ),
                );
              }),
            ),
            drawer: buildAppDrawer(context, controller),
            body: WillPopScope(onWillPop: controller.onWillPop, child: controller.getDrawerItemWidget(controller.selectedDrawerIndex.value)),
          );
        });
  }

  Future<void> _showAlertDialog(BuildContext context, String type) async {
    final controllerDashBoard = Get.put(DashBoardController());

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Text('Information'.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('To start earning with QlYP you need to fill in your personal information'.tr),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'.tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('Yes'.tr),
              onPressed: () {
                if (type == "document") {
                  if (Constant.isVerifyDocument == true) {
                    controllerDashBoard.onSelectItem(8);
                  } else {
                    controllerDashBoard.onSelectItem(7);
                  }
                } else {
                  if (Constant.isVerifyDocument == true) {
                    controllerDashBoard.onSelectItem(9);
                  } else {
                    controllerDashBoard.onSelectItem(8);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Drawer buildAppDrawer(BuildContext context, DashBoardController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var drawerOptions = <Widget>[];
    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      drawerOptions.add(InkWell(
        onTap: () {
          controller.onSelectItem(i);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:
                BoxDecoration(color: i == controller.selectedDrawerIndex.value ? Theme.of(context).colorScheme.primary : Colors.transparent, borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SvgPicture.asset(
                  d.icon,
                  width: 20,
                  color: i == controller.selectedDrawerIndex.value
                      ? themeChange.getThem()
                          ? Colors.black
                          : Colors.white
                      : themeChange.getThem()
                          ? Colors.white
                          : AppColors.drawerIcon,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  d.title.tr,
                  style: GoogleFonts.poppins(
                      color: i == controller.selectedDrawerIndex.value
                          ? themeChange.getThem()
                              ? Colors.black
                              : Colors.white
                          : themeChange.getThem()
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: FutureBuilder<DriverUserModel?>(
                future: FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid()),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Constant.loader(isDarkTheme: themeChange.getThem());
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        DriverUserModel driverModel = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImage(
                                height: Responsive.width(18, context),
                                width: Responsive.width(18, context),
                                imageUrl: driverModel.profilePic.toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Constant.loader(isDarkTheme: themeChange.getThem()),
                                errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(driverModel.fullName.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                driverModel.email.toString(),
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          ],
                        );
                      }
                    default:
                      return Text('Error'.tr);
                  }
                }),
          ),
          Column(children: drawerOptions),
        ],
      ),
    );
  }
}
*/
