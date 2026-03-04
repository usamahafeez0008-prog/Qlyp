import 'package:driver/model/bank_details_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsController extends GetxController {
  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> branchNameController = TextEditingController().obs;
  Rx<TextEditingController> payoutFrequencyHolderController =
      TextEditingController().obs;
  Rx<TextEditingController> transitNoController = TextEditingController().obs;
  Rx<TextEditingController> holderNameController = TextEditingController().obs;
  Rx<TextEditingController> accountNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> otherInformationController =
      TextEditingController().obs;

  RxString selectedPaymentMethod = "Bank Account".obs;
  RxString selectedBankName = "Desjardins (Quebec)".obs;
  RxString selectedPayoutFrequency = "Weekly".obs;

  List<String> bankList = [
    "Desjardins (Quebec)",
    "RBC Royal Bank",
    "TD Canada Trust",
    "Scotiabank",
    "BMO Bank of Montreal",
    "CIBC",
    "National Bank of Canada"
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    getBankDetails();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;

  getBankDetails() async {
    await FireStoreUtils.getBankDetails().then((value) {
      if (value != null) {
        bankDetailsModel.value = value;
        bankNameController.value.text =
            bankDetailsModel.value.bankName.toString();

        branchNameController.value.text =
            bankDetailsModel.value.branchName ?? '';

        holderNameController.value.text =
            bankDetailsModel.value.holderName ?? '';

        accountNumberController.value.text =
            bankDetailsModel.value.accountNumber ?? '';

        otherInformationController.value.text =
            bankDetailsModel.value.otherInformation ?? '';

        transitNoController.value.text =
            bankDetailsModel.value.transitNumber ?? '';

        payoutFrequencyHolderController.value.text =
            bankDetailsModel.value.payoutFrequency ?? '';

        if (bankDetailsModel.value.payoutFrequency != null &&
            bankDetailsModel.value.payoutFrequency!.isNotEmpty) {
          selectedPayoutFrequency.value =
              bankDetailsModel.value.payoutFrequency!;
        }

        if (bankDetailsModel.value.otherInformation != null &&
            bankList.contains(bankDetailsModel.value.bankName)) {
          selectedBankName.value = bankDetailsModel.value.bankName!;
        }
      }
    });
    isLoading.value = false;
    update();
  }
}

// import 'package:driver/model/bank_details_model.dart';
// import 'package:driver/utils/fire_store_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class BankDetailsController extends GetxController {
//   Rx<TextEditingController> bankNameController = TextEditingController().obs;
//   Rx<TextEditingController> branchNameController = TextEditingController().obs;
//   Rx<TextEditingController> holderNameController = TextEditingController().obs;
//   Rx<TextEditingController> accountNumberController = TextEditingController().obs;
//   Rx<TextEditingController> otherInformationController = TextEditingController().obs;
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     getBankDetails();
//     super.onInit();
//   }
//
//   RxBool isLoading = true.obs;
//   Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;
//
//   getBankDetails() async {
//     await FireStoreUtils.getBankDetails().then((value) {
//       if (value != null) {
//         bankDetailsModel.value = value;
//         bankNameController.value.text = bankDetailsModel.value.bankName.toString();
//         branchNameController.value.text = bankDetailsModel.value.bankName.toString();
//         holderNameController.value.text = bankDetailsModel.value.holderName.toString();
//         accountNumberController.value.text = bankDetailsModel.value.accountNumber.toString();
//         otherInformationController.value.text = bankDetailsModel.value.otherInformation.toString();
//       }
//     });
//     isLoading.value = false;
//     update();
//   }
// }
