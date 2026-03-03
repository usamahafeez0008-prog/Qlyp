import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/information_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/referral_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:driver/ui/subscription_plan_screen/subscription_list_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<InformationController>(
      init: InformationController(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset(
                      "assets/images/login_image.png",
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Sign up".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Create your account to start using QlYP".tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xff838EA1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    context: context,
                    label: "Full Name".tr,
                    hint: "Enter your full name".tr,
                    controller: controller.fullNameController.value,
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Row
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
                                textSelectionTheme:
                                    const TextSelectionThemeData(
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
                              "Numéro de téléphone".tr,
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
                                  enabled: controller.loginType.value ==
                                          Constant.phoneLoginType
                                      ? false
                                      : true,
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

                  const SizedBox(height: 16),

                  _buildTextField(
                    context: context,
                    label: "Email".tr,
                    hint: "Enter your email".tr,
                    controller: controller.emailController.value,
                    keyboardType: TextInputType.emailAddress,
                    enabled:
                        controller.loginType.value == Constant.googleLoginType
                            ? false
                            : true,
                  ),
                  const SizedBox(height: 16),

                  // _buildTextField(
                  //   context: context,
                  //   label: "Referral Code (Optional)".tr,
                  //   hint: "Enter referral code".tr,
                  //   controller: controller.referralCodeController.value,
                  // ),
                  const SizedBox(height: 32),

                  // Create account Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        // ✅ ORIGINAL LOGIC (UNCHANGED)
                        if (controller.fullNameController.value.text.isEmpty) {
                          ShowToastDialog.showToast(
                              "Please enter full name".tr);
                        } else if (controller
                            .emailController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter email".tr);
                        } else if (controller
                            .phoneNumberController.value.text.isEmpty) {
                          ShowToastDialog.showToast(
                              "Please enter phone number".tr);
                        } else if (Constant.validateEmail(
                                controller.emailController.value.text) ==
                            false) {
                          ShowToastDialog.showToast(
                              "Please enter valid email".tr);
                        } else {
                          if (controller
                              .referralCodeController.value.text.isNotEmpty) {
                            FireStoreUtils.checkReferralCodeValidOrNot(
                                    controller
                                        .referralCodeController.value.text)
                                .then((value) async {
                              if (value == true) {
                                ShowToastDialog.showLoader("Please wait".tr);
                                DriverUserModel userModel =
                                    controller.userModel.value;
                                userModel.fullName =
                                    controller.fullNameController.value.text;
                                userModel.email =
                                    controller.emailController.value.text;
                                userModel.countryCode =
                                    controller.countryCode.value;
                                userModel.phoneNumber =
                                    controller.phoneNumberController.value.text;
                                userModel.documentVerification = false;
                                userModel.isOnline = false;
                                userModel.isEnabled = true;
                                userModel.createdAt = Timestamp.now();
                                String token =
                                    await NotificationService.getToken();
                                userModel.fcmToken = token;

                                await FireStoreUtils.getReferralUserByCode(
                                        controller
                                            .referralCodeController.value.text)
                                    .then((value) async {
                                  if (value != null) {
                                    ReferralModel ownReferralModel =
                                        ReferralModel(
                                      id: FireStoreUtils.getCurrentUid(),
                                      referralBy: value.id,
                                      referralCode: Constant.getReferralCode(),
                                    );
                                    await FireStoreUtils.referralAdd(
                                        ownReferralModel);
                                  } else {
                                    ReferralModel referralModel = ReferralModel(
                                      id: FireStoreUtils.getCurrentUid(),
                                      referralBy: "",
                                      referralCode: Constant.getReferralCode(),
                                    );
                                    await FireStoreUtils.referralAdd(
                                        referralModel);
                                  }
                                });

                                await FireStoreUtils.updateDriverUser(userModel)
                                    .then((value) {
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
                                ShowToastDialog.showToast(
                                    "Referral code Invalid".tr);
                              }
                            });
                          } else {
                            ShowToastDialog.showLoader("Please wait".tr);
                            DriverUserModel userModel =
                                controller.userModel.value;
                            userModel.fullName =
                                controller.fullNameController.value.text;
                            userModel.email =
                                controller.emailController.value.text;
                            userModel.countryCode =
                                controller.countryCode.value;
                            userModel.phoneNumber =
                                controller.phoneNumberController.value.text;
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

                            await FireStoreUtils.updateDriverUser(userModel)
                                .then((value) {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff12223b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Create account".tr,
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

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            border: Border.all(color: const Color(0xffE2E5EA)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              cursorColor: const Color(0xff0C1A30),
              style: GoogleFonts.poppins(
                color: const Color(0xff0C1A30),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
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
