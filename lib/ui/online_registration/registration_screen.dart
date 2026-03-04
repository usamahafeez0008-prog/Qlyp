import 'package:driver/constant/constant.dart';
import 'package:driver/controller/online_registration_controller.dart';
import 'package:driver/model/document_model.dart';
import 'package:driver/model/driver_document_model.dart';
import 'package:driver/ui/online_registration/widgets/upload_document_widget.dart';
import 'package:driver/ui/vehicle_information/vehicle_information_screen.dart';
import 'package:driver/utils/DarkThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  void _showUploadPopup(BuildContext context, DocumentModel documentModel,
      OnlineRegistrationController controller) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) =>
              UploadDocumentWidget(documentModel: documentModel),
        ),
      ),
    );
    // Refresh the registration screen after upload
    controller.getDocument();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetBuilder<OnlineRegistrationController>(
        init: OnlineRegistrationController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Driver Documents',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 20),
                onPressed: () => Get.back(),
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Help',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff1A5D8A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader(isDarkTheme: themeChange.getThem())
                : SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'STEP 1 OF 3',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xff838EA1),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    Text(
                                      '20% Complete',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xff25BA58),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: const LinearProgressIndicator(
                                    value: 0.2, // matching the 20% complete
                                    minHeight: 6,
                                    backgroundColor: Color(0xffE2E5EA),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xff25BA58)),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  "Complete Your Profile",
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "To start driving in QLYP, we need a few legal documents for verification.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xff838EA1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.documentList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    DocumentModel documentModel =
                                        controller.documentList[index];
                                    Documents documents = Documents();

                                    var contain = controller.driverDocumentList
                                        .where((element) =>
                                            element.documentId ==
                                            documentModel.id);
                                    if (contain.isNotEmpty) {
                                      documents = controller.driverDocumentList
                                          .firstWhere((itemToCheck) =>
                                              itemToCheck.documentId ==
                                              documentModel.id);
                                    }

                                    bool isUploaded =
                                        (documents.documentId != null &&
                                            (documents.verified == true ||
                                                (documents.frontImage != null &&
                                                    documents.frontImage!
                                                        .isNotEmpty)));

                                    String title = Constant.localizationTitle(
                                        documentModel.title);
                                    String lowerTitle = title.toLowerCase();

                                    return _buildDocumentCard(
                                      context: context,
                                      title: title,
                                      documentModel: documentModel,
                                      isUploaded: isUploaded,
                                      lowerTitle: lowerTitle,
                                      controller: controller,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.info_outline,
                                        color: Color(0xff838EA1), size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Verification typically takes 24-48 hours. Ensure all edges of the documents are visible and text is legible to avoid delays.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: const Color(0xff838EA1),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            top: false,
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      side: const BorderSide(
                                          color: Color(0xffE2E5EA)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Back",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() =>
                                          const VehicleInformationScreen());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      backgroundColor: const Color(0xff12223b),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Continue",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
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
                  ),
          );
        });
  }

  Widget _buildDocumentCard({
    required BuildContext context,
    required String title,
    required DocumentModel documentModel,
    required bool isUploaded,
    required String lowerTitle,
    required OnlineRegistrationController controller,
  }) {
    IconData icon = Icons.description;
    if (lowerTitle.contains('license') || lowerTitle.contains('permis')) {
      icon = Icons.badge;
    } else if (lowerTitle.contains('insurance') ||
        lowerTitle.contains('assurance')) {
      icon = Icons.text_snippet;
    } else if (lowerTitle.contains('photo')) {
      icon = Icons.account_circle;
    } else if (lowerTitle.contains('registration') ||
        lowerTitle.contains('immatriculation')) {
      icon = Icons.receipt;
    }

    String subtitleText = "";
    if (lowerTitle.contains('license') || lowerTitle.contains('permis')) {
      subtitleText = "Class 4C required for Quebec";
    }
    if (lowerTitle.contains('insurance') || lowerTitle.contains('assurance')) {
      subtitleText = "Policy must be active and in your name";
    }
    if (lowerTitle.contains('photo')) {
      subtitleText = "Clear face photo, no sunglasses";
    }
    if (lowerTitle.contains('registration') ||
        lowerTitle.contains('immatriculation')) {
      subtitleText = "Quebec SAAQ Registration (V-1)";
    }

    bool isRequired = true;
    if (lowerTitle.contains('registration') ||
        lowerTitle.contains('immatriculation')) {
      isRequired = false;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF5F6F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffE6F7EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: const Color(0xff25BA58), size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    if (subtitleText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitleText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xff838EA1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isRequired ? const Color(0xffE6F7EB) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isRequired ? "REQUIRED" : "OPTIONAL",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isRequired
                        ? const Color(0xff25BA58)
                        : const Color(0xff838EA1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Actions
          if (isUploaded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xffE6F7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: Color(0xff25BA58), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Uploaded",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff25BA58),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      _showUploadPopup(context, documentModel, controller);
                    },
                    child: Text(
                      "Edit",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff838EA1),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (lowerTitle.contains('insurance') ||
              lowerTitle.contains('assurance'))
            InkWell(
              onTap: () {
                _showUploadPopup(context, documentModel, controller);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xffE2E5EA), width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined,
                        color: Color(0xff838EA1), size: 24),
                    const SizedBox(height: 8),
                    Text(
                      "Click to upload",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "JPG, PNG or PDF (Max 5MB)",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xff838EA1),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (lowerTitle.contains('photo'))
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showUploadPopup(context, documentModel, controller);
                },
                icon: const Icon(Icons.camera_alt_outlined,
                    color: Colors.black, size: 20),
                label: Text(
                  "Take Photo",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xffE2E5EA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showUploadPopup(context, documentModel, controller);
                },
                icon: const Icon(Icons.upload_file,
                    color: Colors.black, size: 20),
                label: Text(
                  "Upload Document",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xffE2E5EA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
