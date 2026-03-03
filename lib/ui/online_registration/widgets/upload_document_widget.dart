import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controller/details_upload_controller.dart';
import 'package:driver/model/document_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UploadDocumentWidget extends StatelessWidget {
  final DocumentModel documentModel;
  const UploadDocumentWidget({super.key, required this.documentModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<DetailsUploadController>(
        init: DetailsUploadController(),
        initState: (state) {
          state.controller?.documentModel.value = documentModel;
          state.controller?.getDocument();
        },
        dispose: (state) {
          Get.delete<DetailsUploadController>();
        },
        builder: (controller) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  title: Text(
                    Constant.localizationTitle(documentModel.title),
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Flexible(
                  child: controller.isLoading.value
                      ? Constant.loader(isDarkTheme: themeChange.getThem())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!Constant.localizationTitle(
                                      documentModel.title)
                                  .toLowerCase()
                                  .contains("profile")) ...[
                                const SizedBox(height: 10),
                                Text(
                                  "Document Number".tr,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.qlypCharcoal),
                                ),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  context,
                                  hintText: "Enter document number".tr,
                                  controller:
                                      controller.documentNumberController.value,
                                ),
                              ],
                              if (controller.documentModel.value.expireAt ==
                                  true) ...[
                                const SizedBox(height: 16),
                                Text(
                                  "Expiry Date".tr,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () async {
                                    await Constant.selectFetureDate(context)
                                        .then((value) {
                                      if (value != null) {
                                        controller.selectedDate.value = value;
                                        controller
                                                .expireAtController.value.text =
                                            DateFormat("dd-MM-yyyy")
                                                .format(value);
                                      }
                                    });
                                  },
                                  child: _buildTextField(
                                    context,
                                    hintText: "Select Expire date".tr,
                                    controller:
                                        controller.expireAtController.value,
                                    enable: false,
                                    suffixIcon: const Icon(Icons.calendar_month,
                                        color: Color(0xff838EA1)),
                                  ),
                                ),
                              ],
                              if (controller.documentModel.value.frontSide ==
                                  true) ...[
                                const SizedBox(height: 20),
                                Text("Front Side".tr,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                const SizedBox(height: 8),
                                _buildImagePicker(context, controller, "front",
                                    themeChange.getThem()),
                              ],
                              if (controller.documentModel.value.backSide ==
                                  true) ...[
                                const SizedBox(height: 20),
                                Text("Back Side".tr,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                const SizedBox(height: 8),
                                _buildImagePicker(context, controller, "back",
                                    themeChange.getThem()),
                              ],
                              const SizedBox(height: 32),
                              if (controller.documents.value.verified != true)
                                SafeArea(
                                  top: false,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!Constant.localizationTitle(
                                                    documentModel.title)
                                                .toLowerCase()
                                                .contains("profile") &&
                                            controller.documentNumberController
                                                .value.text.isEmpty) {
                                          ShowToastDialog.showToast(
                                              "Please enter document number"
                                                  .tr);
                                        } else {
                                          if (controller.documentModel.value
                                                      .frontSide ==
                                                  true &&
                                              controller
                                                  .frontImage.value.isEmpty) {
                                            ShowToastDialog.showToast(
                                                "Please upload front side of document."
                                                    .tr);
                                          } else if (controller.documentModel
                                                      .value.backSide ==
                                                  true &&
                                              controller
                                                  .backImage.value.isEmpty) {
                                            ShowToastDialog.showToast(
                                                "Please upload back side of document."
                                                    .tr);
                                          } else {
                                            ShowToastDialog.showLoader(
                                                "Please wait..".tr);
                                            controller.uploadDocument();
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        backgroundColor:
                                            const Color(0xff12223b),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        "Done".tr,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTextField(BuildContext context,
      {required String hintText,
      required TextEditingController controller,
      bool enable = true,
      Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      enabled: enable,
      style: GoogleFonts.poppins(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: const Color(0xff838EA1)),
        filled: true,
        fillColor: const Color(0xffF5F6F6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff12223b), width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context,
      DetailsUploadController controller, String type, bool isDark) {
    String imagePath = type == "front"
        ? controller.frontImage.value
        : controller.backImage.value;

    return InkWell(
      onTap: () {
        if (controller.documents.value.verified != true) {
          _buildBottomSheet(context, controller, type);
        }
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE2E5EA)),
        ),
        child: imagePath.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Constant().hasValidUrl(imagePath) == false
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Constant.loader(isDarkTheme: isDark),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              )
            : DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: const Radius.circular(11),
                  dashPattern: const [6, 6],
                  color: const Color(0xff838EA1),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined,
                          color: Color(0xff838EA1), size: 30),
                      const SizedBox(height: 8),
                      Text("Add photo".tr,
                          style: GoogleFonts.poppins(
                              color: const Color(0xff838EA1))),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _buildBottomSheet(
      BuildContext context, DetailsUploadController controller, String type) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 200,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Please Select".tr,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      icon: Icons.camera_alt,
                      label: "Camera".tr,
                      onTap: () {
                        Get.back();
                        controller.pickFile(
                            source: ImageSource.camera, type: type);
                      },
                    ),
                    _buildOption(
                      icon: Icons.photo_library,
                      label: "Gallery".tr,
                      onTap: () {
                        Get.back();
                        controller.pickFile(
                            source: ImageSource.gallery, type: type);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildOption(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffF5F6F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black)),
        ],
      ),
    );
  }
}
