// To parse this JSON data, do
//
//     final concreteOrdermodel = concreteOrdermodelFromJson(jsonString);

import 'dart:convert';

ConcreteOrdermodel concreteOrdermodelFromJson(String str) => ConcreteOrdermodel.fromJson(json.decode(str));

String concreteOrdermodelToJson(ConcreteOrdermodel data) => json.encode(data.toJson());

class ConcreteOrdermodel {
  ConcreteOrdermodel({
    this.data,
    this.message,
    this.success,
    this.authorized,
  });

  Data ?data;
  String? message;
  bool ?success;
  bool ?authorized;

  factory ConcreteOrdermodel.fromJson(Map<String, dynamic> json) => ConcreteOrdermodel(
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
    this.approvedInspections,
    this.castingTypesCategories,
    this.buildingTypes,
    this.concreteGradeTypes,
    this.cementTypes,
  });

  ProjectInfo? projectInfo;
  List<ApprovedInspection>? approvedInspections;
  dynamic castingTypesCategories;
  dynamic buildingTypes;
  List<Type>? concreteGradeTypes;
  List<Type> ?cementTypes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    projectInfo: ProjectInfo.fromJson(json["ProjectInfo"]),
    approvedInspections: List<ApprovedInspection>.from(json["ApprovedInspections"].map((x) => ApprovedInspection.fromJson(x))),
    castingTypesCategories: json["CastingTypesCategories"],
    buildingTypes: json["BuildingTypes"],
    concreteGradeTypes: List<Type>.from(json["ConcreteGradeTypes"].map((x) => Type.fromJson(x))),
    cementTypes: List<Type>.from(json["CementTypes"].map((x) => Type.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ProjectInfo": projectInfo!.toJson(),
    "ApprovedInspections": List<dynamic>.from(approvedInspections!.map((x) => x.toJson())),
    "CastingTypesCategories": castingTypesCategories,
    "BuildingTypes": buildingTypes,
    "ConcreteGradeTypes": List<dynamic>.from(concreteGradeTypes!.map((x) => x.toJson())),
    "CementTypes": List<dynamic>.from(cementTypes!.map((x) => x.toJson())),
  };
}

class ApprovedInspection {
  ApprovedInspection({
    this.castingDescription,
    this.code,
    this.buildingType,
    this.id,
    this.name,
  });

  String ?castingDescription;
  String? code;
  BuildingType ?buildingType;
  int ?id;
  String ?name;

  factory ApprovedInspection.fromJson(Map<String, dynamic> json) => ApprovedInspection(
    castingDescription: json["CastingDescription"],
    code: json["Code"],
    buildingType: BuildingType.fromJson(json["BuildingType"]),
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "CastingDescription": castingDescription,
    "Code": code,
    "BuildingType": buildingType!.toJson(),
    "Id": id,
    "Name": name,
  };
}

class BuildingType {
  BuildingType({
    this.categoryId,
    this.id,
    this.name,
  });

  int ?categoryId;
  int ?id;
  String? name;

  factory BuildingType.fromJson(Map<String, dynamic> json) => BuildingType(
    categoryId: json["CategoryId"],
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "CategoryId": categoryId,
    "Id": id,
    "Name": name,
  };
}

class Type {
  Type({
    this.id,
    this.name,
  });

  int ?id;
  String ?name;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["Id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
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

  int? id;
  String? sks;
  String ?name;
  String? consultantName;
  String? clientName;
  String? contractorName;
  String? startDate;
  String? endDate;
  String? location;
  String? locationPin;
  String ?from;
  String ?to;

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
