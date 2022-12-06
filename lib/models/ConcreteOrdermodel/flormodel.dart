// To parse this JSON data, do
//
//     final floormodel = floormodelFromJson(jsonString);

import 'dart:convert';

Floormodel floormodelFromJson(String str) => Floormodel.fromJson(json.decode(str));

String floormodelToJson(Floormodel data) => json.encode(data.toJson());

class Floormodel {
  Floormodel({
    this.data,
    this.message,
    this.success,
    this.authorized,
  });

  List<Datum>? data;
  String ?message;
  bool ?success;
  bool ?authorized;

  factory Floormodel.fromJson(Map<String, dynamic> json) => Floormodel(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    message: json["Message"],
    success: json["Success"],
    authorized: json["Authorized"],
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "Message": message,
    "Success": success,
    "Authorized": authorized,
  };
}

class Datum {
  Datum({
    this.categoryId,
    this.id,
    this.name,
  });

  int? categoryId;
  int ?id;
  String ?name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
