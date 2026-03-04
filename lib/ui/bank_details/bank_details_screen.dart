import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/bank_details_controller.dart';
import 'package:driver/model/bank_details_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/ui/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<BankDetailsController>(
        init: BankDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.qlypDeepNavy, size: 20),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'Payment Setup',
                style: GoogleFonts.poppins(
                  color: AppColors.qlypDeepNavy,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.verified_user_outlined,
                      color: AppColors.qlypPrimaryFreshGreen),
                )
              ],
            ),
            body: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProgressIndicator(),
                              const SizedBox(height: 32),
                              _buildSectionTitle('SELECT PAYMENT METHOD'),
                              const SizedBox(height: 16),
                              _buildPaymentMethodsRow(controller),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Icon(Icons.verified_user_outlined,
                                      color: AppColors.qlypPrimaryFreshGreen,
                                      size: 18),
                                  const SizedBox(width: 8),
                                  _buildSectionTitle(
                                      'BANK ACCOUNT INFORMATION'),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildBankDetailsForm(controller),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  "Your banking data is encrypted and protected under Quebec's Act respecting the protection of personal information.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color:
                                        AppColors.qlypCharcoal.withOpacity(0.5),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildSectionTitle('PAYOUT FREQUENCY'),
                              const SizedBox(height: 16),
                              _buildPayoutFrequencyRow(controller),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomSection(controller),
                    ],
                  ),
          );
        });
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP 3 OF 3',
              style: GoogleFonts.poppins(
                color: AppColors.qlypCharcoal.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'FINAL STEP',
              style: GoogleFonts.poppins(
                color: AppColors.qlypPrimaryFreshGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.qlypPrimaryFreshGreen,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: AppColors.qlypCharcoal.withOpacity(0.6),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPaymentMethodsRow(BankDetailsController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildSelectableCard(
            title: 'Bank\nAccount',
            icon: Icons.account_balance,
            isSelected:
                controller.selectedPaymentMethod.value == 'Bank Account',
            onTap: () =>
                controller.selectedPaymentMethod.value = 'Bank Account',
            badgeText: 'RECOMMENDED',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSelectableCard(
            title: '\nCredit Card',
            icon: Icons.credit_card,
            isSelected: controller.selectedPaymentMethod.value == 'Credit Card',
            onTap: () => controller.selectedPaymentMethod.value = 'Credit Card',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSelectableCard(
            title: '\nPayPal',
            icon: Icons.paypal,
            isSelected: controller.selectedPaymentMethod.value == 'PayPal',
            onTap: () => controller.selectedPaymentMethod.value = 'PayPal',
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.qlypPrimaryFreshGreen.withOpacity(0.05)
                  : const Color(0xffF9F9F9),
              border: Border.all(
                color: isSelected
                    ? AppColors.qlypPrimaryFreshGreen
                    : const Color(0xffEFEFEF),
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.qlypPrimaryFreshGreen.withOpacity(0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.qlypPrimaryFreshGreen
                        : AppColors.qlypCharcoal.withOpacity(0.4),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: isSelected
                        ? AppColors.qlypDeepNavy
                        : AppColors.qlypCharcoal.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Positioned(
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.qlypPrimaryFreshGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsForm(BankDetailsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _miniLabel("Account Holder Name"),
          const SizedBox(height: 6),
          _buildTextField(controller.holderNameController.value),
          const SizedBox(height: 16),
          _miniLabel("Bank Name"),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffEFEFEF)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                isExpanded: true,
                value: controller.selectedBankName.value,
                icon: const Icon(Icons.unfold_more_rounded,
                    color: AppColors.qlypCharcoal, size: 20),
                items: controller.bankList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: GoogleFonts.poppins(
                            color: AppColors.qlypCharcoal, fontSize: 13)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedBankName.value = newValue;
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniLabel("Transit Number"),
                    const SizedBox(height: 6),
                    _buildTextField(controller.transitNoController.value,
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniLabel("Account Number"),
                    const SizedBox(height: 6),
                    _buildTextField(controller.accountNumberController.value,
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.qlypCharcoal.withOpacity(0.6),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffEFEFEF)),
      ),
      child: TextField(
        controller: textController,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: AppColors.qlypCharcoal, fontSize: 14),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPayoutFrequencyRow(BankDetailsController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildFrequencyCard(
            title: 'Daily',
            subtitle: 'Instant',
            isSelected: controller.selectedPayoutFrequency.value == 'Daily',
            onTap: () => controller.selectedPayoutFrequency.value = 'Daily',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFrequencyCard(
            title: 'Weekly',
            subtitle: 'No Fees',
            isSelected: controller.selectedPayoutFrequency.value == 'Weekly',
            onTap: () => controller.selectedPayoutFrequency.value = 'Weekly',
            badgeText: 'POPULAR',
            subtitleColor: AppColors.qlypPrimaryFreshGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFrequencyCard(
            title: 'Monthly',
            subtitle: 'Bundled',
            isSelected: controller.selectedPayoutFrequency.value == 'Monthly',
            onTap: () => controller.selectedPayoutFrequency.value = 'Monthly',
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    String? badgeText,
    Color? subtitleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isSelected
                    ? AppColors.qlypPrimaryFreshGreen
                    : const Color(0xffEFEFEF),
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.qlypDeepNavy,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: subtitleColor ??
                        AppColors.qlypCharcoal.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Positioned(
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.qlypPrimaryFreshGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BankDetailsController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xffEFEFEF))),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              if (controller.holderNameController.value.text.isEmpty) {
                ShowToastDialog.showToast("Please enter account holder name");
                return;
              }
              if (controller.transitNoController.value.text.isEmpty) {
                ShowToastDialog.showToast("Please enter transit number");
                return;
              }
              if (controller.accountNumberController.value.text.isEmpty) {
                ShowToastDialog.showToast("Please enter account number");
                return;
              }

              ShowToastDialog.showLoader("Please wait");
              BankDetailsModel bankDetailsModel =
                  controller.bankDetailsModel.value;

              bankDetailsModel.userId = FireStoreUtils.getCurrentUid();
              bankDetailsModel.bankName = controller.selectedBankName.value;
              bankDetailsModel.branchName = " ";
              bankDetailsModel.transitNumber =
                  controller.transitNoController.value.text;
              bankDetailsModel.holderName =
                  controller.holderNameController.value.text;
              bankDetailsModel.accountNumber =
                  controller.accountNumberController.value.text;
              bankDetailsModel.payoutFrequency =
                  controller.selectedPayoutFrequency.value;
              // Storing selected frequencies/methods in otherInformation if needed
              bankDetailsModel.otherInformation =
                  "Payment: ${controller.selectedPaymentMethod.value}";

              await FireStoreUtils.updateBankDetails(bankDetailsModel);

              // Update driver verification status
              var driverProfile = await FireStoreUtils.getDriverProfile(
                  FireStoreUtils.getCurrentUid());
              if (driverProfile != null) {
                driverProfile.documentVerification = true;
                await FireStoreUtils.updateDriverUser(driverProfile);
              }

              ShowToastDialog.closeLoader();
              ShowToastDialog.showToast("Bank details updated successfully");
              Get.offAll(const DashBoardScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.qlypDeepNavy,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Complete Onboarding',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check_circle_outline,
                    color: Colors.white, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline,
                  color: AppColors.qlypCharcoal.withOpacity(0.5), size: 14),
              const SizedBox(width: 6),
              Text(
                'Secure End-to-End Payout Setup',
                style: GoogleFonts.poppins(
                  color: AppColors.qlypCharcoal.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*

import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/bank_details_controller.dart';
import 'package:driver/model/bank_details_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/button_them.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/text_field_them.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<BankDetailsController>(
        init: BankDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightprimary,
            body: Column(
              children: [
                SizedBox(
                  height: Responsive.width(12, context),
                  width: Responsive.width(100, context),
                ),
                Expanded(
                  child: Container(
                    height: Responsive.height(100, context),
                    width: Responsive.width(100, context),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                    child: controller.isLoading.value
                        ? Constant.loader(isDarkTheme: themeChange.getThem())
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bank Name".tr, style: GoogleFonts.poppins()),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFieldThem.buildTextFiled(context, hintText: 'Bank Name'.tr, controller: controller.bankNameController.value),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Branch Name".tr, style: GoogleFonts.poppins()),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFieldThem.buildTextFiled(context, hintText: 'Branch Name'.tr, controller: controller.branchNameController.value),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Holder Name".tr, style: GoogleFonts.poppins()),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFieldThem.buildTextFiled(context, hintText: 'Holder Name'.tr, controller: controller.holderNameController.value),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Account Number".tr, style: GoogleFonts.poppins()),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFieldThem.buildTextFiled(context, hintText: 'Account Number'.tr, controller: controller.accountNumberController.value),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("Other Information".tr, style: GoogleFonts.poppins()),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFieldThem.buildTextFiled(context, hintText: 'Other Information'.tr, controller: controller.otherInformationController.value),
                            const SizedBox(
                              height: 40,
                            ),
                            ButtonThem.buildButton(
                              context,
                              title: "Save".tr,
                              onPress: () async {
                                if (controller.bankNameController.value.text.isEmpty) {
                                  ShowToastDialog.showToast("Please enter bank name".tr);
                                } else if (controller.branchNameController.value.text.isEmpty) {
                                  ShowToastDialog.showToast("Please enter branch name".tr);
                                } else if (controller.holderNameController.value.text.isEmpty) {
                                  ShowToastDialog.showToast("Please enter holder name".tr);
                                } else if (controller.accountNumberController.value.text.isEmpty) {
                                  ShowToastDialog.showToast("Please enter account number".tr);
                                } else {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  BankDetailsModel bankDetailsModel = controller.bankDetailsModel.value;

                                  bankDetailsModel.userId = FireStoreUtils.getCurrentUid();
                                  bankDetailsModel.bankName = controller.bankNameController.value.text;
                                  bankDetailsModel.branchName = controller.branchNameController.value.text;
                                  bankDetailsModel.holderName = controller.holderNameController.value.text;
                                  bankDetailsModel.accountNumber = controller.accountNumberController.value.text;
                                  bankDetailsModel.otherInformation = controller.otherInformationController.value.text;

                                  await FireStoreUtils.updateBankDetails(bankDetailsModel).then((value) {
                                    ShowToastDialog.closeLoader();
                                    ShowToastDialog.showToast("Bank details update successfully".tr);
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
*/
