import 'package:driver/model/document_model.dart';
import 'package:driver/model/driver_document_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class OnlineRegistrationController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getDocument();
   // testFlow();
    super.onInit();
  }

  void testFlow() async {
    String mainServiceID = "KME0X43zSpbDmt4TfuRH";
    print("--- STARTING TEST FLOW for MainServiceID: $mainServiceID ---");

    try {
      // 1. Get MainService
      var mainServiceDoc = await FireStoreUtils.fireStore
          .collection("main_services")
          .doc(mainServiceID)
          .get();
      if (mainServiceDoc.exists) {
        print("MainService Found: ${mainServiceDoc.data()}");
      } else {
        print("MainService NOT Found with ID: $mainServiceID");
      }

      // 2. Get services linked to this mainServiceID
      var servicesQuery = await FireStoreUtils.fireStore
          .collection("service")
          .where("mainServiceID", isEqualTo: mainServiceID)
          .get();

      print("Services found count: ${servicesQuery.docs.length}");
      for (var serviceDoc in servicesQuery.docs) {
        String serviceId = serviceDoc.id;
        print("Service found: $serviceId -> ${serviceDoc.data()}");

        // 3. Get vehicle_types linked to this serviceID
        var vehicleTypeQuery = await FireStoreUtils.fireStore
            .collection("vehicle_type")
            .where("serviceID", isEqualTo: serviceId)
            .get();

        print(
            "  VehicleTypes found for Service $serviceId count: ${vehicleTypeQuery.docs.length}");
        for (var vehicleDoc in vehicleTypeQuery.docs) {
          print(
              "    VehicleType found: ${vehicleDoc.id} -> ${vehicleDoc.data()}");
        }
      }
    } catch (e) {
      print("Error in testFlow: $e");
    }
    print("--- END TEST FLOW ---");
  }

  RxList documentList = <DocumentModel>[].obs;
  RxList driverDocumentList = <Documents>[].obs;

  getDocument() async {
    await FireStoreUtils.getDocumentList().then((value) {
      documentList.value = value;
      isLoading.value = false;
    });

    await FireStoreUtils.getDocumentOfDriver().then((value) {
      if (value != null) {
        driverDocumentList.value = value.documents!;
      }
    });
    update();
  }
}
