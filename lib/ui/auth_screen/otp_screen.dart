import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/otp_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/ui/auth_screen/information_screen.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../themes/responsive.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDark = themeChange.getThem();

    return GetX<OtpController>(
      init: OtpController(), // ✅ keep exactly like your old working code
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xff0C1A30), size: 20),
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
                    "assets/images/otp_image.png",
                    height: 200,
                  ),
                  const SizedBox(height: 24),
                  // Headers
                  Text(
                    "Check Your SMS".tr,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${"We sent a 6-digit code to".tr}\n${controller.countryCode.value + controller.phoneNumber.value}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xff838EA1),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 38),

                  // Enter OTP text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff0C1A30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // PinCode Box
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const int len = 6;
                      const double gap = 10;
                      final w = constraints.maxWidth;
                      double fieldW = (w - (gap * (len - 1))) / len;
                      fieldW = fieldW.clamp(40.0, 54.0);

                      return PinCodeTextField(
                        length: len,
                        appContext: context,
                        keyboardType: TextInputType.phone,
                        autoDisposeControllers: false,
                        controller: controller.otpController.value,
                        enableActiveFill: true,
                        cursorColor: const Color(0xff0C1A30),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        separatorBuilder: (_, __) => const SizedBox(width: gap),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff0C1A30),
                        ),
                        pinTheme: PinTheme(
                          fieldHeight: fieldW,
                          fieldWidth: fieldW,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          activeColor: const Color(
                              0xff000000),
                          selectedColor: const Color(0xff0C1A30),
                          inactiveColor: const Color(0xffE2E5EA),
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                        ),
                        onCompleted: (v) async {},
                        onChanged: (value) {},
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.otpController.value.text.length == 6) {
                          ShowToastDialog.showLoader("Verify OTP".tr);

                          PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: controller.verificationId.value,
                            smsCode: controller.otpController.value.text,
                          );

                          await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) async {
                            if (value.additionalUserInfo!.isNewUser) {
                              log("----->new user");
                              DriverUserModel userModel = DriverUserModel();
                              userModel.id = value.user!.uid;
                              userModel.countryCode = controller.countryCode.value;
                              userModel.phoneNumber = controller.phoneNumber.value;
                              userModel.loginType = Constant.phoneLoginType;

                              ShowToastDialog.closeLoader();
                              Get.off(const InformationScreen(), arguments: {
                                "userModel": userModel,
                              });
                            } else {
                              log("----->old user");
                              await FireStoreUtils.userExitCustomerOrDriverRole(value.user!.uid)
                                  .then((userExit) async {
                                ShowToastDialog.closeLoader();
                                if (userExit == '') {
                                  DriverUserModel userModel = DriverUserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.countryCode = controller.countryCode.value;
                                  userModel.phoneNumber = controller.phoneNumber.value;
                                  userModel.loginType = Constant.phoneLoginType;

                                  ShowToastDialog.closeLoader();
                                  Get.off(const InformationScreen(), arguments: {
                                    "userModel": userModel,
                                  });
                                } else if (userExit == Constant.currentUserType) {
                                  await FireStoreUtils.getDriverProfile(value.user!.uid).then(
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
                                            DateTime expiryDate =
                                            userModel.subscriptionExpiryDate!.toDate();
                                            isPlanExpire =
                                                expiryDate.isBefore(DateTime.now());
                                          }
                                        } else {
                                          isPlanExpire = true;
                                        }

                                        if ((userModel.subscriptionPlanId == null ||
                                            isPlanExpire == true) &&
                                            userModel.ownerId == null) {
                                          if (Constant.adminCommission?.isEnabled == false &&
                                              Constant.isSubscriptionModelApplied == false) {
                                            Get.offAll(const DashBoardScreen());
                                          } else {
                                            Get.offAll(const SubscriptionListScreen(),
                                                arguments: {"isShow": true});
                                          }
                                        } else {
                                          if (userModel.ownerId != null &&
                                              userModel.isEnabled == false) {
                                            await FirebaseAuth.instance.signOut();
                                            Get.back();
                                            ShowToastDialog.showToast(
                                                'This account has been disabled. Please reach out to the owner'
                                                    .tr);
                                          } else {
                                            Get.offAll(const DashBoardScreen());
                                          }
                                        }
                                      }
                                    },
                                  );
                                } else {
                                  await FirebaseAuth.instance.signOut();
                                  ShowToastDialog.showToast(
                                      'This mobile number is already registered with a different role.'
                                          .tr);
                                }
                              });
                            }
                          }).catchError((error) {
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("Code is Invalid".tr);
                          });
                        } else {
                          ShowToastDialog.showToast("Please Enter Valid OTP".tr);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff12223b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Verifier".tr,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



/*

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<DarkThemeProvider>(context);

    // ✅ Create once (if already created, Get.put returns same instance)
    final OtpController otpCtrl = Get.put(OtpController());

    return GetX<OtpController>(
      // ✅ IMPORTANT: no init here
      builder: (controller) {
        //final isDark = themeChange.getThem();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.qlypDeepPurple.withOpacity(0.98),
                AppColors.qlypDark,
                AppColors.qlypDark.withOpacity(0.95),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,

            body: Stack(
              children: [
                // Background blobs
                Positioned(
                  top: -100,
                  right: -50,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.qlypMutedRose.withOpacity(0.25),
                          AppColors.qlypMutedRose.withOpacity(0.10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -50,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.qlypPrimaryLight.withOpacity(0.15),
                          AppColors.qlypPrimaryLight.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // particles
                Positioned(
                  top: 160,
                  left: 30,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.qlypSecondaryLight.withOpacity(0.40),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  right: 40,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.qlypPrimary.withOpacity(0.30),
                    ),
                  ),
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.vertical,
                      ),
                      child: Column(
                        children: [
                          // ================= HERO =================
                          SizedBox(
                            height: Responsive.width(65, context),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    "assets/images/login_image.png",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),

                                // Overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        AppColors.qlypDark.withOpacity(0.95),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                // Logo + Title
                                Positioned(
                                  left: 24,
                                  bottom: 24,
                                  right: 24,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/app_logo.png",
                                        width: 70,
                                        height: 70,
                                        color: AppColors.qlypPrimaryLight,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Verify Phone Number".tr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.qlypPrimaryLight,
                                          letterSpacing: -0.5,
                                          shadows: [
                                            Shadow(
                                              color:
                                              Colors.black.withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${"We just send a verification code to".tr}\n${(controller.countryCode.value + controller.phoneNumber.value)}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.qlypPrimaryLight
                                              .withOpacity(0.75),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 50),

                          // ================= OTP CARD =================
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: AppColors.qlypDark.withOpacity(0.40),
                                border: Border.all(
                                  color: AppColors.qlypPrimaryLight
                                      .withOpacity(0.08),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.30),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                  BoxShadow(
                                    color: AppColors.qlypPrimaryLight
                                        .withOpacity(0.05),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Enter OTP".tr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.qlypPrimaryLight
                                              .withOpacity(0.9),
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 18),

                                      // OTP boxes
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          const int len = 6;
                                          const double gap = 10; // spacing between boxes

                                          // available width inside the card
                                          final double w = constraints.maxWidth;

                                          // compute box width so it never overflows
                                          double fieldW = (w - (gap * (len - 1))) / len;

                                          // clamp to nice min/max sizes
                                          fieldW = fieldW.clamp(42.0, 54.0);

                                          return PinCodeTextField(
                                            appContext: context,
                                            length: len,
                                            controller: controller.otpController.value,
                                            keyboardType: TextInputType.number,
                                            cursorColor: AppColors.qlypSecondaryLight,
                                            enableActiveFill: true,

                                            // ✅ prevents plugin disposing issues
                                            autoDisposeControllers: false,

                                            // ✅ makes spacing predictable (no overflow)
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            separatorBuilder: (_, __) => const SizedBox(width: gap),

                                            textStyle: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.qlypPrimaryLight,
                                            ),

                                            pinTheme: PinTheme(
                                              fieldHeight: fieldW, // keep square
                                              fieldWidth: fieldW,
                                              shape: PinCodeFieldShape.box,
                                              borderRadius: BorderRadius.circular(14),

                                              activeColor: AppColors.qlypPrimaryLight.withOpacity(0.18),
                                              selectedColor: AppColors.qlypSecondaryLight.withOpacity(0.80),
                                              inactiveColor: AppColors.qlypPrimaryLight.withOpacity(0.10),

                                              activeFillColor: AppColors.qlypDark.withOpacity(0.65),
                                              selectedFillColor: AppColors.qlypDark.withOpacity(0.70),
                                              inactiveFillColor: AppColors.qlypDark.withOpacity(0.55),
                                            ),

                                            onCompleted: (v) async {},
                                            onChanged: (value) {},
                                          );
                                        },
                                      ),


                                      */
/* PinCodeTextField(
                                        length: 6,
                                        appContext: context,
                                        keyboardType: TextInputType.phone,
                                        enableActiveFill: true,
                                        controller: controller.otpController.value,
                                        cursorColor: AppColors.qlypSecondaryLight,
                                        textStyle: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.qlypPrimaryLight,
                                        ),
                                        pinTheme: PinTheme(
                                          fieldHeight: 52,
                                          fieldWidth: 52,
                                          shape: PinCodeFieldShape.box,
                                          borderRadius: BorderRadius.circular(14),

                                          activeColor: AppColors.qlypPrimaryLight.withOpacity(0.18),
                                          selectedColor: AppColors.qlypSecondaryLight.withOpacity(0.80),
                                          inactiveColor: AppColors.qlypPrimaryLight.withOpacity(0.10),

                                          activeFillColor: AppColors.qlypDark.withOpacity(0.65),
                                          selectedFillColor: AppColors.qlypDark.withOpacity(0.70),
                                          inactiveFillColor: AppColors.qlypDark.withOpacity(0.55),
                                        ),
                                        onCompleted: (v) async {},
                                        onChanged: (value) {},
                                      ),*//*


                                      const SizedBox(height: 26),

                                      // Verify button (SAME LOGIC as your code)
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: Material(
                                          borderRadius: BorderRadius.circular(18),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(18),
                                            onTap: () async {
                                              // --------- NO FUNCTIONAL CHANGES BELOW ----------
                                              if (controller.otpController.value.text.length == 6) {
                                                ShowToastDialog.showLoader("Verify OTP".tr);

                                                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                                  verificationId: controller.verificationId.value,
                                                  smsCode: controller.otpController.value.text,
                                                );

                                                await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                                  if (value.additionalUserInfo!.isNewUser) {
                                                    log("----->new user");
                                                    DriverUserModel userModel = DriverUserModel();
                                                    userModel.id = value.user!.uid;
                                                    userModel.countryCode = controller.countryCode.value;
                                                    userModel.phoneNumber = controller.phoneNumber.value;
                                                    userModel.loginType = Constant.phoneLoginType;

                                                    ShowToastDialog.closeLoader();
                                                    Get.off(const InformationScreen(), arguments: {
                                                      "userModel": userModel,
                                                    });
                                                  } else {
                                                    log("----->old user");
                                                    await FireStoreUtils.userExitCustomerOrDriverRole(value.user!.uid).then((userExit) async {
                                                      ShowToastDialog.closeLoader();
                                                      if (userExit == '') {
                                                        DriverUserModel userModel = DriverUserModel();
                                                        userModel.id = value.user!.uid;
                                                        userModel.countryCode = controller.countryCode.value;
                                                        userModel.phoneNumber = controller.phoneNumber.value;
                                                        userModel.loginType = Constant.phoneLoginType;

                                                        ShowToastDialog.closeLoader();
                                                        Get.off(const InformationScreen(), arguments: {
                                                          "userModel": userModel,
                                                        });
                                                      } else if (userExit == Constant.currentUserType) {
                                                        await FireStoreUtils.getDriverProfile(value.user!.uid).then(
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
                                                                  Get.offAll(const DashBoardScreen());
                                                                } else {
                                                                  Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                                                }
                                                              } else {
                                                                if (userModel.ownerId != null && userModel.isEnabled == false) {
                                                                  await FirebaseAuth.instance.signOut();
                                                                  Get.back();
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
                                                        ShowToastDialog.showToast('This mobile number is already registered with a different role.'.tr);
                                                      }
                                                    });
                                                  }
                                                }).catchError((error) {
                                                  ShowToastDialog.closeLoader();
                                                  ShowToastDialog.showToast("Code is Invalid".tr);
                                                });
                                              } else {
                                                ShowToastDialog.showToast("Please Enter Valid OTP".tr);
                                              }
                                              // ------------------------------------------------
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(18),
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    AppColors.qlypSecondaryLight,
                                                    AppColors.qlypPrimary,
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.qlypPrimary.withOpacity(0.40),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                  BoxShadow(
                                                    color: AppColors.qlypSecondaryLight.withOpacity(0.30),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Verify".tr,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w700,
                                                        color: AppColors.qlypDark,
                                                        letterSpacing: -0.2,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Icon(
                                                      Icons.verified_rounded,
                                                      color: AppColors.qlypDark,
                                                      size: 22,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/



/*
import 'dart:developer';

import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/otp_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/ui/auth_screen/information_screen.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../themes/responsive.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<OtpController>(
        init: OtpController(),
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
                          child: Text("Verify Phone Number".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text("${"We just send a verification code to".tr} \n${controller.countryCode.value + controller.phoneNumber.value}".tr, style: GoogleFonts.poppins()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: PinCodeTextField(
                            length: 6,
                            appContext: context,
                            keyboardType: TextInputType.phone,
                            pinTheme: PinTheme(
                              fieldHeight: 50,
                              fieldWidth: 50,
                              activeColor: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder,
                              selectedColor: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder,
                              inactiveColor: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder,
                              activeFillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                              inactiveFillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                              selectedFillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enableActiveFill: true,
                            cursorColor: AppColors.lightprimary,
                            controller: controller.otpController.value,
                            onCompleted: (v) async {},
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Verify".tr,
                          onPress: () async {
                            if (controller.otpController.value.text.length == 6) {
                              ShowToastDialog.showLoader("Verify OTP".tr);

                              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.value, smsCode: controller.otpController.value.text);
                              await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                if (value.additionalUserInfo!.isNewUser) {
                                  log("----->new user");
                                  DriverUserModel userModel = DriverUserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.countryCode = controller.countryCode.value;
                                  userModel.phoneNumber = controller.phoneNumber.value;
                                  userModel.loginType = Constant.phoneLoginType;

                                  ShowToastDialog.closeLoader();
                                  Get.off(const InformationScreen(), arguments: {
                                    "userModel": userModel,
                                  });
                                } else {
                                  log("----->old user");
                                  await FireStoreUtils.userExitCustomerOrDriverRole(value.user!.uid).then((userExit) async {
                                    ShowToastDialog.closeLoader();
                                    if (userExit == '') {
                                      DriverUserModel userModel = DriverUserModel();
                                      userModel.id = value.user!.uid;
                                      userModel.countryCode = controller.countryCode.value;
                                      userModel.phoneNumber = controller.phoneNumber.value;
                                      userModel.loginType = Constant.phoneLoginType;

                                      ShowToastDialog.closeLoader();
                                      Get.off(const InformationScreen(), arguments: {
                                        "userModel": userModel,
                                      });
                                    } else if (userExit == Constant.currentUserType) {
                                      await FireStoreUtils.getDriverProfile(value.user!.uid).then(
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
                                                Get.offAll(const DashBoardScreen());
                                              } else {
                                                Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                              }
                                            } else {
                                              if (userModel.ownerId != null && userModel.isEnabled == false) {
                                                await FirebaseAuth.instance.signOut();
                                                Get.back();
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
                                      ShowToastDialog.showToast('This mobile number is already registered with a different role.'.tr);
                                    }
                                  });
                                }
                              }).catchError((error) {
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast("Code is Invalid".tr);
                              });
                            } else {
                              ShowToastDialog.showToast("Please Enter Valid OTP".tr);
                            }

                            // print(controller.countryCode.value);
                            // print(controller.phoneNumberController.value.text);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
*/