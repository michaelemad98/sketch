import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch/cubit/app_cubit.dart';
import 'package:sketch/function/sharedprefrenc.dart';
import 'package:sketch/presintation/widgets/buttons/buttonstart.dart';
import 'package:sketch/presintation/widgets/containerprofile/containerprofile.dart';
import 'package:sketch/presintation/widgets/inputText/inputText.dart';

import '../../../constant/compontents.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override

  // String? profilePhoto,profileusername,profilesignatureVPath,profilemobile,profileemail,profilefullNameAr,profilefullNameEn;
  bool isloading=true;
  bool  showdialog=false;
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return BlocProvider(create: (BuildContext context)=> AppCubit()..GetProfile(),
    child: BlocConsumer<AppCubit, AppState>(
      builder: (BuildContext context, state){
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation:1,
          title: Text('الملف الشخصي',style: TextStyle(color: Color(0xff01579b),fontWeight: FontWeight.w600),),
          centerTitle: true,
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: (Icon(Icons.arrow_back_ios,color:Color(0xff01579b) ,)),),
        ),
        body:isloading?
        Center(child: Image.asset('assets/images/men-face-winkling.gif',)):
        Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(16),
                  child: CircleAvatar(child: cubit.profilePhoto==''?Image.asset('assets/images/worker.png'):Image.network('${cubit.profilePhoto}'),backgroundColor: Colors.transparent,radius: 45,)),
              Container(
                  margin: EdgeInsets.all(16),
                  child: ContainerProfile(titletext: "البريد الإلكترونى",bodytext: "${cubit.profileemail}",)),
              Container(
                  margin: EdgeInsets.all(16),
                  child: ContainerProfile(titletext: "رقم الهاتف",bodytext: "${cubit.profilemobile}",)),
              Container(margin: EdgeInsets.all(16), child: ContainerProfile(titletext: "اسم كامل بالعربية",bodytext: "${cubit.profilefullNameAr}",)),
              Container(margin: EdgeInsets.all(16), child: ContainerProfile(titletext: "اسم كامل بالانجليزية",bodytext: "${cubit.profilefullNameEn}",)),
              ButtonStart(onPrimary: Colors.white, primary: Color(0xff01579b), onPressed: (){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Stack(
                        children: [
                          Container(
                            height: height/4,
                            child:
                            (cubit.myfile!=null)?Stack(
                              children: [
                                Image.file(
                                  cubit.myfile!,
                                  fit: BoxFit.cover,
                                ),
                                IconButton(onPressed: (){cubit.DeltetPhoto();}, icon: Icon(Icons.clear,color: Colors.white,))
                              ],
                            )
                            :Image.network("${cubit.profilesignatureVPath}",width: double.infinity,)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,color: Colors.red,),),
                              IconButton(onPressed: (){
                                showModalBottomSheet(context: context, builder: (context)=>Container(
                                  height: height*0.15,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          padding:EdgeInsets.all(10),
                                          child: Text(
                                              'اختار صورة من المعرض'
                                          ),),
                                        onTap: (){
                                          cubit.AddPhotoGalary();
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          cubit.AddPhotoCamera();
                                        },
                                        child: Container(
                                          padding:EdgeInsets.all(10),
                                          child: Text(
                                              'صورة من الكاميرة'
                                          ),),
                                      ),
                                    ],
                                  ),
                                ));
                              }, icon: Icon(Icons.edit,color: Colors.blue.shade900,),),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }, text: 'التوقيع', minimumSizeX: width/5, minimumSizeY:height /12, paddingHorizontal: 25, fontSize: 16  , radius: 16),
              (cubit.myfile!=null)?Column(
                children: [
                  Stack(
                    children: [
                      Image.file(
                        cubit.myfile!,
                        fit: BoxFit.cover,
                      ),
                      IconButton(onPressed: (){cubit.DeltetPhoto();}, icon: Icon(Icons.clear,color: Colors.red,)),

                    ],

                  ),

                  cubit.isshowDialog? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff019b22), // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                height: height/2,
                                child: ListView(
                                  children: [
                                    DefaultTextInput(tec: cubit.sigpass, hintText: "كلمة مرور التوقيع", obscureText: cubit.visibility),
                                    DefaultTextInput(tec: cubit.confirmsigpass, hintText: "تأكيد كلمة مرور التوقيع", obscureText: cubit.visibility,),
                                    DefaultTextInput(tec: cubit.profpass, hintText: "كلمةالمرور", obscureText: cubit.visibility,),
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
                                            child: Text('الغاء'),
                                          ),
                                          SizedBox(width: 16,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xff019b22), // background
                                              onPrimary: Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return Dialog(
                                                    child: Container(
                                                      height: height/9,
                                                      child: new Row(
                                                        crossAxisAlignment:CrossAxisAlignment.center ,
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          new CircularProgressIndicator(),
                                                          new Text(""),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              cubit.SavePhoto();
                                            },
                                            child: Text('حفظ'),
                                          )

                                        ]
                                    )

                                  ],
                                ),
                              )
                          );
                        },
                      );
                    },
                    child: Text('حفظ'),
                  ):Container()
                ],
              )
                  :Image.network("${cubit.profilesignatureVPath}",width: double.infinity,),
              GestureDetector(onTap: (){
                cubit.ShowChangeassword();
              },child: Container(margin: EdgeInsets.all(16), child: ContainerProfile(titletext: "",bodytext: "تغيير كلمة المرور",))),
              cubit.isChangepassordShow?Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    height: height/2,
                    child: ListView(
                      children: [
                        DefaultTextInput(tec: cubit.profilePassord, hintText: "كلمة المرور الحالية", obscureText: cubit.visibility,),
                        DefaultTextInput(tec: cubit.newprofilePassord, hintText: "كلمة المرور الجديدة", obscureText: cubit.visibility,),
                        DefaultTextInput(tec: cubit.confimprofilePassord, hintText: "تأكيد كلمة المرور", obscureText: cubit.visibility,),
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
                                child: Text('الغاء'),
                              ),
                              SizedBox(width: 16,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff019b22), // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  if(cubit.newprofilePassord.text !=cubit.confimprofilePassord.text){
                                    showToast(text: 'كلمة المرور غير متطابقان', state: ToastState.WARNING);
                                  }else{
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            height: height/9,
                                            child: new Row(
                                              crossAxisAlignment:CrossAxisAlignment.center ,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                new CircularProgressIndicator(),
                                                new Text(""),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    cubit.ChangeProfilePassword();
                                  }
                                },
                                child: Text('حفظ'),
                              )

                            ]
                        )

                      ],
                    ),
                  ),
                  IconButton(onPressed: (){cubit.HideChangeassword();}, icon: Icon(Icons.clear,color: Colors.red,))
                ],
              ):Container(),
            ],
      ),
          ),
        ),);
      },
    listener:  (BuildContext context, state){
      if(state is GetProfileSucess){
        isloading= false;
      }
      else if(state is AddphotoSucess){
        Navigator.pop(context);
        Navigator.pop(context);
      }else if(state is ChangePaswordSucsess){
        showToast(text: 'تم تغير التوقيع', state: ToastState.SUCCESS);
      }else if(state is ChangePaswordError){
        // Navigator.pop(context);
      }else if(state is ChangeprofilePaswordError){
        Navigator.pop(context);
      }else if(state is ChangeprofilePaswordSucsess){
        Navigator.pop(context);
        showToast(text: 'تم تغير كلمة السر بنجاخ', state: ToastState.SUCCESS);
        CacheHelper.saveData(key: 'islogin', value: false);
      }

    },
    ));
  }
}
/*

          showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      height: height/2,
                      child: ListView(
                        children: [
                          DefaultTextInput(tec: cubit.passwordTEC, hintText: "كلمة مرور التوقيع", obscureText: cubit.visibility,suffixIcon: cubit.visibility
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
                          DefaultTextInput(tec: cubit.passwordTEC, hintText: "تأكيد كلمة مرور التوقيع", obscureText: cubit.visibility,suffixIcon: cubit.visibility
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
                          DefaultTextInput(tec: cubit.passwordTEC, hintText: "كلمةالمرور", obscureText: cubit.visibility,suffixIcon: cubit.visibility
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
                                  child: Text('الغاء'),
                                ),
                                SizedBox(width: 16,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff019b22), // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  onPressed: () {


                                  },
                                  child: Text('حفظ'),
                                )

                              ]
                          )

                        ],
                      ),
                    )
                  );
                },
              );

 */