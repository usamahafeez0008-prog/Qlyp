import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/home_controller.dart';
import '../../utils/DarkThemeProvider.dart';
import '../../utils/fire_store_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<HomeController>(
      init: HomeController(),
      dispose: (state) {
        FireStoreUtils().closeStream();
        // Clean up map controller + location stream if you want:
        if (Get.isRegistered<_MapHelperController>()) {
          Get.delete<_MapHelperController>();
        }
      },
      builder: (controller) {
        if (controller.isLoading.value || controller.driverModel.value.id == null) {
          return Constant.loader(isDarkTheme: themeChange.getThem());
        }

        // helper controller only for map/location UI (doesn't change your business logic)
        final mapHelper = Get.put(_MapHelperController(), permanent: true);

        return Obx(() {
          // If location isn't ready yet, show loader
          if (mapHelper.currentLatLng.value == null) {
            return Constant.loader(isDarkTheme: themeChange.getThem());
          }

          final current = mapHelper.currentLatLng.value!;
          final markers = <Marker>{
            // ✅ Marker at current location
            Marker(
              markerId: const MarkerId("current_location"),
              position: current,
              infoWindow: const InfoWindow(title: "Your current location"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),

            // ✅ Marker for selected location (tap)
            if (mapHelper.selectedLatLng.value != null)
              Marker(
                markerId: const MarkerId("selected_location"),
                position: mapHelper.selectedLatLng.value!,
                infoWindow: const InfoWindow(title: "Selected location"),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              ),
          };

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: current,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,

            markers: markers,

            onMapCreated: (gController) {
              mapHelper.setMapController(gController);

              // ✅ jump camera to current location once map is ready
              mapHelper.moveCamera(current, zoom: 15);
            },

            // ✅ User can select any location by tapping
            onTap: (LatLng latLng) {
              mapHelper.selectedLatLng.value = latLng;
            },
          );
        });
      },
    );
  }
}

/// Small helper controller to keep map/location state.
/// (keeps your HomeController untouched)
class _MapHelperController extends GetxController {
  final Rxn<LatLng> currentLatLng = Rxn<LatLng>();
  final Rxn<LatLng> selectedLatLng = Rxn<LatLng>();

  GoogleMapController? _mapController;

  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _sub;

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> moveCamera(LatLng target, {double zoom = 15}) async {
    final c = _mapController;
    if (c == null) return;
    await c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: zoom)));
  }

  Future<void> _initLocation() async {
    try {
      // ✅ Service enabled?
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      // ✅ Permission
      loc.PermissionStatus permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != loc.PermissionStatus.granted) return;
      }

      // ✅ Fetch once immediately (auto fetch current location)
      final first = await _location.getLocation();
      if (first.latitude != null && first.longitude != null) {
        currentLatLng.value = LatLng(first.latitude!, first.longitude!);
      }

      // ✅ Keep updating current location (optional but useful)
      _sub?.cancel();
      _sub = _location.onLocationChanged.listen((loc.LocationData data) {
        if (data.latitude == null || data.longitude == null) return;
        currentLatLng.value = LatLng(data.latitude!, data.longitude!);
      });
    } catch (_) {
      // If something fails, currentLatLng stays null -> loader remains
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}



/*
import 'package:driver/constant/constant.dart';
import 'package:driver/controller/home_controller.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<HomeController>(
        init: HomeController(),
        dispose: (state) {
          FireStoreUtils().closeStream();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.lightprimary,
            body: controller.isLoading.value || controller.driverModel.value.id == null
                ? Constant.loader(isDarkTheme: themeChange.getThem())
                : Column(
                    children: [
                      if (controller.driverModel.value.ownerId == null)
                        double.parse(controller.driverModel.value.walletAmount ?? '0.0') >= double.parse(Constant.minimumDepositToRideAccept)
                            ? SizedBox(
                                height: Responsive.width(8, context),
                                width: Responsive.width(100, context),
                              )
                            : SizedBox(
                                height: Responsive.width(18, context),
                                width: Responsive.width(100, context),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Text("You have to minimum ${Constant.amountShow(amount: Constant.minimumDepositToRideAccept.toString())} wallet amount to Accept Order and place a bid".tr,
                                      style: GoogleFonts.poppins(color: Colors.white)),
                                ),
                              ),
                      Expanded(
                        child: Container(
                          height: Responsive.height(100, context),
                          width: Responsive.width(100, context),
                          decoration:
                              BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: controller.widgetOptions.elementAt(controller.selectedIndex.value),
                          ),
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset("assets/icons/ic_new.png",
                          width: 18,
                          color: controller.selectedIndex.value == 0
                              ? themeChange.getThem()
                                  ? AppColors.darksecondprimary
                                  : AppColors.lightsecondprimary
                              : Colors.white),
                    ),
                    label: 'New'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset("assets/icons/ic_accepted.png",
                          width: 18,
                          color: controller.selectedIndex.value == 1
                              ? themeChange.getThem()
                                  ? AppColors.darksecondprimary
                                  : AppColors.lightsecondprimary
                              : Colors.white),
                    ),
                    label: 'Accepted'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: badges.Badge(
                      badgeContent: Text(controller.isActiveValue.value.toString()),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset("assets/icons/ic_active.png",
                            width: 18,
                            color: controller.selectedIndex.value == 2
                                ? themeChange.getThem()
                                    ? AppColors.darksecondprimary
                                    : AppColors.lightsecondprimary
                                : Colors.white),
                      ),
                    ),
                    label: 'Active'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset("assets/icons/ic_completed.png",
                          width: 18,
                          color: controller.selectedIndex.value == 3
                              ? themeChange.getThem()
                                  ? AppColors.darksecondprimary
                                  : AppColors.lightsecondprimary
                              : Colors.white),
                    ),
                    label: 'Completed'.tr,
                  ),
                ],
                backgroundColor: AppColors.lightprimary,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.selectedIndex.value,
                selectedItemColor: themeChange.getThem() ? AppColors.darksecondprimary : AppColors.lightsecondprimary,
                unselectedItemColor: Colors.white,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                onTap: controller.onItemTapped),
          );
        });
  }
}
*/
