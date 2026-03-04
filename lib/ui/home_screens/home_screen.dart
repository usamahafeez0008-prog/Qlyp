import 'package:driver/constant/constant.dart';
import 'package:driver/controller/home_controller.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final bool isDark = themeChange.getThem();

    return GetX<HomeController>(
        init: HomeController(),
        dispose: (state) {
          FireStoreUtils().closeStream();
        },
        builder: (controller) {
          /*
          // Previous UI commented out as requested
          return Scaffold(
            backgroundColor: AppColors.qlypOffWhite,
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
            bottomNavigationBar: BottomNavigationBar(...),
          );
          */

          if (controller.isLoading.value ||
              controller.driverModel.value.id == null) {
            return Constant.loader(isDarkTheme: isDark);
          }

          double walletAmount = double.tryParse(
                  controller.driverModel.value.walletAmount ?? '0.0') ??
              0.0;
          double reviewsSum = double.tryParse(
                  controller.driverModel.value.reviewsSum ?? '0.0') ??
              0.0;
          double reviewsCount = double.tryParse(
                  controller.driverModel.value.reviewsCount ?? '0.0') ??
              0.0;
          double rating = reviewsCount > 0 ? (reviewsSum / reviewsCount) : 0.0;

          return Container(
            color: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performance Cards
                  Row(
                    children: [
                      _buildPerformanceCard(
                        context,
                        title: "Today's Earnings".tr,
                        value: Constant.amountShow(
                            amount: walletAmount.toString()),
                        icon: Icons.account_balance_wallet_rounded,
                        color: AppColors.qlypDeepNavy,
                      ),
                      const SizedBox(width: 12),
                      _buildPerformanceCard(
                        context,
                        title: "Rides".tr,
                        value: "12", // Placeholder for today's rides
                        icon: Icons.directions_car_rounded,
                        color: AppColors.qlypPrimaryFreshGreen,
                      ),
                      const SizedBox(width: 12),
                      _buildPerformanceCard(
                        context,
                        title: "Rating".tr,
                        value: rating.toStringAsFixed(1),
                        icon: Icons.star_rounded,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Available Requests Title
                  Text(
                    "AVAILABLE REQUESTS".tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white60 : Colors.black45,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(context, controller, 0, "New".tr),
                        _buildFilterChip(context, controller, 1, "Accepted".tr),
                        _buildFilterChip(context, controller, 2, "Active".tr),
                        _buildFilterChip(
                            context, controller, 3, "Completed".tr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Content based on selected filter
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                        minHeight: Responsive.height(40, context)),
                    child: controller.widgetOptions
                        .elementAt(controller.selectedIndex.value),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildPerformanceCard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    final bool isDark = Provider.of<DarkThemeProvider>(context).getThem();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: isDark ? Colors.white38 : Colors.black38,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, HomeController controller,
      int index, String label) {
    bool isSelected = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.selectedIndex.value = index,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.qlypPrimaryFreshGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.qlypPrimaryFreshGreen
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}




// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:provider/provider.dart';
//
// import '../../constant/constant.dart';
// import '../../controller/home_controller.dart';
// import '../../utils/DarkThemeProvider.dart';
// import '../../utils/fire_store_utils.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//
//     return GetX<HomeController>(
//       init: HomeController(),
//       dispose: (state) {
//         FireStoreUtils().closeStream();
//         // Clean up map controller + location stream if you want:
//         if (Get.isRegistered<_MapHelperController>()) {
//           Get.delete<_MapHelperController>();
//         }
//       },
//       builder: (controller) {
//         if (controller.isLoading.value || controller.driverModel.value.id == null) {
//           return Constant.loader(isDarkTheme: themeChange.getThem());
//         }
//
//         // helper controller only for map/location UI (doesn't change your business logic)
//         final mapHelper = Get.put(_MapHelperController(), permanent: true);
//
//         return Obx(() {
//           // If location isn't ready yet, show loader
//           if (mapHelper.currentLatLng.value == null) {
//             return Constant.loader(isDarkTheme: themeChange.getThem());
//           }
//
//           final current = mapHelper.currentLatLng.value!;
//           final markers = <Marker>{
//             // ✅ Marker at current location
//             Marker(
//               markerId: const MarkerId("current_location"),
//               position: current,
//               infoWindow: const InfoWindow(title: "Your current location"),
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//             ),
//
//             // ✅ Marker for selected location (tap)
//             if (mapHelper.selectedLatLng.value != null)
//               Marker(
//                 markerId: const MarkerId("selected_location"),
//                 position: mapHelper.selectedLatLng.value!,
//                 infoWindow: const InfoWindow(title: "Selected location"),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
//               ),
//           };
//
//           return GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: current,
//               zoom: 15,
//             ),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             mapToolbarEnabled: false,
//             compassEnabled: false,
//
//             markers: markers,
//
//             onMapCreated: (gController) {
//               mapHelper.setMapController(gController);
//
//               // ✅ jump camera to current location once map is ready
//               mapHelper.moveCamera(current, zoom: 15);
//             },
//
//             // ✅ User can select any location by tapping
//             onTap: (LatLng latLng) {
//               mapHelper.selectedLatLng.value = latLng;
//             },
//           );
//         });
//       },
//     );
//   }
// }
//
// /// Small helper controller to keep map/location state.
// /// (keeps your HomeController untouched)
// class _MapHelperController extends GetxController {
//   final Rxn<LatLng> currentLatLng = Rxn<LatLng>();
//   final Rxn<LatLng> selectedLatLng = Rxn<LatLng>();
//
//   GoogleMapController? _mapController;
//
//   final loc.Location _location = loc.Location();
//   StreamSubscription<loc.LocationData>? _sub;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initLocation();
//   }
//
//   void setMapController(GoogleMapController controller) {
//     _mapController = controller;
//   }
//
//   Future<void> moveCamera(LatLng target, {double zoom = 15}) async {
//     final c = _mapController;
//     if (c == null) return;
//     await c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: zoom)));
//   }
//
//   Future<void> _initLocation() async {
//     try {
//       // ✅ Service enabled?
//       bool serviceEnabled = await _location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await _location.requestService();
//         if (!serviceEnabled) return;
//       }
//
//       // ✅ Permission
//       loc.PermissionStatus permission = await _location.hasPermission();
//       if (permission == loc.PermissionStatus.denied) {
//         permission = await _location.requestPermission();
//         if (permission != loc.PermissionStatus.granted) return;
//       }
//
//       // ✅ Fetch once immediately (auto fetch current location)
//       final first = await _location.getLocation();
//       if (first.latitude != null && first.longitude != null) {
//         currentLatLng.value = LatLng(first.latitude!, first.longitude!);
//       }
//
//       // ✅ Keep updating current location (optional but useful)
//       _sub?.cancel();
//       _sub = _location.onLocationChanged.listen((loc.LocationData data) {
//         if (data.latitude == null || data.longitude == null) return;
//         currentLatLng.value = LatLng(data.latitude!, data.longitude!);
//       });
//     } catch (_) {
//       // If something fails, currentLatLng stays null -> loader remains
//     }
//   }
//
//   @override
//   void onClose() {
//     _sub?.cancel();
//     super.onClose();
//   }
// }

