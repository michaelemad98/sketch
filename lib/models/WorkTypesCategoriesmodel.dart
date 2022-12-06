// To parse this JSON data, do
//
//     final workTypesCategoriesmodel = workTypesCategoriesmodelFromJson(jsonString);

import 'dart:convert';

List<WorkTypesCategoriesmodel> workTypesCategoriesmodelFromJson(String str) => List<WorkTypesCategoriesmodel>.from(json.decode(str).map((x) => WorkTypesCategoriesmodel.fromJson(x)));

String workTypesCategoriesmodelToJson(List<WorkTypesCategoriesmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkTypesCategoriesmodel {
  WorkTypesCategoriesmodel({
    this.name,
    this.id,
  });

  String ?name;
  int? id;

  factory WorkTypesCategoriesmodel.fromJson(Map<String, dynamic> json) => WorkTypesCategoriesmodel(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
