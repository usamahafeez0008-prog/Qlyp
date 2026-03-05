import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/controller/home_controller.dart';
import 'package:driver/model/driver_user_model.dart';
import 'package:driver/model/order_model.dart';
import 'package:driver/model/service_model.dart';
import 'package:driver/model/user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/ui/home_screens/order_map_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<HomeController>(
        init: HomeController(),
        dispose: (state) {
          FireStoreUtils().closeStream();
        },
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader(isDarkTheme: themeChange.getThem())
              : controller.driverModel.value.isOnline == false
                  ? Center(
                      child: Text(
                          "You are Now offline so you can't get nearest order."
                              .tr),
                    )
                  : StreamBuilder<List<OrderModel>>(
                      stream: FireStoreUtils().getOrders(
                          controller.driverModel.value,
                          Constant.currentLocation?.latitude,
                          Constant.currentLocation?.longitude),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Constant.loader(
                              isDarkTheme: themeChange.getThem());
                        }
                        if (!snapshot.hasData ||
                            (snapshot.data?.isEmpty ?? true)) {
                          return Center(
                            child: Text("New Rides Not found".tr),
                          );
                        } else {
                          // ordersList = snapshot.data!;
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              OrderModel orderModel = snapshot.data![index];

                              DateTime currentTime = DateTime.now();
                              DateTime currentDate = DateTime.now();
                              DateTime startNightTimeString = DateTime.now();
                              DateTime endNightTimeString = DateTime.now();

                              double amount = 0.0;
                              double finalAmount = 0.0;
                              String startNightTime = "";
                              String endNightTime = "";
                              double totalChargeOfMinute = 0.0;
                              double basicFare = 0.0;

                              String formatTime(String? time) {
                                if (time == null || !time.contains(":")) {
                                  return "00:00";
                                }
                                List<String> parts = time.split(':');
                                if (parts.length != 2) return "00:00";
                                return "${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}";
                              }

                              String startNightTimeData =
                                  orderModel.service?.prices
                                          ?.firstWhere(
                                            (prices) =>
                                                prices.zoneId ==
                                                    orderModel.zoneId &&
                                                prices.startNightTime != null,
                                            orElse: () => Price(),
                                          )
                                          .startNightTime ??
                                      '0.0';
                              String endNightTimeData =
                                  orderModel.service?.prices
                                          ?.firstWhere(
                                            (prices) =>
                                                prices.zoneId ==
                                                    orderModel.zoneId &&
                                                prices.endNightTime != null,
                                            orElse: () => Price(),
                                          )
                                          .endNightTime ??
                                      '0.0';
                              startNightTime = formatTime(startNightTimeData);
                              endNightTime = formatTime(endNightTimeData);

                              List<String> startParts =
                                  startNightTime.split(':');
                              List<String> endParts = endNightTime.split(':');

                              startNightTimeString = DateTime(
                                  currentDate.year,
                                  currentDate.month,
                                  currentDate.day,
                                  int.parse(startParts[0]),
                                  int.parse(startParts[1]));
                              endNightTimeString = DateTime(
                                  currentDate.year,
                                  currentDate.month,
                                  currentDate.day,
                                  int.parse(endParts[0]),
                                  int.parse(endParts[1]));

                              double durationValueInMinutes = convertToMinutes(
                                  orderModel.duration.toString());
                              double distance = double.tryParse(
                                      orderModel.distance.toString()) ??
                                  0.0;
                              String onAcPerKmRateData = controller.driverModel
                                      .value.vehicleInformation?.rates
                                      ?.firstWhere(
                                        (prices) =>
                                            prices.zoneId ==
                                                orderModel.zoneId &&
                                            prices.nonAcPerKmRate != null,
                                        orElse: () => RateModel(),
                                      )
                                      .nonAcPerKmRate ??
                                  '0.0';
                              String acPerKmRateData = controller.driverModel
                                      .value.vehicleInformation?.rates
                                      ?.firstWhere(
                                        (prices) =>
                                            prices.zoneId ==
                                                orderModel.zoneId &&
                                            prices.acPerKmRate != null,
                                        orElse: () => RateModel(),
                                      )
                                      .acPerKmRate ??
                                  '0.0';
                              String perKmRateData = controller.driverModel
                                      .value.vehicleInformation?.rates
                                      ?.firstWhere(
                                        (prices) =>
                                            prices.zoneId ==
                                                orderModel.zoneId &&
                                            prices.perKmRate != null,
                                        orElse: () => RateModel(),
                                      )
                                      .perKmRate ??
                                  '0.0';
                              double nonAcChargeValue =
                                  double.tryParse(onAcPerKmRateData) ?? 0.0;
                              double acChargeValue =
                                  double.tryParse(acPerKmRateData) ?? 0.0;
                              double kmCharge =
                                  double.tryParse(perKmRateData) ?? 0.0;

                              totalChargeOfMinute = double.parse(
                                      durationValueInMinutes.toString()) *
                                  double.parse(orderModel.service?.prices?.first
                                          .perMinuteCharge ??
                                      '0.0');
                              basicFare = double.parse(orderModel
                                      .service?.prices?.first.basicFareCharge ??
                                  '0.0');

                              if (distance <=
                                  double.parse(orderModel
                                          .service?.prices?.first.basicFare ??
                                      '0.0')) {
                                if (currentTime.isAfter(startNightTimeString) &&
                                    currentTime.isBefore(endNightTimeString)) {
                                  amount = amount *
                                      double.parse(orderModel.service?.prices
                                              ?.first.nightCharge ??
                                          '0.0');
                                } else {
                                  amount = double.parse(orderModel.service
                                          ?.prices?.first.basicFareCharge ??
                                      '0.0');
                                }
                              } else {
                                double distanceValue = double.tryParse(
                                        orderModel.distance.toString()) ??
                                    0.0;
                                double basicFareValue = double.parse(orderModel
                                        .service?.prices?.first.basicFare ??
                                    '0.0');
                                double extraDist =
                                    distanceValue - basicFareValue;

                                double perKmCharge = orderModel
                                            .service?.prices?.first.isAcNonAc ==
                                        true
                                    ? orderModel.isAcSelected == false
                                        ? nonAcChargeValue
                                        : acChargeValue
                                    : kmCharge;
                                amount = (perKmCharge * extraDist);

                                if (currentTime.isAfter(startNightTimeString) &&
                                    currentTime.isBefore(endNightTimeString)) {
                                  amount = amount *
                                      double.parse(orderModel.service?.prices
                                              ?.first.nightCharge ??
                                          '0.0');
                                  totalChargeOfMinute = totalChargeOfMinute *
                                      double.parse(orderModel.service?.prices
                                              ?.first.nightCharge ??
                                          '0.0');
                                  basicFare = basicFare *
                                      double.parse(orderModel.service?.prices
                                              ?.first.nightCharge ??
                                          '0.0');
                                }
                              }

                              finalAmount =
                                  amount + basicFare + totalChargeOfMinute;

                              String displayPayout =
                                  orderModel.service!.offerRate == true
                                      ? finalAmount.toString()
                                      : (orderModel.offerRate ?? '0.0')
                                          .toString();

                              return _buildPremiumOrderCard(context, orderModel,
                                  themeChange.getThem(), displayPayout);
                            },
                          );
                        }
                      });
        });
  }

  Widget _buildPremiumOrderCard(BuildContext context, OrderModel order,
      bool isDark, String displayPayout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. User Info Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<UserModel?>(
              future: FireStoreUtils.getCustomer(order.userId.toString()),
              builder: (context, snapshot) {
                UserModel? user = snapshot.data;
                return Row(
                  children: [
                    // Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        height: 52,
                        width: 52,
                        imageUrl: user?.profilePic == null ||
                                user!.profilePic!.isEmpty
                            ? Constant.userPlaceHolder
                            : user.profilePic!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Constant.loader(isDarkTheme: isDark),
                        errorWidget: (context, url, error) =>
                            Image.network(Constant.userPlaceHolder),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Name & Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ??
                                (snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? "Loading...".tr
                                    : "Guest User".tr),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${Constant.calculateReview(reviewCount: user?.reviewsCount ?? "0.0", reviewSum: user?.reviewsSum ?? "0.0")} • ",
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  "Top Passenger".tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Payout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Constant.amountShow(amount: displayPayout),
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.qlypPrimaryFreshGreen,
                          ),
                        ),
                        Text(
                          "EST. PAYOUT".tr,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white24 : Colors.black26,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // 2. Location Timeline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildLocationRow(
                  label: "PICKUP".tr,
                  location: order.sourceLocationName ?? "Unknown".tr,
                  dotColor: AppColors.qlypDeepNavy,
                  showLine: true,
                ),
                _buildLocationRow(
                  label: "DROP-OFF".tr,
                  location: order.destinationLocationName ?? "Unknown".tr,
                  dotColor: AppColors.qlypPrimaryFreshGreen,
                  showLine: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const OrderMapScreen(),
                              arguments: {"orderModel": order.id.toString()})!
                          .then((value) {
                        if (value != null && value == true) {
                          // Handle acceptance or back
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.qlypPrimaryFreshGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Accept Request".tr,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    Get.to(const OrderMapScreen(),
                        arguments: {"orderModel": order.id.toString()});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.qlypDeepNavy,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.qlypDeepNavy.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.map_rounded,
                        color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required String label,
    required String location,
    required Color dotColor,
    bool showLine = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: 3),
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 35,
                color: const Color(0xFFE2E5EA),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: dotColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (showLine) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  double convertToMinutes(String duration) {
    double durationValue = 0.0;

    try {
      final RegExp hoursRegex = RegExp(r"(\d+)\s*hour");
      final RegExp minutesRegex = RegExp(r"(\d+)\s*min");

      final Match? hoursMatch = hoursRegex.firstMatch(duration);
      if (hoursMatch != null) {
        int hours = int.parse(hoursMatch.group(1)!.trim());
        durationValue += hours * 60;
      }

      final Match? minutesMatch = minutesRegex.firstMatch(duration);
      if (minutesMatch != null) {
        int minutes = int.parse(minutesMatch.group(1)!.trim());
        durationValue += minutes;
      }
    } catch (e) {
      print("Exception: $e");
      throw FormatException("Invalid duration format: $duration");
    }

    return durationValue;
  }
}
