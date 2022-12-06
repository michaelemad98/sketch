import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sketch/constant/compontents.dart';
import 'package:sketch/models/authmdel.dart';
import 'package:sketch/models/profilemodel.dart';
import 'package:dio/dio.dart';
import 'package:sketch/models/projectmodel.dart';

import '../constant/constURL.dart';
import '../function/sharedprefrenc.dart';
import '../models/WorkTypesCategoriesmodel.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  bool ?link;

  void GetLink() async {
    final response = await http
        .get(Uri.parse('https://michtechno.com/linkbirdmenu.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      link = data['link'];
      print(link);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  bool visibility = true;

  void onvisibilty() {
    visibility = false;
    emit(Visibility());
  }

  void offVisibility() {
    visibility = true;
    emit(UnVisibility());
  }

  var fbm = FirebaseMessaging.instance;
  TextEditingController usernameTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  String fbToken = '';
  Auth auth = Auth();

  void Sigin() async {
    GetLink();
    print(link);
    await Future.delayed(Duration(seconds: 1));
    final responce = await http.post(
        Uri.parse('${baseurl}/api/Account/Login'),
        body: jsonEncode(<String, String>{
          "UserName": "${usernameTEC.text.trim()}",
          "Password": "${passwordTEC.text}"
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'appId': '1'
        }
    );
    String body = utf8.decode(responce.bodyBytes);
    if (responce.statusCode == 200) {
      var bodydecoe = jsonDecode(body);
      print(bodydecoe);
      if (link == true) {
        if (bodydecoe["Success"] == true) {
          auth = await Auth.fromJson(jsonDecode(body));
          SendToken('Bearer ' + '${auth.data!.authToken}');

          CacheHelper.saveData(key: 'authorization',
              value: 'Bearer ' + '${auth.data!.authToken}');
          CacheHelper.saveData(key: 'username', value: usernameTEC.text.trim());
          CacheHelper.saveData(key: 'password', value: passwordTEC.text.trim());
          CacheHelper.saveData(key: 'AuthToken', value: auth.data!.authToken);
          CacheHelper.saveData(key: 'lang', value: 'EN');
          CacheHelper.saveData(key: 'accesstoken', value: auth.data!.authToken);
          CacheHelper.saveData(
              key: 'RefreshToken', value: auth.data!.refreshToken);
          CacheHelper.saveData(
              key: 'UserEmployeeId', value: auth.data!.user!.employeeId);
          CacheHelper.saveData(key: 'UserId', value: auth.data!.user!.id);
          CacheHelper.saveData(
              key: 'UserUserName', value: auth.data!.user!.userName);
          CacheHelper.saveData(key: 'UserCanEditUserName',
              value: auth.data!.user!.canEditUserName);
          CacheHelper.saveData(
              key: 'UserFullName', value: auth.data!.user!.fullName);
          CacheHelper.saveData(
              key: 'UserMobile', value: auth.data!.user!.mobile);
          CacheHelper.saveData(key: 'UserEmail', value: auth.data!.user!.email);
          CacheHelper.saveData(key: 'UserPhoto', value: auth.data!.user!.photo);
          CacheHelper.saveData(
              key: 'UserIsActive', value: auth.data!.user!.isActive);
          CacheHelper.saveData(key: 'islogin', value: true);
          showToast(text: "Login Success !", state: ToastState.SUCCESS);
          emit(SignINSccess());
        } else {
          showToast(text: "invalid  The username or password is incorrect.",
              state: ToastState.ERROR);
          emit(SignINError());
        }
      } else {
        showToast(text: "invalid  incorrect!", state: ToastState.ERROR);
        emit(SignINError());
      }
    }
    else {
      print("error: ${responce.body}");
      showToast(text: "${responce.body}!", state: ToastState.ERROR);
      emit(SignINError());
    }
  }

  void SendToken(String authtoken) {
//  showToast(text: "$authtoken .", state: ToastState.WARNING);

    fbm.getToken().then((token) async {
      fbToken = token!;

      var headers = {
        'appId': '1',
        'lang': '1',
        'Access-Control-Allow-Origin': '*',
        'Authorization': authtoken
      };
      print(fbToken);
      //showToast(text: "$fbToken .", state: ToastState.WARNING);
      var request = http.Request('POST', Uri.parse(
          '${baseurl}/api/Mobile/SavePlayerID?PlayerId=${fbToken}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        //showToast(text: 'Token Sucess', state: ToastState.SUCCESS);
        emit(SendTokenSucess());
      }
      else {
        print(response.reasonPhrase);
        showToast(text: "invalid  Token incorrect.", state: ToastState.ERROR);

        emit(SendTokenError());
      }
    });
  }


  Profilemodel profilemodel = Profilemodel();
  String? profilePhoto, profileusername, profilesignatureVPath, profilemobile,
      profileemail, profilefullNameAr, profilefullNameEn;

  void GetProfile() async {
    var authorization = CacheHelper.getData(key: 'authorization');
    final responce = await http.get(
        Uri.parse('${baseurl}/api/Account/GetMyProfile'),
        headers: {
          'appId': '1',
          'lang': '1',
          'Access-Control-Allow-Origin': '*',
          'Authorization': authorization
        });
    String body = utf8.decode(responce.bodyBytes);
    if (responce.statusCode == 200) {
      var bodydecoe = jsonDecode(body);
      print(bodydecoe);
      if (bodydecoe['Message'] ==
          'You are not authenticated, please login first.') {
        showToast(text: "${bodydecoe['Message']}!", state: ToastState.ERROR);
        emit(GetProfileErorr());
      } else {
        profilemodel = await Profilemodel.fromJson(jsonDecode(body));
        //print(profilemodel.data!.photo);
        profilePhoto = profilemodel.data!.photo;
        CacheHelper.saveData(
            key: 'profilePhoto', value: profilemodel.data!.photo);
        profileusername = profilemodel.data!.username;
        CacheHelper.saveData(
            key: 'profileusername', value: profilemodel.data!.username);
        profilesignatureVPath = profilemodel.data!.signatureVPath;
        CacheHelper.saveData(key: 'profilesignatureVPath',
            value: profilemodel.data!.signatureVPath);
        profilemobile = profilemodel.data!.mobile;
        CacheHelper.saveData(
            key: 'profilemobile', value: profilemodel.data!.mobile);
        profileemail = profilemodel.data!.email;
        CacheHelper.saveData(
            key: 'profileemail', value: profilemodel.data!.email);
        profilefullNameAr = profilemodel.data!.fullNameAr;
        CacheHelper.saveData(
            key: 'profilefullNameAr', value: profilemodel.data!.fullNameAr);
        profilefullNameEn = profilemodel.data!.fullNameEn;
        CacheHelper.saveData(
            key: 'profilefullNameEn', value: profilemodel.data!.fullNameEn);
      }
      emit(GetProfileSucess());
    } else {
      print("error: ${responce.body}");
      LoginAgain();
      emit(GetProfileErorr());
    }
  }

  var passagain, usernameagain;

  void LoginAgain() async {
    passagain = CacheHelper.getData(key: 'password');
    usernameagain = CacheHelper.getData(key: 'username');
    final responce = await http.post(
        Uri.parse('${baseurl}/api/Account/Login'),
        body: jsonEncode(<String, String>{
          "UserName": "${usernameagain}",
          "Password": "${passagain}"
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'appId': '1'
        }
    );
    String body = utf8.decode(responce.bodyBytes);
    if (responce.statusCode == 200) {
      var bodydecoe = jsonDecode(body);
      print(bodydecoe);
      if (bodydecoe["Success"] == true) {
        auth = await Auth.fromJson(jsonDecode(body));
        SendToken('Bearer ' + '${auth.data!.authToken}');

        CacheHelper.saveData(
            key: 'authorization', value: 'Bearer ' + '${auth.data!.authToken}');
        emit(SignINSccess());
      } else {
        showToast(text: "invalid  The username or password is incorrect.",
            state: ToastState.ERROR);
        emit(SignINError());
      }
    }
    else {
      print("error: ${responce.body}");
      showToast(text: "${responce.body}!", state: ToastState.ERROR);
      emit(SignINError());
    }
  }

  File ?myfile;
  File ?file;
  bool isshowDialog = false;

  void AddPhotoGalary() async {
    XFile? xfile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    myfile = File(xfile!.path);
    print(myfile);
    final bytes = myfile!.readAsBytesSync();

    isshowDialog = true;
    emit(AddphotoSucess());
  }

  void AddPhotoCamera() async {
    XFile? xfile = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 25);
    myfile = File(xfile!.path);
    isshowDialog = true;
    emit(AddphotoSucess());
  }

  void DeltetPhoto() async {
    myfile = null;
    emit(DeletepotoSucsess());
  }

  void SavePhoto() async {
    var kokofile = myfile!.path;
    print(kokofile);
    var request = http.MultipartRequest('POST',
        Uri.parse('${baseurl}/api/File/UploadTemp'));
    request.fields.addAll({
      'FileUploadType': '9',
      'CategoryId': '1'
    });
    request.files.add(await http.MultipartFile.fromPath('file', myfile!.path));

    http.StreamedResponse response = await request.send();

    String body = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      var bodydecoe = jsonDecode(body);
      print(bodydecoe);
      print(bodydecoe['Data'][0]['VPath']);
      var datavpath = bodydecoe['Data'][0]['VPath'];
      ChangePasword(datavpath);
      // var vPath = CacheHelper.setData(key: 'VPath', value: datavpath);
      emit(AddphotoSucess());
    }
    else {
      print(response.reasonPhrase);
      emit(AddphotoError());
    }
  }


  ScrollController scrollController = new ScrollController();


  /////////////////////////////////////////////
  TextEditingController sigpass = TextEditingController();
  TextEditingController confirmsigpass = TextEditingController();
  TextEditingController profpass = TextEditingController();

  void ChangePasword(var datavpath) async {
    if (sigpass.text.isEmpty) {
      showToast(
          text: 'من فضلك ادخل كلمة مرور التوقيع', state: ToastState.WARNING);
      emit(ChangePaswordError());
    } else if (confirmsigpass.text.isEmpty) {
      showToast(text: 'من فضلك ادخل تأكيد كلمة مرور التوقيع',
          state: ToastState.WARNING);
      emit(ChangePaswordError());
    } else if (profpass.text.isEmpty) {
      showToast(text: 'من فضلك ادخل  كلمة مرور ', state: ToastState.WARNING);
      emit(ChangePaswordError());
    } else {
      var authorizition = CacheHelper.getData(key: 'authorization');
      print(authorizition);
      var vPath = datavpath;
      print('-------------------- $vPath');
      var headers = {
        'Authorization': '${authorizition}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(
          '${baseurl}/api/Account/ChangeSignature'));
      request.body = json.encode({
        "Password": "${profpass.text}",
        "SignaturePassword": "${sigpass.text}",
        "NewSignatureVPath": "${vPath}"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String body = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var bodydecoe = jsonDecode(body);
        print(bodydecoe);
        if (bodydecoe['Success'] == false) {
          showToast(
              text: 'من فضلك اعد المحاولة مرة اخرة', state: ToastState.ERROR);
          emit(ChangePaswordError());
        } else {
          GetProfile();
          emit(ChangePaswordSucsess());
        }
      }
      else {
        print(response.reasonPhrase);
        showToast(text: '${response.reasonPhrase}', state: ToastState.ERROR);
        emit(ChangePaswordError());
      }
    }
  }

  TextEditingController profilePassord = TextEditingController();
  TextEditingController confimprofilePassord = TextEditingController();
  TextEditingController newprofilePassord = TextEditingController();
  bool isChangepassordShow = false;

  void ChangeProfilePassword() async {
    if (profilePassord.text.isEmpty) {
      showToast(text: 'من فضلك ادخل كلمة مرور', state: ToastState.WARNING);
      emit(ChangeprofilePaswordWarining());
    } else if (confimprofilePassord.text.isEmpty) {
      showToast(
          text: 'من فضلك ادخل تاكيد كلمة مرور', state: ToastState.WARNING);
      emit(ChangeprofilePaswordWarining());
    } else if (newprofilePassord.text.isEmpty) {
      showToast(
          text: 'من فضلك ادخل كلمة مرورالجديدة', state: ToastState.WARNING);
      emit(ChangeprofilePaswordWarining());
    }
    else {
      var authorization = CacheHelper.getData(key: 'authorization');
      var headers = {
        'Authorization': '${authorization}',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(
          '${baseurl}/api/Account/ChangePassword'));
      request.body = json.encode({
        "OldPassword": "${profilePassord.text}",
        "NewPassword": "${newprofilePassord.text}"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String body = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        var bodydecoe = jsonDecode(body);
        print(bodydecoe);
        if (bodydecoe['Success'] == false) {
          showToast(
              text: 'من فضلك اعد المحاولة مرة اخرة', state: ToastState.ERROR);
          emit(ChangeprofilePaswordError());
        } else {
          emit(ChangeprofilePaswordSucsess());
        }
      }
      else {
        print(response.reasonPhrase);
        emit(ChangeprofilePaswordError());
      }
    }
  }

  void ShowChangeassword() {
    isChangepassordShow = true;
    emit(ShowChangeasswordstate());
  }

  void HideChangeassword() {
    isChangepassordShow = false;
    emit(HideChangeasswordstate());
  }

/////////////////////////////////////////////////////////////////////////////


  //profilemodel = await Profilemodel.fromJson(jsonDecode(body));
  String dropdownvalue = '';
  List <String>dataproject = [];

  void GetProject() async {
    var authorization = CacheHelper.getData(key: 'authorization');
    try {
      var dio = Dio();
      final response = await dio.get(
        '${baseurl}/api/Project/GetList?pageSize=10000&sks=&projectName=&status=null&financialStatus=null&clientIds=&contractorIds=&consultantIds=',
        options: Options(
            headers: {
              'Authorization': '${authorization}',
              'Content-Type': 'application/json'
            }
        ),
      );
      if (response.statusCode == 200) {
        if (response.data['Success'] == true) {
          print(response.data);
          var projectData = response.data['Data'];
          for (int i = 0; i < projectData.length; i++) {
            dataproject.add("${response.data['Data'][i]['SKS']} - ${response
                .data['Data'][i]['Name']} - ${response
                .data['Data'][i]['Id']} - ${response
                .data['Data'][i]['MainConsultantName']}");
          }
          dropdownvalue = "${response.data['Data'][0]['SKS']} - ${response
              .data['Data'][0]['Name']} - ${response
              .data['Data'][0]['Id']} - ${response
              .data['Data'][0]['MainConsultantName']}";
          print(dataproject);
          emit(GetProjectstateSucsess());
        } else {
          LoginAgain();
          emit(GetProjectstateErorr());
        }
      }
      else {
        LoginAgain();
        emit(GetProjectstateErorr());
      }
    } catch (e) {
      print(e);
    }
  }

  List WorkTypes = [];
  List WorkTypesCategories=[];
  List workTypeCtaparent=[];
  List workTypeCateName=[];
  String ? dropdownWorkmainvalu;
  TextEditingController tablnumberTEC = TextEditingController();
  TextEditingController detailedDescriptionTEC = TextEditingController();
  Addprojectmodel addprojectmodel = Addprojectmodel();
  WorkTypesCategoriesmodel workTypesCategoriesmodel= WorkTypesCategoriesmodel();
  var finalprojetid;
  void AddProject(projectid) async {
    var authorization = CacheHelper.getData(key: 'authorization');
    CacheHelper.setData(key: 'finalprojetid', value: projectid);
    try {
      var dio = Dio();
      final response = await dio.get(
          '${baseurl}/api/Project/Inspection/GetNewRequestInitialData?projectId=${projectid}',
          options: Options(
              headers: {
                'Authorization': '${authorization}',
                'Content-Type': 'application/json'
              }
          )
      );
      if (response.statusCode == 200) {
        //print(response.data);
        addprojectmodel = await Addprojectmodel.fromJson(response.data);
        print('aaaaa${addprojectmodel.data!.workTypes![0].id}aaaaaaaaaaaaaaaa');

        if (addprojectmodel.success == true) {
          for (int n = 0; n < addprojectmodel.data!.workTypes!.length; n++) {
            WorkTypes.add({
              "id": addprojectmodel.data!.workTypes![n].id,
              "name": addprojectmodel.data!.workTypes![n].name
            });
          }

          emit(AddProjecttateSucsess());
        } else {
          emit(AddProjectstateErorr());
        }
      } else {
        emit(AddProjectstateErorr());
      }
    } catch (e) {
      print(e);
      emit(AddProjectstateErorr());
    }
  }
  String ?responData;

  OnDropDownWorkmain(String? value){
    dropdownWorkmainvalu=value!;
    emit(DropDownWorkState());
  }


  String ? dropdownWorksupvalu;
  OnDropDownWorksup(String? value){
    dropdownWorksupvalu=value!;
    emit(DropDownWorksupState());
  }


  List Worksuptypchild=[];
  void GetRespon(String ?valuWorktype)async{
    dropdownWorksupvalu=null;
    Worksuptypchild.clear();
    responData = CacheHelper.getData(key: 'responceData');
    var bodydata= jsonDecode(responData!);
    addprojectmodel = await Addprojectmodel.fromJson(bodydata);
    if (addprojectmodel.success == true){
      final worksuptype  = addprojectmodel.data!.workTypesCategories!.where((element) => element.id== int.parse('$valuWorktype')).toList();
      for(int x = 0; x<worksuptype.length;x++){
       for(int xx=0; xx<worksuptype[x].childs!.length; xx++){
         Worksuptypchild.add({"name":worksuptype[x].childs![xx].name,
         "id":worksuptype[x].childs![xx].id});
       }
      }
      print(Worksuptypchild);


    }
  }
  String valueG = "1";
  String? responceData;
  OnRadioButton(value) async{
    valueG = value;
    print(valueG);
    dropdownWorkmainvalu= null;
    dropdownWorksupvalu=null;
    Worksuptypchild.clear();
    finalprojetid =CacheHelper.getData(key: 'finalprojetid');
    emit(DropDownWorkState());
    print(finalprojetid);
    var authorization = CacheHelper.getData(key: 'authorization');
    try {
      var dio = Dio();
      final response = await dio.get(
          '${baseurl}/api/Project/Inspection/GetNewRequestInitialData?projectId=${finalprojetid}',
          options: Options(
              headers: {
                'Authorization': '${authorization}',
                'Content-Type': 'application/json'
              }
          )
      );
      if (response.statusCode == 200) {
       // print(response.data);
        responceData = jsonEncode(response.data);

        print(responceData);
        addprojectmodel = await Addprojectmodel.fromJson(response.data);
        if (addprojectmodel.success == true) {
          final filteredList = addprojectmodel.data!.workTypesCategories!.where((elment) => elment.parent!.id== int.parse('$valueG')).toList();
          WorkTypesCategories=filteredList.map((e){
            return {"name":e.name,
              "id":e.id
            };
          } ).toList();
          print(WorkTypesCategories);
          CacheHelper.setData(key: 'responceData', value: "${responceData}");
          emit(AddProjecttateSucsess());
        }else{
          emit(AddProjectstateErorr());
        }


      }else{
        emit(AddProjectstateErorr());
      }
    }catch (e){

    }
    emit(ButtonColorState());
    return value;
  }
  List places=[];
  void GetPlacee()async{
    places.clear();

    responData = CacheHelper.getData(key: 'responceData');
    var bodydata= jsonDecode(responData!);
    addprojectmodel = await Addprojectmodel.fromJson(bodydata);
    if(addprojectmodel.success==true){
      places= addprojectmodel.data!.buildingTypes!.map((e){
        return{
          "id":e.id,
          "name":e.category!.name,
          "categoryid":e.category!.id
        };

      }).toList();
      print(places);
      emit(GetPlacesStateSucess());
    }
  }
  String ? dropdownplacesvalu;
  List  Floors=[];
  void GetFloor(value)async{
    Floors.clear();
    dropdownfloorsvalu=null;
    responData = CacheHelper.getData(key: 'responceData');
    var bodydata= jsonDecode(responData!);
    addprojectmodel = await Addprojectmodel.fromJson(bodydata);
    if(addprojectmodel.success==true){
      final filterplace = addprojectmodel.data!.buildingTypes!.where((element) => element.id==int.parse('$value')).toList();
      for(int x = 0; x<filterplace.length;x++){
        for(int xx=0; xx<filterplace[x].availableFloors!.length; xx++){
          Floors.add({"name":filterplace[x].availableFloors![xx].category!.name,
            "id":filterplace[x].availableFloors![xx].id});
        }
      }
      print(Floors);
    }
  }
  String ? dropdownfloorsvalu;

  List DWGNumebers=[];
  String ? dropdownGetDWGNumebersalu;
  void GetDWGNumebers()async{
    DWGNumebers.clear();
    responData = CacheHelper.getData(key: 'responceData');
    var bodydata= jsonDecode(responData!);
    addprojectmodel = await Addprojectmodel.fromJson(bodydata);
    if(addprojectmodel.success==true){
      DWGNumebers = addprojectmodel.data!.dwgNumebers!.map((e){return {
        "name":e.parentName,
        "id":e.parentId
      };} ).toList();
      print(DWGNumebers);
    }
  }
  List floorsValue=[];
  void AddFlorsValue(value){
    floorsValue.add(value);
  }
  void RemoveFloorsValue(value){
    floorsValue.remove(value);
  }

  String ? dropdownplatessvalu;
  List platesnumber=[];
  void Getplates(value)async{
    platesnumber.clear();
    dropdownplatessvalu=null;
    responData = CacheHelper.getData(key: 'responceData');
    var bodydata= jsonDecode(responData!);
    addprojectmodel = await Addprojectmodel.fromJson(bodydata);
    if(addprojectmodel.success==true){
      final filterDWG= addprojectmodel.data!.dwgNumebers!.where((element) =>element.parentId==int.parse('$value')).toList();
      for(int x = 0; x<filterDWG.length;x++){
        for(int xx=0; xx<filterDWG[x].childs!.length; xx++){
          platesnumber.add({"name":filterDWG[x].childs![xx].category!.name,
            "id":filterDWG[x].childs![xx].category!.id});
        }
      }
      print(platesnumber);
    }
  }
  List listWorkSup=[];
  void AddLitsWorkSup(value){
    listWorkSup.add(value);
    emit(AddListplateState());
  }
  void RemoveLitsWorkSup(value){
    listWorkSup.remove(value);
    emit(RemoveListplateState());
  }

  List listpalte=[];
  void AddtolistPlate(value){
    listpalte.add(value);
  }
  void RemoveListplate(value){
    listpalte.remove(value);
    emit(RemoveListplateState());
  }
  DateTime date= DateTime.now();
  TimeOfDay time=TimeOfDay.now();
  void SetDtaetime(){
    emit(setDtaetimeState());
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


  ////////////////////////////////////////////////////////////////////////////////////////
final ImagePicker _picker = ImagePicker();
List <XFile> ? imageFileList=[];

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
  List fileimage=[];
  String? VPath,FullPath,OriginalName,FileName,Extension;
  List listVPath=[];
  List listFullPath=[];
  List listOriginalName=[];
  List listFileName=[];
  List listExtension=[];
  List PhysicalPath=[];

  void UploadPhoto()  async{
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
  }

  ///////////////////////////////////////////////////////////////////////
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
  void ConfirmSignitrue()async{
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
         UploadPhoto();
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
  bool isloadsending=false;
  void SendData() async{

    finalprojetid= CacheHelper.getData(key: 'finalprojetid');
    print(finalprojetid); //ProjectId
    print(tablnumberTEC.text); //BOQNo
    print(valueG);//WorkTypeId
    print(dropdownplacesvalu);//BuildingTypeId
    print('${time.hour}:${time.minute}:00');//InspectionTime
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    print(formattedDate);//InspectionDate
    print(dropdownGetDWGNumebersalu);//ParentId
    print(dropdownWorkmainvalu);//WorkDescriptionMainTypeId

    print(listWorkSup);//WorkDescriptionSubTypeIds
    print(detailedDescriptionTEC.text);//WorkDescription
    print(floorsValue);
    print(listpalte);

    // print(listVPath);
    // print(listFullPath);
    // print(listOriginalName);
    // print(listFileName);
    // print(listExtension);
    List ? attachment;
    List ali=[];
    for (int i=0; i<listVPath.length; i++){
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
          "TargetId": "239"
        },
      ] ;

      ali.addAll(attachment);

    }
    // print (ali);
    var authorization = CacheHelper.getData(key: 'authorization');
    try{
      var dio = Dio();
      final response = await dio.post('${baseurl}/api/Project/Inspection/AddForm',options: Options(
        headers:  {
          'Authorization': '$authorization',
          'Content-Type': 'application/json',
          'appId': '1',
          'Connection': ' keep-alive',
        },

      ),
        data:{
          "ProjectId": "$finalprojetid",
          "BOQNo": "${tablnumberTEC.text}",
          "BuildingTypeId": dropdownplacesvalu,
          "InspectionTime": '${time.hour}:${time.minute}:00',
          "InspectionDate": "${formattedDate}",
          "ParentId": null,
          "WorkTypeId": valueG,
          "WorkDescriptionMainTypeId": dropdownWorkmainvalu,
          "OtherWorkDescription": null,
          "WorkDescriptionSubTypeIds":listWorkSup,
          "OtherSubWorkDescription": null,
          "WorkDescription":detailedDescriptionTEC.text,
          "FloorTypeIds":floorsValue,
          "DWGTypeIds":listpalte,
          "Attachments": ali
        }
          );
      if(response.statusCode==200){
       if(response.data['Success']==true){
         print(response.requestOptions.data);
         print(response.data);
         emit(SendDataStateSucess());
       }else{
         print(response.data);
         isloadsending=false;
         showToast(text: response.data['Message'], state: ToastState.ERROR);
         emit(SendDataStateErorr());
       }

      }else{
       print(response.data);
       isloadsending=false;
        emit(SendDataStateErorr());
      }

    }
    catch (e){
    print(e);
    isloadsending=false;
    emit(SendDataStateErorr());
    }
    // */
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  TextEditingController tecSpecification = TextEditingController();
  TextEditingController tecSpecificationOriginal = TextEditingController();
}
