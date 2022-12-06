import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:sketch/cubit/app_cubit.dart';
import 'package:sketch/presintation/UIScreens/new%20order/neworderScreen.dart';
import 'package:sketch/presintation/UIScreens/new%20order/orders.dart';
import 'package:sketch/presintation/UIScreens/profoile/profileScreen.dart';
import 'package:sketch/presintation/widgets/buttons/buttonstart.dart';
import 'package:sketch/presintation/widgets/buttons/textButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/compontents.dart';
import '../../../function/sharedprefrenc.dart';
import '../AuthScreen/loginScreen.dart';

import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class WebViweScreen extends StatefulWidget {
  const WebViweScreen({Key? key}) : super(key: key);

  @override
  State<WebViweScreen> createState() => _WebViweScreenState();
}

class _WebViweScreenState extends State<WebViweScreen> {

  late WebViewController controller;
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: '_Toaster',
        onMessageReceived: (JavascriptMessage message) {
         showToast(text: message.message, state: ToastState.WARNING);
        });
  }
  String ? lang ;
  var username, password,fullname;
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SignIN();
    fullname=CacheHelper.getData(key: 'UserFullName');
    lang = CacheHelper.getData(key: 'lang');

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }



  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    var b;
    return BlocProvider(create: (BuildContext context)=>AppCubit()..GetProject(),
      child: BlocConsumer<AppCubit,AppState>(
        builder: (BuildContext context,state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: "https://sketch.birdcloud.qa",
                    onWebViewCreated: (controller){
                      this.controller= controller;
                    },

                    initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.require_user_action_for_all_media_types,
                    javascriptChannels: <JavascriptChannel>[_toasterJavascriptChannel(context),
                    ].toSet(),
                    onPageFinished: (finish){
                      setState(() {
                        isLoading = false;
                        SignIN();
                      });
                    },
                    allowsInlineMediaPlayback: false,
                    gestureNavigationEnabled: false,



                  ),
                  isLoading ?LinearProgressIndicator(value: 100)
                      : Stack(),
                  Column(
                    children: [
                      Container(width: double.infinity,
                          padding: EdgeInsets.all(16),
                          height:height / 12,
                          decoration: BoxDecoration(
                              color: Color(0xff01579b)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));}, icon: Icon(Icons.account_circle,color: Colors.white)),
                                  fullname!=null?Text("${fullname}",style: TextStyle(color: Colors.white,)):Text('')
                                ],),
                              DefaultTextButton(text: '${lang}', onPressed: (){
                                setState(() {
                                  Changelang();
                                });
                              }, txtColor: Colors.white),
                              Text('Sketch',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                              PopupMenuButton(
                                // add icon, by default "3 dot" icon
                                // icon: Icon(Icons.book)
                                  itemBuilder: (context){
                                    return [

                                      PopupMenuItem(
                                        value: 0,
                                        child: Row(
                                          crossAxisAlignment:CrossAxisAlignment.center ,
                                          children: [
                                            Icon(Icons.logout,color: Color(0xff01579b),),
                                            SizedBox(width: 16,),
                                            Text("Logout"),
                                          ],
                                        ),
                                      ),

                                    ];
                                  },icon: Icon(Icons.menu_open_sharp,color: Colors.white,),
                                  color: Colors.white,
                                  constraints: BoxConstraints.expand(width: double.infinity,height: height*0.08),elevation: 2,

                                  position: PopupMenuPosition.under,
                                  onSelected:(value){
                                    if(value == 0){
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              height: height/4,
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.center ,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("Logout",style: TextStyle(color: Color(0xff01579b),fontSize: 25,fontWeight: FontWeight.w600),),
                                                  SizedBox(height: 16,),
                                                  Text("You will be returned to the Login Screen."),
                                                  SizedBox(height: 16,),
                                                  Row(
                                                      crossAxisAlignment:CrossAxisAlignment.center ,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children:[
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Color(0xffd0d0d0), // background
                                                            onPrimary: Color(0xff01579b), // foreground
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        SizedBox(width: 16,),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            primary: Color(0xff01579b), // background
                                                            onPrimary: Colors.white, // foreground
                                                          ),
                                                          onPressed: () {
                                                            controller.clearCache();
                                                            CookieManager().clearCookies();
                                                            CacheHelper.saveData(key: 'islogin', value: false);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                                            showToast(text: "Logout !", state: ToastState.WARNING);

                                                          },
                                                          child: Text('Logout'),
                                                        )

                                                      ]
                                                  )

                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                              ),

                            ],
                          )
                      ),
                      // /*
                      Container(
                        width: double.infinity,
                        height: height/12,
                        decoration: BoxDecoration(color: Colors.white),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Container(
                                  child: DropdownButton(
                                    elevation: 1,
                                    hint: Text('أختار الطلب'),
                                    icon: Icon(Icons.arrow_drop_down_circle_sharp),
                                    value: cubit.dropdownvalue,
                                    items: cubit.dataproject.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items,style: TextStyle(fontSize: 16),),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        cubit.dropdownvalue= value!;
                                        print(cubit.dropdownvalue);
                                        b = (cubit.dropdownvalue.split('-'));
                                        print(b[2]);
                                        // cubit.projectid =b[2];
                                      //  cubit.AddProject(b[2]);
                                      //   Navigator.push(context, MaterialPageRoute(builder: (context)=> NewOrderScreen(projectid: '${b[2]}',)));

                                      });
                                    },
                                    underline: Container(),
                                    isExpanded: true,

                                    style: TextStyle(fontSize: 25,color: Colors.red),
                                  )
                              ),
                              width: width/1.5,
                            ),
                            ButtonStart(onPrimary: Colors.white, primary: Colors.red.shade900, onPressed: (){
                              b = (cubit.dropdownvalue.split('-'));
                              print(b[2]);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> OrdersScreen(projectid: '${b[2]}',)));
                            }, text: 'الطلبات', minimumSizeX: 40, minimumSizeY: 30, paddingHorizontal: 16, fontSize: 16, radius: 0),
                          ],
                        ),
                      ),
                      // */
                    ],
                  ),


                ],
              ),
            ),

          );
        },
        listener: (BuildContext context,state){

        },
      ),
    );
  }
  void SignIN()async{
    username= CacheHelper.getData(key: 'username')??'';
    password= CacheHelper.getData(key: 'password')??'';
    print(username+password);

     // await Future.delayed(Duration(seconds: 2));

      await controller.evaluateJavascript("document.getElementById('exampleInputEmail1').value='$username'");
      await controller.evaluateJavascript("document.getElementById('exampleInputEmail1').dispatchEvent(new Event('input'))");
      await controller.evaluateJavascript("document.getElementById('exampleInputEmail1').dispatchEvent(new Event('blur'))");

      await controller.evaluateJavascript("document.getElementById('exampleInputPassword1').value='$password'");
      await controller.evaluateJavascript("document.getElementById('exampleInputPassword1').dispatchEvent(new Event('input'))");
      await controller.evaluateJavascript("document.getElementById('exampleInputPassword1').dispatchEvent(new Event('blur'))");

      await Future.delayed(Duration(seconds: 1));
      await controller.evaluateJavascript("document.getElementsByClassName('btn btn-primary btn-block')[0].click()");


  }
  void Changelang()async{
    //traslate-text color-white ng-star-inserted
    if(lang =='EN') {
      await controller.evaluateJavascript(
          "document.getElementsByClassName('traslate-text color-white ng-star-inserted')[0].click()");
      lang='عربي';
      CacheHelper.saveData(key: 'lang',value:'عربي');
    }else{
      await controller.evaluateJavascript(
          "document.getElementsByClassName('traslate-text color-white ng-star-inserted')[0].click()");
      lang='EN';
      CacheHelper.saveData(key: 'lang',value:'EN');
    }
  }


}
/*

 */