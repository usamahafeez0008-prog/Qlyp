import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/order_map_controller.dart';
import 'package:driver/model/user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as location;

class OrderMapScreen extends StatelessWidget {
  const OrderMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<OrderMapController>(
        init: OrderMapController(),
        builder: (controller) {
          final isDark = themeChange.getThem();
          return Scaffold(
            backgroundColor: AppColors.qlypDeepNavy,
            body: controller.isLoading.value
                ? Constant.loader(isDarkTheme: isDark)
                : Column(
                    children: [
                      // 1. Premium Header
                      _buildHeader(context, isDark),
                      // 2. Content Area
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF121212)
                                : const Color(0xFFF8F9FB),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Info Card
                                _buildUserCard(controller, isDark),
                                const SizedBox(height: 24),

                                // Route Overview Label
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ROUTE OVERVIEW".tr.toUpperCase(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white38
                                            : Colors.black38,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.qlypPrimaryFreshGreen
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "FASTEST".tr.toUpperCase(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              AppColors.qlypPrimaryFreshGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Map Card
                                _buildMapSection(controller, isDark),
                                const SizedBox(height: 24),

                                // Location Details
                                _buildLocationTimeline(controller, isDark),
                                const SizedBox(height: 24),

                                // Bidding Section (if applicable)
                                if (controller
                                        .orderModel.value.service?.offerRate ==
                                    true)
                                  _buildBiddingControls(controller, isDark),

                                // Summary Grid
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSummaryCard(
                                        "DISTANCE".tr,
                                        "${controller.orderModel.value.distance} ${Constant.distanceType}",
                                        isDark,
                                        iconColor: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildSummaryCard(
                                        "EST. EARNINGS".tr,
                                        Constant.amountShow(
                                            amount: controller.finalAmount.value
                                                .toString()),
                                        isDark,
                                        valueColor:
                                            AppColors.qlypPrimaryFreshGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                // 3. Bottom Actions
                                _buildFooterActions(
                                    context, controller, isDark),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              "Ride Request Details".tr,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(OrderMapController controller, bool isDark) {
    UserModel user = controller.usermodel.value;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  imageUrl: user.profilePic ?? Constant.userPlaceHolder,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.network(Constant.userPlaceHolder),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.qlypPrimaryFreshGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? "Guest User".tr,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${Constant.calculateReview(reviewCount: user.reviewsCount, reviewSum: user.reviewsSum)} Rating"
                          .tr,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.chat_bubble_outline_rounded,
                color: isDark ? Colors.white70 : Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(OrderMapController controller, bool isDark) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.03)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Constant.selectedMapType == 'osm'
            ? flutterMap.FlutterMap(
                mapController: controller.osmMapController,
                options: flutterMap.MapOptions(
                  initialCenter: location.LatLng(
                      Constant.currentLocation?.latitude ?? 45.521563,
                      Constant.currentLocation?.longitude ?? -122.677433),
                  initialZoom: 10,
                  maxZoom: 19,
                  minZoom: 3,
                ),
                children: [
                  flutterMap.TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.codesteem.qlyp_driver',
                    maxZoom: 19,
                  ),
                  flutterMap.MarkerLayer(
                    markers: [
                      flutterMap.Marker(
                        point: controller.source.value,
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/pickup.png'),
                      ),
                      flutterMap.Marker(
                        point: controller.destination.value,
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/dropoff.png'),
                      ),
                    ],
                  ),
                  if (controller.routePoints.isNotEmpty)
                    flutterMap.PolylineLayer(
                      polylines: [
                        flutterMap.Polyline(
                          points: controller.routePoints,
                          strokeWidth: 4.0,
                          color: AppColors.qlypPrimaryFreshGreen,
                        ),
                      ],
                    ),
                ],
              )
            : GoogleMap(
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.terrain,
                zoomControlsEnabled: false,
                polylines: Set<Polyline>.of(controller.polyLines.values),
                markers: Set<Marker>.of(controller.markers.values),
                onMapCreated: (GoogleMapController mapController) {
                  controller.mapController.complete(mapController);
                },
                initialCameraPosition: CameraPosition(
                  zoom: 15,
                  target: LatLng(Constant.currentLocation?.latitude ?? 0.0,
                      Constant.currentLocation?.longitude ?? 0.0),
                ),
              ),
      ),
    );
  }

  Widget _buildLocationTimeline(OrderMapController controller, bool isDark) {
    return Column(
      children: [
        _buildLocationRow(
          controller.orderModel.value.sourceLocationName.toString(),
          "Pickup".tr,
          AppColors.qlypPrimaryFreshGreen,
          isDark,
          showLine: true,
        ),
        _buildLocationRow(
          controller.orderModel.value.destinationLocationName.toString(),
          "Drop-off".tr,
          Colors.redAccent,
          isDark,
          showLine: false,
        ),
      ],
    );
  }

  Widget _buildLocationRow(
      String address, String label, Color color, bool isDark,
      {bool showLine = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ),
            ),
            if (showLine)
              Container(
                width: 1,
                height: 40,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBiddingControls(OrderMapController controller, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  controller.amount.value = controller.amount.value - 10;
                  controller.finalAmount.value =
                      controller.finalAmount.value - 10;
                  controller.enterOfferRateController.value.text = controller
                      .amount.value
                      .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: isDark ? Colors.white24 : Colors.black12),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.remove, size: 20),
                ),
              ),
              Column(
                children: [
                  Text(
                    "YOUR BID".tr,
                    style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Text(
                    Constant.amountShow(
                        amount: controller.amount.value.toString()),
                    style: GoogleFonts.outfit(
                        fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  controller.amount.value = controller.amount.value + 10;
                  controller.finalAmount.value =
                      controller.finalAmount.value + 10;
                  controller.enterOfferRateController.value.text = controller
                      .amount.value
                      .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.qlypPrimaryFreshGreen,
                      shape: BoxShape.circle),
                  child: const Icon(Icons.add, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Base Fare: ${Constant.amountShow(amount: controller.basicFare.value.toString())} + ETA/Min Charges"
                .tr,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, bool isDark,
      {Color valueColor = Colors.black, Color iconColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: valueColor == AppColors.qlypPrimaryFreshGreen
              ? AppColors.qlypPrimaryFreshGreen.withOpacity(0.2)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white38 : Colors.black38,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? (valueColor == Colors.black ? Colors.white : valueColor)
                  : valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions(
      BuildContext context, OrderMapController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      // decoration: BoxDecoration(
      //   color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      //   border: Border(
      //       top: BorderSide(
      //           color: isDark ? Colors.white10 : Colors.black12, width: 0.5)),
      // ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Decline".tr,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () async {
                if (double.parse(controller.amount.value.toString()) > 0) {
                  controller.acceptOrder();
                } else {
                  ShowToastDialog.showToast(
                      "Please enter a valid offer rate".tr);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.qlypPrimaryFreshGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.qlypPrimaryFreshGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      "Accept Ride".tr,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
