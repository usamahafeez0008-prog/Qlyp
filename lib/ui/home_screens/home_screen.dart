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
                  // Section Title: YOUR PERFORMANCE
                  Text(
                    "YOUR PERFORMANCE".tr,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white54 : Colors.black45,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Today's Earnings Card (Full Width)
                  _buildEarningsCard(
                    context,
                    value: Constant.amountShow(amount: walletAmount.toString()),
                    trend: "+12%",
                  ),
                  const SizedBox(height: 12),

                  // Rides and Rating (Side by Side)
                  Row(
                    children: [
                      _buildPerformanceCard(
                        context,
                        title: "Rides".tr,
                        value: "14",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: const LinearProgressIndicator(
                            value: 0.7,
                            minHeight: 4,
                            backgroundColor: Color(0xFFE2E5EA),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.qlypPrimaryFreshGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildPerformanceCard(
                        context,
                        title: "Rating".tr,
                        value: rating.toStringAsFixed(1),
                        showStar: true,
                        subText: "LATEST 500 RIDES".tr,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Available Requests Title with Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AVAILABLE REQUESTS".tr,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white60 : Colors.black45,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              AppColors.qlypPrimaryFreshGreen.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        // child: Text(
                        //   "3 NEW".tr,
                        //   style: GoogleFonts.outfit(
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.w800,
                        //     color: AppColors.qlypPrimaryFreshGreen,
                        //   ),
                        // ),
                      ),
                    ],
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

  Widget _buildEarningsCard(BuildContext context,
      {required String value, required String trend}) {
    final bool isDark = Provider.of<DarkThemeProvider>(context).getThem();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ?  Colors.black  : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Earnings".tr,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.trending_up_rounded,
                          color: AppColors.qlypPrimaryFreshGreen, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        trend,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.qlypPrimaryFreshGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.qlypPrimaryFreshGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.payments_rounded,
                color: AppColors.qlypPrimaryFreshGreen,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context,
      {required String title,
      required String value,
      Widget? child,
      bool showStar = false,
      String? subText}) {
    final bool isDark = Provider.of<DarkThemeProvider>(context).getThem();
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (showStar) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                ]
              ],
            ),
            const Spacer(),
            if (child != null) child,
            if (subText != null)
              Text(
                subText,
                style: GoogleFonts.outfit(
                  fontSize: 9,
                  color: isDark ? Colors.white24 : Colors.black26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
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
    final bool isDark = Provider.of<DarkThemeProvider>(context).getThem();

    return GestureDetector(
      onTap: () => controller.selectedIndex.value = index,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.qlypPrimaryFreshGreen
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.qlypPrimaryFreshGreen
                : (isDark ? Colors.white12 : const Color(0xFFE2E5EA)),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.qlypPrimaryFreshGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label.tr,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
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

