import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:sketch/constant/constURL.dart';
import 'package:sketch/presintation/UIScreens/AuthScreen/loginScreen.dart';

import '../../../constant/compontents.dart';
import '../../../function/sharedprefrenc.dart';
import '../../widgets/buttons/textButton.dart';
import '../profoile/profileScreen.dart';

class WebViewCreen extends StatefulWidget {
  const WebViewCreen({Key? key}) : super(key: key);

  @override
  State<WebViewCreen> createState() => _WebViewCreenState();
}

class _WebViewCreenState extends State<WebViewCreen> {
  final GlobalKey webViewKey = GlobalKey();

  // InAppWebViewController? webViewController;
  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //     crossPlatform: InAppWebViewOptions(
  //       useShouldOverrideUrlLoading: true,
  //       allowFileAccessFromFileURLs: true,
  //       allowUniversalAccessFromFileURLs: true,
  //       mediaPlaybackRequiresUserGesture: true,
  //     ),
  //     android: AndroidInAppWebViewOptions(
  //       useHybridComposition: true,
  //       allowFileAccess: true,
  //       geolocationEnabled: true,
  //
  //     ),
  //     ios: IOSInAppWebViewOptions(
  //       allowsInlineMediaPlayback: true,
  //     ));
  //
  // late PullToRefreshController pullToRefreshController;
  String url = "";
  var username, password,fullname;
  String ? lang ;
  bool isLoading=true;
  double progress = 0;
  final urlController = TextEditingController();

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    fullname=CacheHelper.getData(key: 'UserFullName');
    lang = CacheHelper.getData(key: 'lang');

  }
  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[

              Expanded(
                child: Stack(
                  children: [

                    WebviewScaffold(url: 'https://sketchtest.birdcloud.qa',
                      appBar: AppBar(actions: [],
                          backgroundColor: Color(0xff01579b),
                        title: Text('Sketch'),
                        centerTitle: true,
                      ),

                    ),
                    IconButton(onPressed: (){
                      // controller.clearCache();
                      // CookieManager().clearCookies();
                      CacheHelper.saveData(key: 'islogin', value: false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                      showToast(text: "Logout !", state: ToastState.WARNING);
                    }, icon: Icon(Icons.logout,color: Colors.white,)
                    )

                    // /*


                     // */
                  ],
                ),
              ),

            ]))
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
