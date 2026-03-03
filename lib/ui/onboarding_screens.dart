import 'package:driver/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// removed unused imports
import 'package:driver/ui/auth_screen/login_screen.dart';
import 'package:driver/utils/Preferences.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Get Best Reviews",
      "description":
          "The feedback thus lets you improve if you need any, allowing you to do better in your work.",
      "image": "assets/images/intro_qlyp_1.png",
    },
    {
      "title": "Work Flexibility - Go Online Whenever You Want",
      "description":
          "Go Online and take up Rides whenever you feel like it. No complain!",
      "image": "assets/images/intro_qlyp_2.png",
    },
    {
      "title": "Make Easy Income",
      "description":
          "A smarter way to earn money at your convenience. Turn your spare time into earnings with this Driver app & keep track of your earnings.",
      "image": "assets/images/intro_qlyp_3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TOP NAV BAR MATCHING SCREENSHOTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "QLYP ",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: "Pilote",
                          style: GoogleFonts.poppins(
                            color: AppColors.qlypPrimaryFreshGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // EN button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.qlypPrimaryFreshGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "EN",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // USD button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.qlypPrimaryFreshGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "USD",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PAGE VIEW FOR IMAGES AND TEXT
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stack image with "Uber->" circle if required
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              _onboardingData[index]["image"]!,
                              height: 280,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 100, color: Colors.grey),
                            ),
                            // Positioned(
                            //   right: -10,
                            //   top: 20,
                            //   child: Container(
                            //     padding: const EdgeInsets.all(16),
                            //     decoration: const BoxDecoration(
                            //       color: Color(0xff333333),
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         Text(
                            //           "Uber",
                            //           style: GoogleFonts.poppins(
                            //             color: Colors.white,
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.w600,
                            //           ),
                            //         ),
                            //         const Icon(Icons.arrow_forward,
                            //             color: Colors.white, size: 16),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 50),

                        // Default Text if hardcoded map is used OR we can use Firestore data.
                        Text(
                          _onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.qlypCharcoal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff838EA1),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // BOTTOM BAR (Indicator dots + Arrow Button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicator Dashes
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) {
                        int activeIdx = _currentIndex;
                        bool isActive = index == activeIdx;
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          height: 4,
                          width: 24,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.qlypPrimaryFreshGreen
                                : const Color(0xffE2E5EA),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      },
                    ),
                  ),

                  // Next Arrow Button
                  InkWell(
                    onTap: () {
                      if (_currentIndex == _onboardingData.length - 1) {
                        // Change Here to "True" Finish Onboarding
                        Preferences.setBoolean(
                            Preferences.isFinishOnBoardingKey, true);
                        Get.offAll(() => const LoginScreen());
                      } else {
                        // Next Page
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.qlypPrimaryFreshGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
