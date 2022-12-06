// To parse this JSON data, do
//
//     final profilemodel = profilemodelFromJson(jsonString);

import 'dart:convert';

Profilemodel profilemodelFromJson(String str) => Profilemodel.fromJson(json.decode(str));

String profilemodelToJson(Profilemodel data) => json.encode(data.toJson());

class Profilemodel {
  Profilemodel({
    this.data,
    this.message,
    this.success,
    this.authorized,
  });

  Data? data;
  String? message;
  bool? success;
  bool ?authorized;

  factory Profilemodel.fromJson(Map<String, dynamic> json) => Profilemodel(
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
    this.photo,
    this.signatureVPath,
    this.mobile,
    this.email,
    this.isActive,

    this.username,
    this.canEditUserName,
    this.fullNameAr,
    this.fullNameEn,
  });

  String ?photo;
  String ?signatureVPath;
  String ?mobile;
  String ?email;

  bool ?isActive;

  String ?username;
  bool ?canEditUserName;
  String? fullNameAr;
  String ?fullNameEn;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    photo: json["Photo"],
    signatureVPath: json["SignatureVPath"],
    mobile: json["Mobile"],
    email: json["Email"],

    isActive: json["IsActive"],

    username: json["Username"],
    canEditUserName: json["CanEditUserName"],
    fullNameAr: json["FullName_Ar"],
    fullNameEn: json["FullName_En"],
  );

  Map<String, dynamic> toJson() => {
    "Photo": photo,
    "SignatureVPath": signatureVPath,
    "Mobile": mobile,
    "Email": email,
    "IsActive": isActive,
    "Username": username,
    "CanEditUserName": canEditUserName,
    "FullName_Ar": fullNameAr,
    "FullName_En": fullNameEn,
  };
}
