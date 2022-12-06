// To parse this JSON data, do
//
//     final auth = authFromJson(jsonString);

import 'dart:convert';

Auth authFromJson(String str) => Auth.fromJson(json.decode(str));

String authToJson(Auth data) => json.encode(data.toJson());

class Auth {
  Auth({
    this.data,
    this.message,
    this.success,
    this.authorized,
  });

  Data? data;
  String? message;
  bool ?success;
  bool ?authorized;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
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
    this.authToken,
    this.refreshToken,
    this.expireDate,
    this.expireInDays,
    this.user,
  });

  String? authToken;
  String ?refreshToken;
  String ?expireDate;
  int? expireInDays;
  User? user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    authToken: json["AuthToken"],
    refreshToken: json["RefreshToken"],
    expireDate: json["ExpireDate"],
    expireInDays: json["ExpireInDays"],
    user: User.fromJson(json["User"]),
  );

  Map<String, dynamic> toJson() => {
    "AuthToken": authToken,
    "RefreshToken": refreshToken,
    "ExpireDate": expireDate,
    "ExpireInDays": expireInDays,
    "User": user!.toJson(),
  };
}

class User {
  User({
    this.employeeId,
    this.roles,
    this.id,
    this.userName,
    this.canEditUserName,
    this.fullName,
    this.mobile,
    this.otherPhones,
    this.email,
    this.photo,
    this.isActive,
  });

  int? employeeId;
  List<int> ?roles;
  int ? id;
  String ?userName;
  bool? canEditUserName;
  String ?fullName;
  String ?mobile;
  dynamic? otherPhones;
  String? email;
  String ?photo;
  bool ?isActive;

  factory User.fromJson(Map<String, dynamic> json) => User(
    employeeId: json["EmployeeId"],
    roles: List<int>.from(json["Roles"].map((x) => x)),
    id: json["Id"],
    userName: json["UserName"],
    canEditUserName: json["CanEditUserName"],
    fullName: json["FullName"],
    mobile: json["Mobile"],
    otherPhones: json["OtherPhones"],
    email: json["Email"],
    photo: json["Photo"],
    isActive: json["IsActive"],
  );

  Map<String, dynamic> toJson() => {
    "EmployeeId": employeeId,
    "Roles": List<dynamic>.from(roles!.map((x) => x)),
    "Id": id,
    "UserName": userName,
    "CanEditUserName": canEditUserName,
    "FullName": fullName,
    "Mobile": mobile,
    "OtherPhones": otherPhones,
    "Email": email,
    "Photo": photo,
    "IsActive": isActive,
  };
}
