import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/login_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/ui/auth_screen/information_screen.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<LoginController>(
      init: LoginController(),
      builder: (controller) {
        final isDark = themeChange.getThem();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Color(0xff0C1A30), size: 20),
              onPressed: () => Get.back(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  // Illustration
                  Image.asset(
                    "assets/images/login_image.png",
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  // Headers
                  Text(
                    "Entrez votre numéro",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nous vous enverrons un code par SMS",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xff838EA1),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Inputs Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pays column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pays",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff0C1A30),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xffE2E5EA)),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(
                                  cursorColor: AppColors.qlypSecondaryWarmSand,
                                ),
                              ),
                              child: CountryCodePicker(
                                onChanged: (value) {
                                  controller.countryCode.value =
                                      value.dialCode.toString();
                                },
                                dialogBackgroundColor: Colors.white,
                                dialogTextStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                searchStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                initialSelection: controller.countryCode.value,
                                comparator: (a, b) =>
                                    b.name!.compareTo(a.name.toString()),
                                flagDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                textStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                padding: EdgeInsets.zero,
                                showDropDownButton: true,
                                searchDecoration: InputDecoration(
                                  hintText: "Search country".tr,
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xff838EA1),
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color(0xff0C1A30),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffE2E5EA),
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff0C1A30),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Phone Number column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Numéro de téléphone",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff0C1A30),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xffE2E5EA)),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: TextFormField(
                                  validator: (value) =>
                                      value != null && value.isNotEmpty
                                          ? null
                                          : 'Required'.tr,
                                  keyboardType: TextInputType.number,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller:
                                      controller.phoneNumberController.value,
                                  cursorColor: const Color(0xff0C1A30),
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff0C1A30),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "(514) 000-0000",
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xffC4C5C4),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Continuer Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => controller.sendCode(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff12223b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Continuer",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // OR Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xffE2E5EA),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          "Ou connectez-vous avec",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff7b8190),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xffE2E5EA),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google Config
                      InkWell(
                        onTap: () async {
/*
                                          ShowToastDialog.showLoader(
                                              "Please wait".tr);
                                          await controller
                                              .signInWithGoogle()
                                              .then((value) async {
                                            ShowToastDialog.closeLoader();
                                            if (value != null) {
                                              if (value.additionalUserInfo!
                                                  .isNewUser) {
                                                log("----->new user");
                                                DriverUserModel userModel =
                                                DriverUserModel();
                                                userModel.id = value.user!.uid;
                                                userModel.email =
                                                    value.user!.email;
                                                userModel.fullName =
                                                    value.user!.displayName;
                                                userModel.profilePic =
                                                    value.user!.photoURL;
                                                userModel.loginType = Constant
                                                    .googleLoginType;

                                                ShowToastDialog.closeLoader();
                                                Get.to(
                                                    const InformationScreen(),
                                                    arguments: {
                                                      "userModel": userModel,
                                                    });
                                              } else {
                                                log("----->old user");
                                                await FireStoreUtils
                                                    .userExitCustomerOrDriverRole(
                                                    value.user!.uid)
                                                    .then((userExit) async {
                                                  if (userExit == '') {
                                                    DriverUserModel userModel =
                                                    DriverUserModel();
                                                    userModel.id =
                                                        value.user!.uid;
                                                    userModel.email =
                                                        value.user!.email;
                                                    userModel.fullName = value
                                                        .user!.displayName;
                                                    userModel.profilePic =
                                                        value.user!.photoURL;
                                                    userModel.loginType =
                                                        Constant
                                                            .googleLoginType;

                                                    ShowToastDialog
                                                        .closeLoader();
                                                    Get.to(
                                                        const InformationScreen(),
                                                        arguments: {
                                                          "userModel":
                                                          userModel,
                                                        });
                                                  } else if (userExit ==
                                                      Constant
                                                          .currentUserType) {
                                                    String token =
                                                    await NotificationService
                                                        .getToken();
                                                    DriverUserModel userModel =
                                                    DriverUserModel();

                                                    userModel.fcmToken = token;
                                                    await FireStoreUtils
                                                        .updateDriverUser(
                                                        userModel);
                                                    await FireStoreUtils
                                                        .getDriverProfile(
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .then(
                                                          (value) async {
                                                        if (value != null) {
                                                          DriverUserModel
                                                          userModel =
                                                              value;
                                                          bool isPlanExpire =
                                                          false;
                                                          if (userModel
                                                              .subscriptionPlan
                                                              ?.id !=
                                                              null) {
                                                            if (userModel
                                                                .subscriptionExpiryDate ==
                                                                null) {
                                                              if (userModel
                                                                  .subscriptionPlan
                                                                  ?.expiryDay ==
                                                                  '-1') {
                                                                isPlanExpire =
                                                                false;
                                                              } else {
                                                                isPlanExpire =
                                                                true;
                                                              }
                                                            } else {
                                                              DateTime
                                                              expiryDate =
                                                              userModel
                                                                  .subscriptionExpiryDate!
                                                                  .toDate();
                                                              isPlanExpire =
                                                                  expiryDate.isBefore(
                                                                      DateTime
                                                                          .now());
                                                            }
                                                          } else {
                                                            isPlanExpire = true;
                                                          }

                                                          if ((userModel.subscriptionPlanId ==
                                                              null ||
                                                              isPlanExpire ==
                                                                  true) &&
                                                              userModel.ownerId ==
                                                                  null) {
                                                            if (Constant.adminCommission
                                                                ?.isEnabled ==
                                                                false &&
                                                                Constant
                                                                    .isSubscriptionModelApplied ==
                                                                    false) {
                                                              ShowToastDialog
                                                                  .closeLoader();
                                                              Get.offAll(
                                                                  const DashBoardScreen());
                                                            } else {
                                                              ShowToastDialog
                                                                  .closeLoader();
                                                              Get.offAll(
                                                                  const SubscriptionListScreen(),
                                                                  arguments: {
                                                                    "isShow":
                                                                    true
                                                                  });
                                                            }
                                                          } else {
                                                            ShowToastDialog
                                                                .closeLoader();
                                                            if (userModel.ownerId !=
                                                                null &&
                                                                userModel.isEnabled ==
                                                                    false) {
                                                              await FirebaseAuth
                                                                  .instance
                                                                  .signOut();
                                                              ShowToastDialog
                                                                  .showToast(
                                                                  'This account has been disabled. Please reach out to the owner'
                                                                      .tr);
                                                            } else {
                                                              Get.offAll(
                                                                  const DashBoardScreen());
                                                            }
                                                          }
                                                        }
                                                      },
                                                    );
                                                  } else {
                                                    await FirebaseAuth.instance
                                                        .signOut();
                                                    ShowToastDialog.showToast(
                                                        'This account is already registered with a different role.'
                                                            .tr);
                                                  }
                                                });
                                              }
                                            }
                                          });
*/
                        },
                        child: Container(
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xffF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Image.asset('assets/icons/ic_google.png',
                                width: 24, height: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Facebook Config (dummy)
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xffF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(Icons.facebook,
                                color: const Color(0xff1877F2), size: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Apple Config
                      Visibility(
                        visible: Platform.isIOS,
                        child: InkWell(
                          onTap: () async {
                            ShowToastDialog.showLoader("Please wait".tr);
                            await controller.signInWithApple().then((value) {
                              ShowToastDialog.closeLoader();
                              if (value != null) {
                                Map<String, dynamic> map = value;
                                AuthorizationCredentialAppleID appleCredential =
                                    map['appleCredential'];
                                UserCredential userCredential =
                                    map['userCredential'];

                                if (userCredential
                                    .additionalUserInfo!.isNewUser) {
                                  log("----->new user");
                                  DriverUserModel userModel = DriverUserModel();
                                  userModel.id = userCredential.user!.uid;
                                  userModel.profilePic =
                                      userCredential.user!.photoURL;
                                  userModel.loginType = Constant.appleLoginType;
                                  userModel.email = userCredential
                                      .additionalUserInfo!.profile!['email'];
                                  userModel.fullName =
                                      "${appleCredential.givenName} ${appleCredential.familyName}";

                                  ShowToastDialog.closeLoader();
                                  Get.to(const InformationScreen(),
                                      arguments: {"userModel": userModel});
                                } else {
                                  log("----->old user");
                                  FireStoreUtils.userExitCustomerOrDriverRole(
                                          userCredential.user!.uid)
                                      .then((userExit) async {
                                    if (userExit == '') {
                                      DriverUserModel userModel =
                                          DriverUserModel();
                                      userModel.id = userCredential.user!.uid;
                                      userModel.profilePic =
                                          userCredential.user!.photoURL;
                                      userModel.loginType =
                                          Constant.appleLoginType;
                                      userModel.email = userCredential
                                          .additionalUserInfo!
                                          .profile!['email'];
                                      userModel.fullName =
                                          "${appleCredential.givenName} ${appleCredential.familyName}";

                                      ShowToastDialog.closeLoader();
                                      Get.to(const InformationScreen(),
                                          arguments: {"userModel": userModel});
                                    } else if (userExit ==
                                        Constant.currentUserType) {
                                      await FireStoreUtils.getDriverProfile(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .then(
                                        (value) async {
                                          Get.offAll(const DashBoardScreen());
                                        },
                                      );
                                    } else {
                                      await FirebaseAuth.instance.signOut();
                                      ShowToastDialog.showToast(
                                          'This account is already registered with a different role.'
                                              .tr);
                                    }
                                  });
                                }
                              }
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffF9FAFB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset('assets/icons/ic_apple.png',
                                  width: 24, height: 24, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/*import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/login_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/ui/auth_screen/information_screen.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png", width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Login".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text("Welcome Back! We are happy to have \n you back".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            validator: (value) => value != null && value.isNotEmpty ? null : 'Required'.tr,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.phoneNumberController.value,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(color: themeChange.getThem() ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                prefixIcon: CountryCodePicker(
                                  onChanged: (value) {
                                    controller.countryCode.value = value.dialCode.toString();
                                  },
                                  dialogBackgroundColor: themeChange.getThem() ? AppColors.darkBackground : AppColors.background,
                                  initialSelection: controller.countryCode.value,
                                  comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                                  flagDecoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(2)),
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                                ),
                                hintText: "Phone number".tr)),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Next".tr,
                          onPress: () {
                            controller.sendCode();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Divider(
                                height: 1,
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "OR".tr,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Expanded(
                                  child: Divider(
                                height: 1,
                              )),
                            ],
                          ),
                        ),
                        ButtonThem.buildBorderButton(
                          context,
                          title: "Login with google".tr,
                          iconVisibility: true,
                          iconAssetImage: 'assets/icons/ic_google.png',
                          onPress: () async {
                            ShowToastDialog.showLoader("Please wait".tr);
                            await controller.signInWithGoogle().then((value) async {
                              ShowToastDialog.closeLoader();
                              if (value != null) {
                                if (value.additionalUserInfo!.isNewUser) {
                                  log("----->new user");
                                  DriverUserModel userModel = DriverUserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.email = value.user!.email;
                                  userModel.fullName = value.user!.displayName;
                                  userModel.profilePic = value.user!.photoURL;
                                  userModel.loginType = Constant.googleLoginType;

                                  ShowToastDialog.closeLoader();
                                  Get.to(const InformationScreen(), arguments: {
                                    "userModel": userModel,
                                  });
                                } else {
                                  log("----->old user");
                                  await FireStoreUtils.userExitCustomerOrDriverRole(value.user!.uid).then((userExit) async {
                                    if (userExit == '') {
                                      DriverUserModel userModel = DriverUserModel();
                                      userModel.id = value.user!.uid;
                                      userModel.email = value.user!.email;
                                      userModel.fullName = value.user!.displayName;
                                      userModel.profilePic = value.user!.photoURL;
                                      userModel.loginType = Constant.googleLoginType;

                                      ShowToastDialog.closeLoader();
                                      Get.to(const InformationScreen(), arguments: {
                                        "userModel": userModel,
                                      });
                                    } else if (userExit == Constant.currentUserType) {
                                      String token = await NotificationService.getToken();
                                      DriverUserModel userModel = DriverUserModel();

                                      userModel.fcmToken = token;
                                      await FireStoreUtils.updateDriverUser(userModel);
                                      await FireStoreUtils.getDriverProfile(FirebaseAuth.instance.currentUser!.uid).then(
                                        (value) async {
                                          if (value != null) {
                                            DriverUserModel userModel = value;
                                            bool isPlanExpire = false;
                                            if (userModel.subscriptionPlan?.id != null) {
                                              if (userModel.subscriptionExpiryDate == null) {
                                                if (userModel.subscriptionPlan?.expiryDay == '-1') {
                                                  isPlanExpire = false;
                                                } else {
                                                  isPlanExpire = true;
                                                }
                                              } else {
                                                DateTime expiryDate = userModel.subscriptionExpiryDate!.toDate();
                                                isPlanExpire = expiryDate.isBefore(DateTime.now());
                                              }
                                            } else {
                                              isPlanExpire = true;
                                            }

                                            if ((userModel.subscriptionPlanId == null || isPlanExpire == true) && userModel.ownerId == null) {
                                              if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                                                ShowToastDialog.closeLoader();
                                                Get.offAll(const DashBoardScreen());
                                              } else {
                                                ShowToastDialog.closeLoader();
                                                Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                              }
                                            } else {
                                              ShowToastDialog.closeLoader();
                                              if (userModel.ownerId != null && userModel.isEnabled == false) {
                                                await FirebaseAuth.instance.signOut();
                                                ShowToastDialog.showToast('This account has been disabled. Please reach out to the owner'.tr);
                                              } else {
                                                Get.offAll(const DashBoardScreen());
                                              }
                                            }
                                          }
                                        },
                                      );
                                    } else {
                                      await FirebaseAuth.instance.signOut();
                                      ShowToastDialog.showToast('This account is already registered with a different role.'.tr);
                                    }
                                  });
                                }
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Visibility(
                            visible: Platform.isIOS,
                            child: ButtonThem.buildBorderButton(
                              context,
                              title: "Login with apple".tr,
                              iconVisibility: true,
                              iconAssetImage: 'assets/icons/ic_apple.png',
                              iconColor: themeChange.getThem() ? AppColors.darksecondprimary : AppColors.lightsecondprimary,
                              onPress: () async {
                                ShowToastDialog.showLoader("Please wait".tr);
                                await controller.signInWithApple().then((value) {
                                  ShowToastDialog.closeLoader();
                                  if (value != null) {
                                    Map<String, dynamic> map = value;
                                    AuthorizationCredentialAppleID appleCredential = map['appleCredential'];
                                    UserCredential userCredential = map['userCredential'];

                                    if (userCredential.additionalUserInfo!.isNewUser) {
                                      log("----->new user");
                                      DriverUserModel userModel = DriverUserModel();
                                      userModel.id = userCredential.user!.uid;
                                      userModel.profilePic = userCredential.user!.photoURL;
                                      userModel.loginType = Constant.appleLoginType;
                                      userModel.email = userCredential.additionalUserInfo!.profile!['email'];
                                      userModel.fullName = "${appleCredential.givenName} ${appleCredential.familyName}";

                                      ShowToastDialog.closeLoader();
                                      Get.to(const InformationScreen(), arguments: {
                                        "userModel": userModel,
                                      });
                                    } else {
                                      log("----->old user");
                                      FireStoreUtils.userExitCustomerOrDriverRole(userCredential.user!.uid).then((userExit) async {
                                        if (userExit == '') {
                                          DriverUserModel userModel = DriverUserModel();
                                          userModel.id = userCredential.user!.uid;
                                          userModel.profilePic = userCredential.user!.photoURL;
                                          userModel.loginType = Constant.appleLoginType;
                                          userModel.email = userCredential.additionalUserInfo!.profile!['email'];
                                          userModel.fullName = "${appleCredential.givenName} ${appleCredential.familyName}";

                                          ShowToastDialog.closeLoader();
                                          Get.to(const InformationScreen(), arguments: {
                                            "userModel": userModel,
                                          });
                                        } else if (userExit == Constant.currentUserType) {
                                          await FireStoreUtils.getDriverProfile(FirebaseAuth.instance.currentUser!.uid).then(
                                            (value) async {
                                              if (value != null) {
                                                DriverUserModel userModel = value;
                                                bool isPlanExpire = false;
                                                if (userModel.subscriptionPlan?.id != null) {
                                                  if (userModel.subscriptionExpiryDate == null) {
                                                    if (userModel.subscriptionPlan?.expiryDay == '-1') {
                                                      isPlanExpire = false;
                                                    } else {
                                                      isPlanExpire = true;
                                                    }
                                                  } else {
                                                    DateTime expiryDate = userModel.subscriptionExpiryDate!.toDate();
                                                    isPlanExpire = expiryDate.isBefore(DateTime.now());
                                                  }
                                                } else {
                                                  isPlanExpire = true;
                                                }
                                                if ((userModel.subscriptionPlanId == null || isPlanExpire == true) && userModel.ownerId == null) {
                                                  if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                                                    ShowToastDialog.closeLoader();
                                                    Get.offAll(const DashBoardScreen());
                                                  } else {
                                                    ShowToastDialog.closeLoader();
                                                    Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                                  }
                                                } else {
                                                  ShowToastDialog.closeLoader();
                                                  if (userModel.ownerId != null && userModel.isEnabled == false) {
                                                    await FirebaseAuth.instance.signOut();
                                                    ShowToastDialog.showToast('This account has been disabled. Please reach out to the owner'.tr);
                                                  } else {
                                                    Get.offAll(const DashBoardScreen());
                                                  }
                                                }
                                              }
                                            },
                                          );
                                        } else {
                                          await FirebaseAuth.instance.signOut();
                                          ShowToastDialog.showToast('This account is already registered with a different role.'.tr);
                                        }
                                      });
                                    }
                                  }
                                });
                              },
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'By tapping "Next" you agree to '.tr,
                    style: GoogleFonts.poppins(),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "terms",
                              ));
                            },
                          text: 'Terms and conditions'.tr,
                          style: GoogleFonts.poppins(decoration: TextDecoration.underline)),
                      TextSpan(text: ' and ', style: GoogleFonts.poppins()),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "privacy",
                              ));
                            },
                          text: 'privacy policy'.tr,
                          style: GoogleFonts.poppins(decoration: TextDecoration.underline)),
                      // can add more TextSpans here...
                    ],
                  ),
                )),
          );
        });
  }
}*/
