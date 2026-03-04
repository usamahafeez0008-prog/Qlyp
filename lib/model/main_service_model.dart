class MainServiceModel {
  String? mainServiceID;
  String? serviceName;

  MainServiceModel({this.mainServiceID, this.serviceName});

  MainServiceModel.fromJson(Map<String, dynamic> json) {
    mainServiceID = json['mainServiceID'] ?? json['id'];
    serviceName = json['serviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainServiceID'] = mainServiceID;
    data['serviceName'] = serviceName;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainServiceModel &&
          runtimeType == other.runtimeType &&
          mainServiceID == other.mainServiceID;

  @override
  int get hashCode => mainServiceID.hashCode;
}
