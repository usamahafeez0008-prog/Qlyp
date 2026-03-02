import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/information_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/referral_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/text_field_them.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../themes/responsive.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<InformationController>(
      init: InformationController(),
      builder: (controller) {
        final isDark = themeChange.getThem();

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

                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              Positioned(
                                left: 24,
                                right: 24,
                                bottom: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/app_logo.png",
                                      width: 64,
                                      height: 64,
                                      color: AppColors.qlypPrimaryLight,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      "Sign up".tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.qlypPrimaryLight,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Create your account to start using GoRide".tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.qlypPrimaryLight.withOpacity(0.75),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        // ================= FORM CARD =================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: AppColors.qlypDark.withOpacity(0.40),
                              border: Border.all(
                                color: AppColors.qlypPrimaryLight.withOpacity(0.08),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.30),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                ),
                                BoxShadow(
                                  color: AppColors.qlypPrimaryLight.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Full name (kept your custom TextFieldThem to avoid breaking)
                                    _glassTextField(
                                      context: context,
                                      hint: 'Full name'.tr,
                                      controller: controller.fullNameController.value,
                                    ),
                                    const SizedBox(height: 12),

                                    // Phone (same enable/disable logic)
                                    // Phone (same enable/disable logic, new UI)
                                    Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: AppColors.qlypDark.withOpacity(0.55),
                                        border: Border.all(
                                          color: AppColors.qlypPrimaryLight.withOpacity(0.12),
                                          width: 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.18),
                                            blurRadius: 18,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        validator: (value) =>
                                        value != null && value.isNotEmpty ? null : 'Required'.tr,
                                        keyboardType: TextInputType.number,
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: controller.phoneNumberController.value,
                                        textAlign: TextAlign.start,
                                        enabled: controller.loginType.value == Constant.phoneLoginType
                                            ? false
                                            : true,
                                        cursorColor: AppColors.qlypSecondaryLight,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.qlypPrimaryLight.withOpacity(0.92),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                                          prefixIcon: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 14),
                                            decoration: BoxDecoration(
                                              color: AppColors.qlypDark.withOpacity(0.75),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(18),
                                                bottomLeft: Radius.circular(18),
                                              ),
                                            ),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: Theme.of(context).colorScheme.copyWith(
                                                  primary: AppColors.qlypSecondaryLight,
                                                  secondary: AppColors.qlypSecondaryLight,
                                                ),
                                                textSelectionTheme: TextSelectionThemeData(
                                                  cursorColor: AppColors.qlypSecondaryLight,
                                                  selectionColor:
                                                  AppColors.qlypSecondaryLight.withOpacity(0.25),
                                                  selectionHandleColor: AppColors.qlypSecondaryLight,
                                                ),
                                              ),
                                              child: CountryCodePicker(
                                                onChanged: (value) {
                                                  controller.countryCode.value =
                                                      value.dialCode.toString();
                                                },
                                                dialogBackgroundColor:
                                                isDark ? AppColors.qlypDark : AppColors.qlypPrimaryLight,
                                                initialSelection: controller.countryCode.value,
                                                comparator: (a, b) =>
                                                    b.name!.compareTo(a.name.toString()),
                                                flagDecoration:
                                                BoxDecoration(borderRadius: BorderRadius.circular(4)),
                                                padding: EdgeInsets.zero,
                                                textStyle: GoogleFonts.poppins(
                                                  color:
                                                  AppColors.qlypPrimaryLight.withOpacity(0.9),
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                searchDecoration: InputDecoration(
                                                  hintText: "Search country".tr,
                                                  hintStyle: GoogleFonts.poppins(
                                                    color:
                                                    AppColors.qlypPrimaryLight.withOpacity(0.5),
                                                  ),
                                                  prefixIcon: Icon(Icons.search,
                                                      color: AppColors.qlypSecondaryLight),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.qlypSecondaryLight
                                                          .withOpacity(0.45),
                                                    ),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.qlypSecondaryLight,
                                                      width: 1.6,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          hintText: "Phone number".tr,
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.qlypPrimaryLight.withOpacity(0.38),
                                          ),
                                        ),
                                      ),
                                    ),


                                    const SizedBox(height: 12),

                                    // Email (kept TextFieldThem)
                                    _glassTextField(
                                      context: context,
                                      hint: 'Email'.tr,
                                      controller: controller.emailController.value,
                                      enabled: controller.loginType.value == Constant.googleLoginType ? false : true,
                                      keyboardType: TextInputType.emailAddress,
                                    ),

                                    const SizedBox(height: 12),

                                    // Referral

                                    _glassTextField(
                                      context: context,
                                      hint: 'Referral Code (Optional)'.tr,
                                      controller: controller.referralCodeController.value,
                                    ),

                                    const SizedBox(height: 22),

                                    // Gradient button like "Verify & Continue" style
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(18),
                                          onTap: () async {
                                            // ✅ ORIGINAL LOGIC (UNCHANGED)
                                            if (controller.fullNameController.value.text.isEmpty) {
                                              ShowToastDialog.showToast("Please enter full name".tr);
                                            } else if (controller.emailController.value.text.isEmpty) {
                                              ShowToastDialog.showToast("Please enter email".tr);
                                            } else if (controller.phoneNumberController.value.text.isEmpty) {
                                              ShowToastDialog.showToast("Please enter phone number".tr);
                                            } else if (Constant.validateEmail(controller.emailController.value.text) == false) {
                                              ShowToastDialog.showToast("Please enter valid email".tr);
                                            } else {
                                              if (controller.referralCodeController.value.text.isNotEmpty) {
                                                FireStoreUtils.checkReferralCodeValidOrNot(controller.referralCodeController.value.text).then((value) async {
                                                  if (value == true) {
                                                    ShowToastDialog.showLoader("Please wait".tr);
                                                    DriverUserModel userModel = controller.userModel.value;
                                                    userModel.fullName = controller.fullNameController.value.text;
                                                    userModel.email = controller.emailController.value.text;
                                                    userModel.countryCode = controller.countryCode.value;
                                                    userModel.phoneNumber = controller.phoneNumberController.value.text;
                                                    userModel.documentVerification = false;
                                                    userModel.isOnline = false;
                                                    userModel.isEnabled = true;
                                                    userModel.createdAt = Timestamp.now();
                                                    String token = await NotificationService.getToken();
                                                    userModel.fcmToken = token;

                                                    await FireStoreUtils.getReferralUserByCode(controller.referralCodeController.value.text).then((value) async {
                                                      if (value != null) {
                                                        ReferralModel ownReferralModel = ReferralModel(
                                                          id: FireStoreUtils.getCurrentUid(),
                                                          referralBy: value.id,
                                                          referralCode: Constant.getReferralCode(),
                                                        );
                                                        await FireStoreUtils.referralAdd(ownReferralModel);
                                                      } else {
                                                        ReferralModel referralModel = ReferralModel(
                                                          id: FireStoreUtils.getCurrentUid(),
                                                          referralBy: "",
                                                          referralCode: Constant.getReferralCode(),
                                                        );
                                                        await FireStoreUtils.referralAdd(referralModel);
                                                      }
                                                    });

                                                    await FireStoreUtils.updateDriverUser(userModel).then((value) {
                                                      ShowToastDialog.closeLoader();
                                                      Get.offAll(const DashBoardScreen());

                                                      /*if (value == true) {
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

                                                        if (userModel.subscriptionPlanId == null || isPlanExpire == true) {
                                                          if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                                                            Get.offAll(const DashBoardScreen());
                                                          } else {
                                                            Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                                          }
                                                        } else {
                                                          Get.offAll(const DashBoardScreen());
                                                        }
                                                      }*/

                                                    });
                                                  } else {
                                                    ShowToastDialog.showToast("Referral code Invalid".tr);
                                                  }
                                                });
                                              } else {
                                                ShowToastDialog.showLoader("Please wait".tr);
                                                DriverUserModel userModel = controller.userModel.value;
                                                userModel.fullName = controller.fullNameController.value.text;
                                                userModel.email = controller.emailController.value.text;
                                                userModel.countryCode = controller.countryCode.value;
                                                userModel.phoneNumber = controller.phoneNumberController.value.text;
                                                userModel.documentVerification = false;
                                                userModel.isOnline = false;
                                                userModel.isEnabled = true;
                                                userModel.createdAt = Timestamp.now();
                                                String token = await NotificationService.getToken();
                                                userModel.fcmToken = token;

                                                ReferralModel referralModel = ReferralModel(
                                                  id: FireStoreUtils.getCurrentUid(),
                                                  referralBy: "",
                                                  referralCode: Constant.getReferralCode(),
                                                );
                                                await FireStoreUtils.referralAdd(referralModel);

                                                await FireStoreUtils.updateDriverUser(userModel).then((value) {
                                                  ShowToastDialog.closeLoader();
                                                  Get.offAll(const DashBoardScreen());
                                                 /* if (value == true) {
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

                                                    if (userModel.subscriptionPlanId == null || isPlanExpire == true) {
                                                      if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                                                        Get.offAll(const DashBoardScreen());
                                                      } else {
                                                        Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                                      }
                                                    } else {
                                                      Get.offAll(const DashBoardScreen());
                                                    }
                                                  }*/
                                                });
                                              }
                                            }
                                          },
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
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
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Create account".tr,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.qlypDark,
                                                  letterSpacing: 0.2,
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
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
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


  Widget _glassTextField({
    required BuildContext context,
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.qlypDark.withOpacity(0.55),
        border: Border.all(
          color: AppColors.qlypPrimaryLight.withOpacity(0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        cursorColor: AppColors.qlypSecondaryLight,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.qlypPrimaryLight.withOpacity(0.92),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: AppColors.qlypPrimaryLight.withOpacity(0.38),
          ),
        ),
      ),
    );
  }

  Widget _glassPhoneField({
    required BuildContext context,
    required bool isDark,
    required InformationController controller,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.qlypDark.withOpacity(0.55),
        border: Border.all(
          color: AppColors.qlypPrimaryLight.withOpacity(0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Country picker area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.qlypDark.withOpacity(0.75),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.qlypSecondaryLight,
                  secondary: AppColors.qlypSecondaryLight,
                ),
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: AppColors.qlypSecondaryLight,
                  selectionColor: AppColors.qlypSecondaryLight.withOpacity(0.25),
                  selectionHandleColor: AppColors.qlypSecondaryLight,
                ),
              ),
              child: CountryCodePicker(
                onChanged: (value) {
                  controller.countryCode.value = value.dialCode.toString();
                },
                dialogBackgroundColor: isDark ? AppColors.qlypDark : AppColors.qlypPrimaryLight,
                initialSelection: controller.countryCode.value,
                comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                flagDecoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.zero,
                textStyle: GoogleFonts.poppins(
                  color: AppColors.qlypPrimaryLight.withOpacity(0.9),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                searchDecoration: InputDecoration(
                  hintText: "Search country".tr,
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.qlypPrimaryLight.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.qlypSecondaryLight),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.qlypSecondaryLight.withOpacity(0.45)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.qlypSecondaryLight, width: 1.6),
                  ),
                ),
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 22,
            color: AppColors.qlypPrimaryLight.withOpacity(0.14),
          ),

          // Phone input
          Expanded(
            child: TextFormField(
              validator: (value) => value != null && value.isNotEmpty ? null : 'Required'.tr,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              controller: controller.phoneNumberController.value,
              textAlign: TextAlign.start,
              enabled: controller.loginType.value == Constant.phoneLoginType ? false : true,
              cursorColor: AppColors.qlypSecondaryLight,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.qlypPrimaryLight.withOpacity(0.92),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: "Phone number".tr,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.qlypPrimaryLight.withOpacity(0.38),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}



/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/information_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/referral_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/text_field_them.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../themes/responsive.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<InformationController>(
        init: InformationController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png", width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Sign up".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text("Create your account to start using GoRide".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldThem.buildTextFiled(context, hintText: 'Full name'.tr, controller: controller.fullNameController.value),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            validator: (value) => value != null && value.isNotEmpty ? null : 'Required'.tr,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.phoneNumberController.value,
                            textAlign: TextAlign.start,
                            enabled: controller.loginType.value == Constant.phoneLoginType ? false : true,
                            style: GoogleFonts.poppins(
                              color: themeChange.getThem() ? AppColors.textField : AppColors.darkTextField,
                            ),
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
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(context,
                            hintText: 'Email'.tr, controller: controller.emailController.value, enable: controller.loginType.value == Constant.googleLoginType ? false : true),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldThem.buildTextFiled(
                          context,
                          hintText: 'Referral Code (Optional)'.tr,
                          controller: controller.referralCodeController.value,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ButtonThem.buildButton(context, title: "Create account".tr, onPress: () async {
                          if (controller.fullNameController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter full name".tr);
                          } else if (controller.emailController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter email".tr);
                          } else if (controller.phoneNumberController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter phone number".tr);
                          } else if (Constant.validateEmail(controller.emailController.value.text) == false) {
                            ShowToastDialog.showToast("Please enter valid email".tr);
                          } else {
                            if (controller.referralCodeController.value.text.isNotEmpty) {
                              FireStoreUtils.checkReferralCodeValidOrNot(controller.referralCodeController.value.text).then((value) async {
                                if (value == true) {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  DriverUserModel userModel = controller.userModel.value;
                                  userModel.fullName = controller.fullNameController.value.text;
                                  userModel.email = controller.emailController.value.text;
                                  userModel.countryCode = controller.countryCode.value;
                                  userModel.phoneNumber = controller.phoneNumberController.value.text;
                                  userModel.documentVerification = false;
                                  userModel.isOnline = false;
                                  userModel.isEnabled = true;
                                  userModel.createdAt = Timestamp.now();
                                  String token = await NotificationService.getToken();
                                  userModel.fcmToken = token;
                                  await FireStoreUtils.getReferralUserByCode(controller.referralCodeController.value.text).then((value) async {
                                    if (value != null) {
                                      ReferralModel ownReferralModel = ReferralModel(
                                        id: FireStoreUtils.getCurrentUid(),
                                        referralBy: value.id,
                                        referralCode: Constant.getReferralCode(),
                                      );
                                      await FireStoreUtils.referralAdd(ownReferralModel);
                                    } else {
                                      ReferralModel referralModel = ReferralModel(id: FireStoreUtils.getCurrentUid(), referralBy: "", referralCode: Constant.getReferralCode());
                                      await FireStoreUtils.referralAdd(referralModel);
                                    }
                                  });
                                  await FireStoreUtils.updateDriverUser(userModel).then((value) {
                                    ShowToastDialog.closeLoader();
                                    if (value == true) {
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

                                      if (userModel.subscriptionPlanId == null || isPlanExpire == true) {
                                        if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                                          Get.offAll(const DashBoardScreen());
                                        } else {
                                          Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                        }
                                      } else {
                                        Get.offAll(const DashBoardScreen());
                                      }
                                    }
                                  });
                                } else {
                                  ShowToastDialog.showToast("Referral code Invalid".tr);
                                }
                              });
                            } else {
                              ShowToastDialog.showLoader("Please wait".tr);
                              DriverUserModel userModel = controller.userModel.value;
                              userModel.fullName = controller.fullNameController.value.text;
                              userModel.email = controller.emailController.value.text;
                              userModel.countryCode = controller.countryCode.value;
                              userModel.phoneNumber = controller.phoneNumberController.value.text;
                              userModel.documentVerification = false;
                              userModel.isOnline = false;
                              userModel.isEnabled = true;
                              userModel.createdAt = Timestamp.now();
                              String token = await NotificationService.getToken();
                              userModel.fcmToken = token;

                              ReferralModel referralModel = ReferralModel(
                                id: FireStoreUtils.getCurrentUid(),
                                referralBy: "",
                                referralCode: Constant.getReferralCode(),
                              );
                              await FireStoreUtils.referralAdd(referralModel);

                              await FireStoreUtils.updateDriverUser(userModel).then((value) {
                                ShowToastDialog.closeLoader();
                                if (value == true) {
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

                                  if (userModel.subscriptionPlanId == null || isPlanExpire == true) {
                                    if (Constant.adminCommission?.isEnabled == false && Constant.isSubscriptionModelApplied == false) {
                                      Get.offAll(const DashBoardScreen());
                                    } else {
                                      Get.offAll(const SubscriptionListScreen(), arguments: {"isShow": true});
                                    }
                                  } else {
                                    Get.offAll(const DashBoardScreen());
                                  }
                                }
                              });
                            }
                          }
                        }),
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
