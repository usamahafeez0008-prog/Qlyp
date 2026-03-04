import 'package:driver/model/language_name.dart';

class VehicleTypeModel {
  bool? enable;
  List<LanguageName>? name;
  String? id;
  String? image;
  String? serviceID;

  VehicleTypeModel(
      {this.enable, this.name, this.id, this.image, this.serviceID});

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    if (json['name'] != null) {
      name = <LanguageName>[];
      json['name'].forEach((v) {
        name!.add(LanguageName.fromJson(v));
      });
    }
    id = json['id'];
    image = json['image'];
    serviceID = json['serviceID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    if (name != null) {
      data['name'] = name!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['image'] = image;
    data['serviceID'] = serviceID;
    return data;
  }
}
