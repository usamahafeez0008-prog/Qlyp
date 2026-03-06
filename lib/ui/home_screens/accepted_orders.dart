import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/controller/accepted_orders_controller.dart';
import 'package:driver/model/order/driverId_accept_reject.dart';
import 'package:driver/model/order_model.dart';
import 'package:driver/model/user_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AcceptedOrders extends StatelessWidget {
  const AcceptedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetBuilder<AcceptedOrdersController>(
        init: AcceptedOrdersController(),
        dispose: (state) {
          FireStoreUtils().closeStream();
        },
        builder: (controller) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(CollectionName.orders)
                .where('acceptedDriverId',
                    arrayContains: FireStoreUtils.getCurrentUid())
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong'.tr);
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Constant.loader(isDarkTheme: themeChange.getThem());
              }
              return snapshot.data!.docs.isEmpty
                  ? Center(
                      child: Text("No accepted ride found".tr),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemBuilder: (context, index) {
                        OrderModel orderModel = OrderModel.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return _buildAcceptedOrderCard(
                            context, orderModel, themeChange.getThem());
                      });
            },
          );
        });
  }

  Widget _buildAcceptedOrderCard(
      BuildContext context, OrderModel order, bool isDark) {
    return FutureBuilder<DriverIdAcceptReject?>(
      future: FireStoreUtils.getAcceptedOrders(
          order.id.toString(), FireStoreUtils.getCurrentUid()),
      builder: (context, snapshot) {
        String displayPayout = "0.0";
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          displayPayout = snapshot.data!.offerAmount.toString();
        }

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
                  builder: (context, userSnapshot) {
                    UserModel? user = userSnapshot.data;
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
                                    (userSnapshot.connectionState ==
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
                            snapshot.connectionState == ConnectionState.waiting
                                ? Constant.loader(isDarkTheme: isDark)
                                : Text(
                                    Constant.amountShow(amount: displayPayout),
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.qlypPrimaryFreshGreen,
                                    ),
                                  ),
                            Text(
                              "OFFER RATE".tr,
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
                      isDark: isDark,
                    ),
                    _buildLocationRow(
                      label: "DROP-OFF".tr,
                      location: order.destinationLocationName ?? "Unknown".tr,
                      dotColor: AppColors.qlypPrimaryFreshGreen,
                      showLine: false,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationRow({
    required String label,
    required String location,
    required Color dotColor,
    bool showLine = false,
    required bool isDark,
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
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              if (showLine) const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
