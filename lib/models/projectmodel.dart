// To parse this JSON data, do
//
//     final addprojectmodel = addprojectmodelFromJson(jsonString);

import 'dart:convert';

Addprojectmodel addprojectmodelFromJson(String str) => Addprojectmodel.fromJson(json.decode(str));

String addprojectmodelToJson(Addprojectmodel data) => json.encode(data.toJson());

class Addprojectmodel {
  Addprojectmodel({
    this.data,
    this.message,
    this.success,
    this.authorized,
  });

  Data ?data;
  String? message;
  bool ?success;
  bool? authorized;

  factory Addprojectmodel.fromJson(Map<String, dynamic> json) => Addprojectmodel(
    data: Data.fromJson(json["Data"]),
    message: json["Message"],
    success: json["Success"],
    authorized: json["Authorized"],
  );

  Map<String, dynamic> toJson() => {
    "Data": data!.toJson(),
    "Message": message,
    "Success": success,
    "Authorized": authorized,
  };
}

class Data {
  Data({
    this.projectInfo,
    this.workTypes,
    this.workTypesCategories,
    this.buildingTypes,
    this.dwgNumebers,
    this.currentConsultants,
  });

  ProjectInfo? projectInfo;
  List<CurrentConsultant>? workTypes;
  List<WorkTypesCategory> ?workTypesCategories;
  List<BuildingType>? buildingTypes;
  List<DwgNumeber> ?dwgNumebers;
  List<CurrentConsultant>? currentConsultants;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    projectInfo: ProjectInfo.fromJson(json["ProjectInfo"]),
    workTypes: List<CurrentConsultant>.from(json["WorkTypes"].map((x) => CurrentConsultant.fromJson(x))),
    workTypesCategories: List<WorkTypesCategory>.from(json["WorkTypesCategories"].map((x) => WorkTypesCategory.fromJson(x))),
    buildingTypes: List<BuildingType>.from(json["BuildingTypes"].map((x) => BuildingType.fromJson(x))),
    dwgNumebers: List<DwgNumeber>.from(json["DWGNumebers"].map((x) => DwgNumeber.fromJson(x))),
    currentConsultants: List<CurrentConsultant>.from(json["CurrentConsultants"].map((x) => CurrentConsultant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ProjectInfo": projectInfo!.toJson(),
    "WorkTypes": List<dynamic>.from(workTypes!.map((x) => x.toJson())),
    "WorkTypesCategories": List<dynamic>.from(workTypesCategories!.map((x) => x.toJson())),
    "BuildingTypes": List<dynamic>.from(buildingTypes!.map((x) => x.toJson())),
    "DWGNumebers": List<dynamic>.from(dwgNumebers!.map((x) => x.toJson())),
    "CurrentConsultants": List<dynamic>.from(currentConsultants!.map((x) => x.toJson())),
  };
}

class BuildingType {
  BuildingType({
    this.availableFloors,
    this.id,
    this.category,
  });

  List<AvailableFloor> ?availableFloors;
  int ?id;
  CurrentConsultant ?category;

  factory BuildingType.fromJson(Map<String, dynamic> json) => BuildingType(
    availableFloors: List<AvailableFloor>.from(json["AvailableFloors"].map((x) => AvailableFloor.fromJson(x))),
    id: json["Id"],
    category: CurrentConsultant.fromJson(json["Category"]),
  );

  Map<String, dynamic> toJson() => {
    "AvailableFloors": List<dynamic>.from(availableFloors!.map((x) => x.toJson())),
    "Id": id,
    "Category": category!.toJson(),
  };
}

class AvailableFloor {
  AvailableFloor({
    this.id,
    this.category,
  });

  int ?id;
  CurrentConsultant? category;

  factory AvailableFloor.fromJson(Map<String, dynamic> json) => AvailableFloor(
    id: json["Id"],
    category: CurrentConsultant.fromJson(json["Category"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Category": category!.toJson(),
  };
}

class CurrentConsultant {
  CurrentConsultant({
    this.id,
    this.name,
  });

  int? id;
  String ?name;

  factory CurrentConsultant.fromJson(Map<String, dynamic> json) => CurrentConsultant(
    id: json["Id"],
    name: json["Name"] == null ? null : json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name == null ? null : name,
  };
}

class DwgNumeber {
  DwgNumeber({
    this.parentId,
    this.parentName,
    this.childs,
  });

  int ?parentId;
  String? parentName;
  List<AvailableFloor>? childs;

  factory DwgNumeber.fromJson(Map<String, dynamic> json) => DwgNumeber(
    parentId: json["ParentId"],
    parentName: json["ParentName"],
    childs: List<AvailableFloor>.from(json["Childs"].map((x) => AvailableFloor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ParentId": parentId,
    "ParentName": parentName,
    "Childs": List<dynamic>.from(childs!.map((x) => x.toJson())),
  };
}

class ProjectInfo {
  ProjectInfo({
    this.id,
    this.sks,
    this.name,
    this.consultantName,
    this.clientName,
    this.contractorName,
    this.startDate,
    this.endDate,
    this.location,
    this.locationPin,
    this.from,
    this.to,
  });

  int ?id;
  String ?sks;
  String ?name;
  String ?consultantName;
  String ?clientName;
  String ?contractorName;
  String ?startDate;
  String ?endDate;
  String? location;
  String? locationPin;
  String ?from;
  String? to;

  factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
    id: json["Id"],
    sks: json["SKS"],
    name: json["Name"],
    consultantName: json["ConsultantName"],
    clientName: json["ClientName"],
    contractorName: json["ContractorName"],
    startDate: json["StartDate"],
    endDate: json["EndDate"],
    location: json["Location"],
    locationPin: json["Location_Pin"],
    from: json["From"],
    to: json["To"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "SKS": sks,
    "Name": name,
    "ConsultantName": consultantName,
    "ClientName": clientName,
    "ContractorName": contractorName,
    "StartDate": startDate,
    "EndDate": endDate,
    "Location": location,
    "Location_Pin": locationPin,
    "From": from,
    "To": to,
  };
}

class WorkTypesCategory {
  WorkTypesCategory({
    this.parent,
    this.childs,
    this.id,
    this.name,
  });

  CurrentConsultant? parent;
  List<CurrentConsultant>? childs;
  int ?id;
  String ?name;

  factory WorkTypesCategory.fromJson(Map<String, dynamic> json) => WorkTypesCategory(
    parent: CurrentConsultant.fromJson(json["Parent"]),
    childs: List<CurrentConsultant>.from(json["Childs"].map((x) => CurrentConsultant.fromJson(x))),
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Parent": parent!.toJson(),
    "Childs": List<dynamic>.from(childs!.map((x) => x.toJson())),
    "Id": id,
    "Name": name,
  };
}
