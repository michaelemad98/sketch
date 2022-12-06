import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch/cubit/app_cubit.dart';
import 'package:sketch/presintation/widgets/buttons/buttonstart.dart';
import 'package:sketch/presintation/widgets/buttons/textButton.dart';

import '../../widgets/inputText/inputText.dart';
import '../webview/webviewScreen.dart';
import '../webview/webviwe.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return  BlocProvider(create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppState>(builder: (BuildContext context, state){
        AppCubit cubit = AppCubit.get(context);
        return  Scaffold(
          body: SafeArea(
            child: Center(
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Image(
                          image: NetworkImage("https://sketch.birdcloud.qa/assets/logo/logo.png"),
                          height: height *0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            DefaultTextInput(tec: cubit.usernameTEC, hintText: "اسم المستخدم ", obscureText: false),
                            DefaultTextInput(tec: cubit.passwordTEC, hintText: "كلمة السر", obscureText: cubit.visibility,suffixIcon: cubit.visibility
                                ? IconButton(
                                onPressed: () {
                                  cubit.onvisibilty();
                                },
                                icon: Icon(Icons.visibility))
                                : IconButton(
                                onPressed: () {
                                  cubit.offVisibility();
                                },
                                icon: Icon(Icons.visibility_off)),),

                            ButtonStart(onPrimary: Colors.white, primary: Color(0xff950054), onPressed: (){
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      height: height/2,
                                      child: Image.asset('assets/images/men-face-winkling.gif',),
                                    ),
                                  );
                                },
                              );
                              cubit.Sigin();

                              }  , text: "Sign in", minimumSizeX: double.infinity, minimumSizeY: 50, paddingHorizontal: 15 , fontSize: 25, radius: 15),
                            DefaultTextButton(text: "Forget Password ?", onPressed: (){

                            }, txtColor: Color(0xff950054))
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }, listener: (BuildContext context, state){
        if(state is SignINSccess){
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const WebViewCreen()));
        }else if(state is SignINError){
          Navigator.pop(context);
        }
        //

      }),
    );
  }
}
