class BankDetailsModel {
  String? userId;
  String? bankName;
  String? holderName;
  String? branchName;
  String? transitNumber;
  String? accountNumber;
  String? otherInformation;
  String? payoutFrequency;

  BankDetailsModel(
      {this.userId,
      this.bankName,
        this.holderName,
        this.branchName,
        this.accountNumber,
        this.otherInformation, this.payoutFrequency, this.transitNumber});

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    bankName = json['bankName'];
    holderName = json['holderName'];
    branchName = json['branchName'];
    accountNumber = json['accountNumber'];
    otherInformation = json['otherInformation'];
    payoutFrequency = json['payoutFrequency'];
    transitNumber = json['transitNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['bankName'] = bankName;
    data['holderName'] = holderName;
    data['branchName'] = branchName;
    data['accountNumber'] = accountNumber;
    data['otherInformation'] = otherInformation;
    data['payoutFrequency'] = payoutFrequency;
    data['transitNumber'] = transitNumber;
    return data;
  }
}
