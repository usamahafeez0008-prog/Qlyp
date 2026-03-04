import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/model/driver_rules_model.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/main_service_model.dart';
import 'package:driver/model/service_model.dart';
import 'package:driver/model/vehicle_type_model.dart';
import 'package:driver/model/zone_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:driver/ui/bank_details/bank_details_screen.dart';

class VehicleInformationController extends GetxController {
  Rx<TextEditingController> vehicleNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> seatsController = TextEditingController().obs;
  Rx<TextEditingController> makeController = TextEditingController().obs;
  Rx<TextEditingController> colorController = TextEditingController().obs;
  Rx<TextEditingController> modelController = TextEditingController().obs;
  Rx<TextEditingController> trimController = TextEditingController().obs;
  Rx<TextEditingController> vinController = TextEditingController().obs;
  Rx<TextEditingController> registrationDateController =
      TextEditingController().obs;
  Rx<TextEditingController> driverRulesController = TextEditingController().obs;
  Rx<TextEditingController> zoneNameController = TextEditingController().obs;
  RxList<TextEditingController> acPerKmRate = <TextEditingController>[].obs;
  RxList<TextEditingController> nonAcPerKmRate = <TextEditingController>[].obs;
  RxList<TextEditingController> acNonAcWithoutPerKmRate =
      <TextEditingController>[].obs;
  Rx<DateTime?> selectedDate = DateTime.now().obs;

  RxBool isLoading = true.obs;

  Rx<String?> selectedYear = Rx<String?>(null);
  List<String> yearList =
      List.generate(31, (index) => (DateTime.now().year - index).toString());

  // For exactly 4 vehicle photo views
  RxMap<String, File?> selectedPhotos = <String, File?>{
    "FRONT VIEW": null,
    "REAR VIEW": null,
    "INTERIOR": null,
    "SIDE PROFILE": null,
  }.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickVehiclePhoto(String key) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedPhotos[key] = File(image.path);
    }
  }

  Rx<String> selectedColor = "".obs;
  List<String> carColorList = <String>[
    'Red',
    'Black',
    'White',
    'Blue',
    'Green',
    'Orange',
    'Silver',
    'Gray',
    'Yellow',
    'Brown',
    'Gold',
    'Beige',
    'Purple'
  ].obs;
  List<String> sheetList = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15'
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getVehicleTye();
    super.onInit();
  }

  var colors = [
    AppColors.serviceColor1,
    AppColors.serviceColor2,
    AppColors.serviceColor3,
  ];
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  RxList<DriverRulesModel> driverRulesList = <DriverRulesModel>[].obs;
  RxList<DriverRulesModel> selectedDriverRulesList = <DriverRulesModel>[].obs;

  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;
  Rx<ServiceModel> selectedServiceType = ServiceModel().obs;

  RxList<MainServiceModel> mainServiceList = <MainServiceModel>[].obs;
  Rx<MainServiceModel?> selectedMainService = Rx<MainServiceModel?>(null);

  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  Rx<VehicleTypeModel?> selectedVehicleType = Rx<VehicleTypeModel?>(null);

  RxList<ZoneModel> zoneAllList = <ZoneModel>[].obs;
  RxList<ZoneModel> zoneList = <ZoneModel>[].obs;
  RxList selectedTempZone = <String>[].obs;
  RxList selectedZone = <String>[].obs;
  RxString zoneString = "".obs;
  RxList<Price> selectedPrices = <Price>[].obs;

  Future<void> getVehicleTye() async {
    await FireStoreUtils.getMainServices().then((value) {
      mainServiceList.value = value;
      if (mainServiceList.isNotEmpty) {
        selectedMainService.value = mainServiceList.first;
        getServicesByMainService();
      }
    });

    // getService call removed to let mainService filter handle serviceList

    await FireStoreUtils.getZone().then((value) {
      if (value != null) {
        zoneAllList.value = value;
      }
    });

    await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid())
        .then((value) async {
      if (value != null) {
        driverModel.value = value;
        if (driverModel.value.vehicleInformation != null) {
          vehicleNumberController.value.text =
              driverModel.value.vehicleInformation!.vehicleNumber.toString();
          selectedDate.value =
              driverModel.value.vehicleInformation!.registrationDate!.toDate();
          registrationDateController.value.text =
              DateFormat("dd-MM-yyyy").format(selectedDate.value!);
          selectedColor.value =
              driverModel.value.vehicleInformation!.vehicleColor.toString();
          seatsController.value.text =
              driverModel.value.vehicleInformation!.seats ?? "2";

          makeController.value.text =
              driverModel.value.vehicleInformation!.carMake ?? "";

          colorController.value.text =
              driverModel.value.vehicleInformation!.carMake ?? "";
          modelController.value.text =
              driverModel.value.vehicleInformation!.carModel ?? "";
          trimController.value.text =
              driverModel.value.vehicleInformation!.carTrim ?? "";
          vinController.value.text =
              driverModel.value.vehicleInformation!.carVin ?? "";
          selectedYear.value =
              driverModel.value.vehicleInformation!.vehicleYear;

          selectedServiceType.value =
              await FireStoreUtils.getServiceById(driverModel.value.serviceId);
          zoneList.clear();
          final priceIds =
              selectedServiceType.value.prices!.map((p) => p.zoneId).toSet();
          zoneList.addAll(zoneAllList.where((z) => priceIds.contains(z.id)));
          if (driverModel.value.zoneIds != null) {
            if (zoneList.isNotEmpty) {
              for (var element in zoneList) {
                if (driverModel.value.zoneIds
                        ?.contains(element.id.toString()) ==
                    true) {
                  zoneString.value =
                      "${zoneString.value}${zoneString.value.isEmpty ? "" : ","} ${Constant.localizationName(element.name)}";
                  selectedZone.add(element.id);
                }
              }
            }
            zoneNameController.value.text = zoneString.value;
            selectedPrices.value = selectedServiceType.value.prices
                    ?.where((price) => selectedZone.contains(price.zoneId))
                    .toList() ??
                <Price>[];
            acPerKmRate.value = List.generate(
                selectedPrices.length, (index) => TextEditingController());
            nonAcPerKmRate.value = List.generate(
                selectedPrices.length, (index) => TextEditingController());
            acNonAcWithoutPerKmRate.value = List.generate(
                selectedPrices.length, (index) => TextEditingController());

            for (int index = 0;
                index < driverModel.value.vehicleInformation!.rates!.length;
                index++) {
              if (driverModel
                      .value.vehicleInformation!.rates?[index].acPerKmRate !=
                  null) {
                acPerKmRate[index].text = driverModel
                        .value.vehicleInformation!.rates?[index].acPerKmRate ??
                    '';
                acNonAcWithoutPerKmRate[index].text = driverModel
                        .value.vehicleInformation!.rates?[index].perKmRate ??
                    '';
                nonAcPerKmRate[index].text = driverModel.value
                        .vehicleInformation!.rates?[index].nonAcPerKmRate ??
                    '';
              } else {
                nonAcPerKmRate[index].text = driverModel.value
                        .vehicleInformation!.rates?[index].nonAcPerKmRate ??
                    '';
                acNonAcWithoutPerKmRate[index].text = driverModel
                        .value.vehicleInformation!.rates?[index].perKmRate ??
                    '';
              }
            }
          }
          tabBarheight.value =
              selectedPrices.first.isAcNonAc == true ? 200 : 100;
        }
        if (driverModel.value.zoneIds == null) {
          selectedServiceType.value = serviceList.first;
          getZone();
        }
      }
    });

    await FireStoreUtils.getDriverRules().then((value) {
      if (value != null) {
        driverRulesList.value = value;
        if (driverModel.value.vehicleInformation != null) {
          if (driverModel.value.vehicleInformation!.driverRules != null) {
            for (var element
                in driverModel.value.vehicleInformation!.driverRules!) {
              selectedDriverRulesList.add(element);
            }
          }
        }
      }
    });
    isLoading.value = false;
    update();
  }

  void getZone() {
    selectedZone.value = <String>[];
    zoneNameController.value.text = '';
    selectedPrices.clear();
    zoneList.clear();
    final priceIds =
        selectedServiceType.value.prices!.map((p) => p.zoneId).toSet();
    zoneList.addAll(zoneAllList.where((z) => priceIds.contains(z.id)));
  }

  Future<void> getServicesByMainService() async {
    if (selectedMainService.value?.mainServiceID != null) {
      isLoading.value = true;
      await FireStoreUtils.getServiceByMainServiceId(
              selectedMainService.value!.mainServiceID!)
          .then((value) {
        serviceList.value = value;
        if (serviceList.isNotEmpty) {
          selectedServiceType.value = serviceList.first;
          getVehicleTypesByService();
        } else {
          selectedServiceType.value = ServiceModel();
          vehicleTypeList.clear();
        }
      });
      isLoading.value = false;
    }
  }

  Future<void> getVehicleTypesByService() async {
    if (selectedServiceType.value.id != null) {
      isLoading.value = true;
      await FireStoreUtils.getVehicleTypeByServiceId(
              selectedServiceType.value.id!)
          .then((value) {
        vehicleTypeList.value = value;
        if (vehicleTypeList.isNotEmpty) {
          selectedVehicleType.value = vehicleTypeList.first;
        } else {
          selectedVehicleType.value = null;
        }
      });
      isLoading.value = false;
    }
  }

  void setVehicleDetails() {
    VehicleInformation oldInfo =
        driverModel.value.vehicleInformation ?? VehicleInformation();

    if (driverModel.value.serviceId == null) {
      driverModel.value.serviceId = selectedServiceType.value.id;
      driverModel.value.serviceName = selectedServiceType.value.title;
    }

    driverModel.value.vehicleInformation = VehicleInformation(
        registrationDate: oldInfo.registrationDate ?? Timestamp.now(),
        vehicleColor: colorController.value.text,
        vehicleNumber: vinController.value.text,
        seats: oldInfo.seats ?? "",
        vehicleYear: selectedYear.value ?? "",
        carMake: makeController.value.text,
        carModel: modelController.value.text,
        carTrim: trimController.value.text,
        carVin: vinController.value.text,
        vehicleTypeId: selectedVehicleType.value?.id ?? oldInfo.vehicleTypeId,
        vehicleTypeName:
            Constant.localizationName(selectedVehicleType.value?.name) ??
                oldInfo.vehicleTypeName,
        mainServiceId:
            selectedMainService.value?.mainServiceID ?? oldInfo.mainServiceId,
        mainServiceName:
            selectedMainService.value?.serviceName ?? oldInfo.mainServiceName,
        serviceId: selectedServiceType.value.id ?? oldInfo.serviceId,
        serviceName:
            Constant.localizationTitle(selectedServiceType.value.title) ??
                oldInfo.serviceName,
        driverRules: oldInfo.driverRules ?? <DriverRulesModel>[],
        rates: oldInfo.rates ?? <RateModel>[]);
  }

  Future<void> validateAndSave() async {
    ShowToastDialog.showLoader("Please wait".tr);

    if (selectedYear.value == null || selectedYear.value!.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please select vehicle year".tr);
      return;
    } else if (colorController.value.text.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please enter vehicle color".tr);
      return;
    } else if (makeController.value.text.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please enter vehicle make".tr);
      return;
    } else if (modelController.value.text.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please enter vehicle model".tr);
      return;
    } else if (trimController.value.text.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please enter vehicle trim".tr);
      return;
    } else if (vinController.value.text.isEmpty) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Please enter vehicle VIN".tr);
      return;
    }

    for (String key in [
      "FRONT VIEW",
      "REAR VIEW",
      "INTERIOR",
      "SIDE PROFILE"
    ]) {
      int index =
          ["FRONT VIEW", "REAR VIEW", "INTERIOR", "SIDE PROFILE"].indexOf(key);
      bool hasExisting = false;
      if (driverModel.value.vehicleInformation?.vehiclePhotos != null &&
          driverModel.value.vehicleInformation!.vehiclePhotos!.length > index &&
          driverModel
              .value.vehicleInformation!.vehiclePhotos![index].isNotEmpty) {
        hasExisting = true;
      }

      if (selectedPhotos[key] == null && !hasExisting) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            "Please upload ${key.toLowerCase()} photo".tr);
        return;
      }
    }

    ShowToastDialog.closeLoader();
    saveDetails();
  }

  Future<void> saveDetails() async {
    ShowToastDialog.showLoader("Saving details...".tr);

    // Attempt uploading photos if they exist
    List<String> photoUrls = [];
    if (driverModel.value.vehicleInformation?.vehiclePhotos != null) {
      photoUrls =
          List.from(driverModel.value.vehicleInformation!.vehiclePhotos!);
    } else {
      photoUrls = ["", "", "", ""];
    }

    try {
      int index = 0;
      for (String key in [
        "FRONT VIEW",
        "REAR VIEW",
        "INTERIOR",
        "SIDE PROFILE"
      ]) {
        if (selectedPhotos[key] != null) {
          String url = await Constant.uploadUserImageToFireStorage(
              selectedPhotos[key]!,
              'vehicleImages/${FireStoreUtils.getCurrentUid()}',
              '${FireStoreUtils.getCurrentUid()}_${key.replaceAll(" ", "")}_${DateTime.now().millisecondsSinceEpoch}.jpg');
          photoUrls[index] = url;
        }
        index++;
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Failed to upload photos: ${e.toString()}");
      return;
    }

    setVehicleDetails();
    driverModel.value.vehicleInformation?.vehiclePhotos = photoUrls;

    await FireStoreUtils.updateDriverUser(driverModel.value).then((value) {
      ShowToastDialog.closeLoader();
      if (value == true) {
        ShowToastDialog.showToast(
          "Information update successfully".tr,
        );
        Get.to(() => const BankDetailsScreen());
      }
    });
  }

  RxDouble tabBarheight = 200.0.obs;
}
