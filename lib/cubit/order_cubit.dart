import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:sketch/constant/compontents.dart';
import 'package:sketch/constant/constURL.dart';
import 'package:sketch/function/sharedprefrenc.dart';
import 'package:sketch/models/ConcreteOrdermodel/ConcreteOrdermodel.dart';
import 'package:sketch/network/service/dio_helper.dart';
import 'package:http/http.dart' as http;


import '../models/ConcreteOrdermodel/flormodel.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  static OrderCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  TextEditingController tablnumberTEC = TextEditingController();
  // TextEditingController TEC = TextEditingController();
  TextEditingController SupplierNameTec = TextEditingController();
  TextEditingController SupplierphoneTec = TextEditingController();
  TextEditingController concreteamountTec = TextEditingController();
  TextEditingController AnyAddingConcreteTec = TextEditingController();
  var authorization;
  ConcreteOrdermodel concreteOrdermodel = new ConcreteOrdermodel();
  List ApprovedInspectionsname=[];
  List ConcreteGradeTypes=[];
  List CementTypes=[];
  String ? projectidd;
  Getinspectionrequst(String projectid)async{
    projectidd=projectid;
    print(projectid);
    authorization = CacheHelper.getData(key: 'authorization');
    print(authorization);
    Dio dio = new Dio();
    var headers = {
      'Content-Type':'application/json',
      'lang':'ar',
      'Authorization':authorization};
    try{
      Response responce = await dio.get('${baseurl}api/Project/ConcreteOrder/GetNewRequestInitialData?projectId=${projectid}',options: Options(
        headers:headers,
      ));
      String responceConcreteData = jsonEncode(responce.data);
      CacheHelper.setData(key: 'responceConcreteData', value: responceConcreteData);
      concreteOrdermodel  = ConcreteOrdermodel.fromJson(responce.data);

      print(responce.data);
      if(responce.statusCode==200){
        showToast(text: responce.statusCode.toString(), state: ToastState.SUCCESS);
        if(concreteOrdermodel.success==true) {
          ApprovedInspectionsname= concreteOrdermodel.data!.approvedInspections!.map((e){
            return{
              "id":e.id,
              "name":"${e.name}-${e.code}"
            };
          }).toList();
          ConcreteGradeTypes= concreteOrdermodel.data!.concreteGradeTypes!.map((e){
            return{
              "id":e.id,
              'name':e.name
            };
          }).toList();
          CementTypes= concreteOrdermodel.data!.cementTypes!.map((e){
            return{
              'id':e.id,
              'name':e.name
            };
          }).toList();
          print(ApprovedInspectionsname);
          emit(GetinspectionrequstSucessState());
        }
        }else{
        showToast(text: responce.statusCode.toString(), state: ToastState.SUCCESS);
        emit(GetinspectionrequstErorrState());
      }
    }catch(e){
      print(e);
      emit(GetinspectionrequstErorrState());
    }

  }
  String ? approvedInspectionsvalue;
  String ? ConcreteGradeTypesvalue;
  String ?CementTypesvalue;

  String ? ApprovedInspectionsBuildingTypeName;
  int ? ApprovedInspectionsBuildingTypeID;
  List ApprovedInspectionsBuildingTypeNamelist=[];

  var finalresponceConcreteData;
  List? ApprovedInspectionsCastingDescriptionlist;
  var ApprovedInspectionsCastingDescription;
  GetApprovedInspectionsCastingDescription(String value){
    finalresponceConcreteData= CacheHelper.getData(key: 'responceConcreteData');
    var bodydata = jsonDecode(finalresponceConcreteData);
    concreteOrdermodel  = ConcreteOrdermodel.fromJson(bodydata);
    if(concreteOrdermodel.success==true){
      // print(concreteOrdermodel.data!.approvedInspections[0].buildingType!.id);
      for(int i= 0; i<concreteOrdermodel.data!.approvedInspections!.length;i++) {
        ApprovedInspectionsCastingDescriptionlist =
            concreteOrdermodel.data!.approvedInspections!.where((
                element) => element.id == int.parse(value)).toList();
        ApprovedInspectionsCastingDescriptionlist!.forEach((element) {ApprovedInspectionsCastingDescription= element.castingDescription;});
        ApprovedInspectionsCastingDescriptionlist!.forEach((element) {ApprovedInspectionsBuildingTypeName= element.buildingType!.name;
        ApprovedInspectionsBuildingTypeID= element.buildingType!.id;
        });

      }
    }

  }
  List  ApprovedInspectionsBuildingTypeFloorlist=[];
  String ? ApprovedInspectionsBuildingTypeFloor;
  int ? ApprovedInspectionsBuildingTypeFloorID;
  GetRequestFloorList(String value)async{
    // ApprovedInspectionsBuildingTypeFloorlist.clear();
    authorization = CacheHelper.getData(key: 'authorization');
    var headers = {
      'Content-Type':'application/json',
      'lang':'ar',
      'Authorization':authorization};
    print('value ${value}');
    Dio dio =new Dio();
    try{
      Response response= await dio.get('https://sketchtest-api.birdcloud.qa/api/Project/Inspection/GetRequestFloorList?id=$value',options: Options(
        headers:headers,
      ));
     print('response.data${response.data}');
     Floormodel floormodel = Floormodel();
    floormodel=Floormodel.fromJson(response.data);
     if(response.statusCode==200){
       ApprovedInspectionsBuildingTypeFloor= floormodel.data![0].name;
       ApprovedInspectionsBuildingTypeFloorID=floormodel.data![0].id;
       emit(GetRequestFloorListState());
     }
    }catch(e){}

  }
  List <String> catigory=["أخرى",
    "صور الموقع",
    "رسومات التعاقد المختومة pdf",
    "مستندات",
    "سند ملكية",
    " مخطط الأرض المرفق لسند الملكية",
    " بطاقة المالك "," تعهدات "," تقرير مساحي "," احداثيات الأرض "," رخص البلديات "," رسومات الرخصة (dwf) ",
    " رسومات الرخصة الاتوكاد (dwg) "," عقد المقاول "," عقد الاشراف "," شهاده اتمام البناء "," مخطط مساحي ملون (Policy Plan) "," نموذج الموافقة علي الرسومات ",
    " موافقات ",
    " محضر إستلام الموقع ",
    " محضر العناوين المعتمدة للمراسلات ",
    " رسومات ديكور داخلي ",
    " رسومات الرخصة (pdf) ",
    " طلب وقف الإشراف ",
    " المنظور المعماري ",
    " رسومات أعمال خاصة (تكييف - مصعد - ... الخ) ",
    " صور الواقع الجديد ",
  ];
  String ? dropdownCategoryvalu;
  TextEditingController dESCRIPTIONDescriptionTEC = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List <XFile> ? imageFileList=[];
  File ?myfile;
  File ?file;
  bool isshowDialog = false;

  void AddPhotoAttachmentGalary() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if(selectedImages!.isNotEmpty){
      imageFileList!.addAll(selectedImages);
    }
    print("length : ${imageFileList!.length.toString()} ");
    emit(AddphotoSucess());
  }

  void AddPhotoAttachmentCamera() async {
    XFile? xfile = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 25);
    myfile = File(xfile!.path);
    imageFileList!.add(xfile);
    isshowDialog = true;
    emit(AddphotoSucess());
  }
  bool isSend=false;
  openSend(){
    isSend=true;
    emit(openSendState());
  }
  closeSend(){
    isSend=false;
    emit(closeSendState());
  }



  String ? signitureConfirmimg;
  TextEditingController signiturpasstec = TextEditingController();
  //////////////////////////////////////////////////
  List fileimage=[];
  String? VPath,FullPath,OriginalName,FileName,Extension;
  List listVPath=[];
  List listFullPath=[];
  List listOriginalName=[];
  List listFileName=[];
  List listExtension=[];
  List PhysicalPath=[];

  uploadimage()async{
    Dio dio =new Dio();
    imageFileList!.forEach((element) async {
      print(element.path);
      try{
        FormData data = FormData.fromMap({
          "file": await MultipartFile.fromFile(
              element.path,
          ),
          'FileUploadType': '9',
          'CategoryId': '1'
        });
        Response response = await dio.post('${baseurl}api/File/UploadTemp',data: data,);
        print(response.statusCode);
        print(response.data);
        if(response.statusCode==200){
          listVPath.add(response.data['Data'][0]['VPath']);
          listFullPath.add(response.data['Data'][0]['FullPath']);
          listOriginalName.add(response.data['Data'][0]['OriginalName']);
          listFileName.add(response.data['Data'][0]['FileName']);
          listExtension.add(response.data['Data'][0]['Extension']);
          PhysicalPath.add(response.data['Data'][0]['PhysicalPath']);
          emit(UploadphotoSucessState());
        }else{
          showToast(text: 'Cancel uploadded', state: ToastState.ERROR);
          print('Cancel uplodedd');
          emit(UploadphotoErorrState());
        }

      }catch(e){
        print(e);
        emit(UploadphotoErorrState());
      }
    });
/*
    print(imageFileList![0].path);
    try{
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFileList![0].path,
        ),
        'FileUploadType': '9',
        'CategoryId': '1'
      });
      Response response = await dio.post('${baseurl}/api/File/UploadTemp',data: data,);
      print(response.statusCode);
      print(response.data);
      emit(UploadphotoSucessState());
    }catch(e){
      print(e);
      emit(UploadphotoErorrState());
    }
    */
  }

  //////////////////////////////////////////////////

  void ConfirmSignitrue()async{
    print(listVPath);
    var authorization = CacheHelper.getData(key: 'authorization');
    try{
      var dio = Dio();
      final response = await dio.post('${baseurl}/api/Account/ConfirmSignature',options: Options(
        headers:  {
          'Authorization': '$authorization',
          'Content-Type': 'application/json'
        },
      ),
          data:{"Password": "${signiturpasstec.text}"}

      );
      if(response.statusCode==200){
        if(response.data['Success']==true){
          signitureConfirmimg= response.data['Data']['Signature'];
          // UploadPhoto();
          uploadimage();
          emit(ConfirmSignitrueStateSucess());
        }else{
          emit(ConfirmSignitrueStateErorr());

        }
      }else{
        emit(ConfirmSignitrueStateErorr());
      }

    }
    catch(e){}

  }
  //////////////////////////////////////////////////
  String valueG = "1";
  bool WithPump = true;
  OnRadioButton(value){
    valueG=value;
    print(value);
    if(value == "1"){
      WithPump= true;
    }else{
      WithPump= false;
    }
    print(WithPump);
    emit(RadioButtonState());
  }
  String valueconcreteG = "1";
  bool ConcreteIsReinforced=true;
  bool ConcreteIsPlain= false;
  OnconcreteRadioButton(value){
    valueconcreteG=value;
    print(value);
    if(value=='1'){
      ConcreteIsReinforced= true;
      ConcreteIsPlain=false;
    }else{
      ConcreteIsReinforced= false;
      ConcreteIsPlain=true;
    }
    print('$ConcreteIsReinforced , $ConcreteIsPlain');
    emit(concreteRadioButtonState());
  }
  DateTime date= DateTime.now();
  TimeOfDay time=TimeOfDay.now();
  String ?formatDate;
  void SetDtaetime(){
    formatDate= DateFormat('dd-MM-yyyy').format(date);
    emit(setDtaetimeState());
  }
  bool isloadsending=false;

  SendData()async{
    isloadsending = true;
    print('send Data');
    authorization = CacheHelper.getData(key: 'authorization');
    List ? attachment;
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    List ali=[];
    for (int i=0; i<listVPath.length; i++){
      // print('hello');
      attachment=[
        {
          "Id": 0,
          "CategoryId": 34,
          "ParentId": null,
          "IsExtension": false,
          "Description_Ar": null,
          "Files": [
            {
              "Name": listFileName[i],
              "Extension": listExtension[i],
              "Success": true,
              "uploudRequest": {
                "closed": true,
                "_parentOrParents": null,
                "_subscriptions": null,
                "syncErrorValue": null,
                "syncErrorThrown": false,
                "syncErrorThrowable": true,
                "isStopped": true,
                "destination": {
                  "closed": true,
                  "_parentOrParents": null,
                  "_subscriptions": null,
                  "syncErrorValue": null,
                  "syncErrorThrown": false,
                  "syncErrorThrowable": false,
                  "isStopped": true,
                  "destination": {
                    "closed": true
                  },
                  "_parentSubscriber": null,
                  "_context": null
                }
              },
              "AttachmentTypeID": 3,
              "DocumentID": 0,
              "progress": 100,
              "VPath": listVPath[i],
              "FullPath": listFullPath[i],
              "PhysicalPath": PhysicalPath[i],
              "OriginalName": listOriginalName[i],
              "FileName":listFileName[i]
            }
          ],
          "AttachmentTarget": 2,
          "TargetId": "$projectidd"
        },
      ] ;

      ali.addAll(attachment);

    }
    print(ali);
    Dio dio = new Dio();
    var headers = {
      'Content-Type':'application/json',
      'lang':'ar',
      'Authorization':authorization};
    try{
      Response response= await dio.post('${baseurl}api/Project/ConcreteOrder/AddForm',options: Options(headers: headers),
          data:
            {
              "BOQNo": tablnumberTEC.text,
              "ConcretSupplier_Name": SupplierNameTec.text,
              "ConcretSupplier_Phone": SupplierphoneTec.text,
              "OtherCastingDescription": null,
              "BuildingTypeId": ApprovedInspectionsBuildingTypeID,
              "FloorTypeIds": [
                ApprovedInspectionsBuildingTypeFloorID
              ],
              "ConcreteGradeTypeId": int.parse(ConcreteGradeTypesvalue!),
              "OtherConcreteGrade": null,
              "CementTypeId": int.parse(CementTypesvalue!),
              "WithPump": WithPump,
              "EstimatedConcreteQTY": concreteamountTec.text,
              "ConcreteIsReinforced": ConcreteIsReinforced,
              "ConcreteIsPlain": ConcreteIsPlain,
              "ApprovedInspectionId": int.parse(approvedInspectionsvalue!),
              "AnyAddingConcrete": AnyAddingConcreteTec.text,
              "ProjectId": projectidd,
              "EstimatedDate": "${formattedDate }",
              "EstimatedTime": "${time.hour}:${time.minute}:00",
              "Attachments": ali
            }

      );
      print('hllo');
      if(response.statusCode==200){
        if(response.data['Success']==true){
          print(response.requestOptions.data);
          print(response.data);
          emit(SendDataStateSucess());
        }else{
          print(response.data);
          showToast(text: response.data['Message'], state: ToastState.ERROR);
          isloadsending=false;
          emit(SendDataStateErorr());
        }

      }else{
        print(response.data);
        isloadsending=false;
        emit(SendDataStateErorr());
      }


    }catch(e){
      print(e);
      isloadsending=false;
      print('michael');
      emit(SendDataStateErorr());
    }

  }




}
