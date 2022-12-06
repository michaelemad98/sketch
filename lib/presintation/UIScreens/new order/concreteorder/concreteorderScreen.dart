import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
import 'package:sketch/presintation/UIScreens/webview/webviwe.dart';
import 'package:sketch/presintation/widgets/buttons/buttonorder.dart';
import 'package:sketch/presintation/widgets/inputText/inputText.dart';

import '../../../../constant/compontents.dart';
import '../../../../cubit/order_cubit.dart';

class ConcreateOrderScreen extends StatefulWidget {
  String? projectid;

  ConcreateOrderScreen({Key? key, this.projectid}) : super(key: key);

  @override
  State<ConcreateOrderScreen> createState() => _ConcreateOrderScreenState();
}

class _ConcreateOrderScreenState extends State<ConcreateOrderScreen> {
  bool isSend = false;
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return BlocProvider(
      create: (BuildContext context) =>
          OrderCubit()..Getinspectionrequst(widget.projectid!),
      child: BlocConsumer<OrderCubit, OrderState>(
        builder: (BuildContext context, state) {
          OrderCubit cubit = OrderCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'طلب موعد صب خرسانة',
                style: TextStyle(
                    color: Color(0xff01579b), fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color(0xff01579b)),
              elevation: 0,
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'رقم جدول كميات :',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    DefaultTextInput(
                        tec: cubit.tablnumberTEC,
                        hintText: 'رقم جدول كميات',
                        obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'أرقام طلب المعاينة المعتمد :',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.pink),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(10),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'اأرقام طلب المعاينة المعتمد',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Colors.blue,
                        ),
                        items: cubit.ApprovedInspectionsname.map(
                            (item) => DropdownMenuItem<Object>(
                                  value: item['id'].toString(),
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                        value: cubit.approvedInspectionsvalue,
                        onChanged: (value) {
                          setState(() {
                            cubit.approvedInspectionsvalue = value as String?;
                            print(value);
                            cubit.GetApprovedInspectionsCastingDescription(
                                '$value');
                            cubit.GetRequestFloorList(value!);
                          });
                        },
                      )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'اسم مورد :',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    DefaultTextInput(
                        tec: cubit.SupplierNameTec,
                        hintText: 'اسم مورد',
                        obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'رقم هاتف مورد :',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    DefaultTextInput(
                        tec: cubit.SupplierphoneTec,
                        hintText: 'رقم هاتف مورد',
                        obscureText: false),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          cubit.ApprovedInspectionsCastingDescription == null
                              ? 'وصف الأعمال المراد صبها :'
                              : '  وصف الأعمال المراد صبها : ${cubit.ApprovedInspectionsCastingDescription}',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Text(
                                'نوع المبني :',
                                style: TextStyle(
                                    color: Color(0xff01579b),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900),
                              )),
                        ),
                        Flexible(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Text(
                                cubit.ApprovedInspectionsBuildingTypeName ==
                                        null
                                    ? ''
                                    : '${cubit.ApprovedInspectionsBuildingTypeName}',
                                style: TextStyle(
                                    color: Color(0xff01579b),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Text(
                                'الادوار :',
                                style: TextStyle(
                                    color: Color(0xff01579b),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900),
                              )),
                        ),
                        Flexible(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Text(
                                cubit.ApprovedInspectionsBuildingTypeFloor ==
                                        null
                                    ? ''
                                    : '${cubit.ApprovedInspectionsBuildingTypeFloor}',
                                style: TextStyle(
                                    color: Color(0xff01579b),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900),
                              )),
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'نوع وقوة الخرسانة :',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.pink),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(10),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'نوع وقوة الخرسانة',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Colors.blue,
                        ),
                        items: cubit.ConcreteGradeTypes.map(
                            (item) => DropdownMenuItem<Object>(
                                  value: item['id'].toString(),
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                        value: cubit.ConcreteGradeTypesvalue,
                        onChanged: (value) {
                          setState(() {
                            cubit.ConcreteGradeTypesvalue = value as String?;
                            print(value);
                            cubit.GetApprovedInspectionsCastingDescription(
                                '$value');
                            cubit.GetRequestFloorList(value!);
                          });
                        },
                      )),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'نوع الأسمنت :',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.pink),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(10),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'نوع الأسمنت',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down_circle_rounded,
                          color: Colors.blue,
                        ),
                        items: cubit.CementTypes.map(
                            (item) => DropdownMenuItem<Object>(
                                  value: item['id'].toString(),
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                        value: cubit.CementTypesvalue,
                        onChanged: (value) {
                          setState(() {
                            cubit.CementTypesvalue = value as String?;
                            print(value);
                            cubit.GetApprovedInspectionsCastingDescription(
                                '$value');
                            cubit.GetRequestFloorList(value!);
                          });
                        },
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: '1',
                          groupValue: cubit.valueG,
                          onChanged: (value) {
                            cubit.OnRadioButton(value);
                          },
                        ),
                        Text('مع بمب'),
                        Radio(
                          value: '0',
                          groupValue: cubit.valueG,
                          onChanged: (value) {
                            cubit.OnRadioButton(value);
                          },
                        ),
                        Text('بدون بمب')
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'كمية الخرسانة المتوقعة:',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    DefaultTextInput(
                        tec: cubit.concreteamountTec,
                        hintText: 'كمية الخرسانة المتوقعة',
                        obscureText: false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: '1',
                              groupValue: cubit.valueconcreteG,
                              onChanged: (value) {
                                cubit.OnconcreteRadioButton(value);
                              },
                            ),
                            Text('الخرسانة المسلحة'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: '0',
                              groupValue: cubit.valueconcreteG,
                              onChanged: (value) {
                                cubit.OnconcreteRadioButton(value);
                              },
                            ),
                            Text(' الخرسانه العادية')
                          ],
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Text(
                          'أى إضافات للخرسانه:',
                          style: TextStyle(
                              color: Color(0xff01579b),
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        )),
                    DefaultTextInput(
                        tec: cubit.AnyAddingConcreteTec,
                        hintText: 'أى إضافات للخرسانه',
                        obscureText: false),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                                child: Text('التاريخ المتوقع:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),
                            IconButton(onPressed: ()async{
                              cubit.date = (await showDatePicker(
                              context: context,
                              initialDate: cubit.date,
                                  firstDate: DateTime(2000),
                              lastDate: DateTime(2100)))!;
                              cubit.SetDtaetime();
                            }, icon: Icon(Icons.calendar_month)),
                            cubit.formatDate == null? Container():Text('${cubit.formatDate}'),

                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                                child: Text('الوقت المتوقع:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),
                            IconButton(onPressed: () async {
                              cubit.time = (await showTimePicker(
                                  context: context,
                                  initialTime:
                                  TimeOfDay(hour: 12, minute: 00)))!;
                              cubit.SetDtaetime();
                            }, icon: Icon(Icons.timer)),
                            Text('${cubit.time}'),
                          ],
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200

                      ),
                      child: Text('مرفقات المقاول',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),


                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      height:300,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('التصنيف'),
                          Expanded(child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'التصنيف',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                items: cubit.catigory.map((item) => DropdownMenuItem<Object>(
                                  value: item,
                                  child: Text( item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,),
                                )).toList(),
                                value: cubit.dropdownCategoryvalu,
                                onChanged: (value) {
                                  setState(() {
                                    cubit.dropdownCategoryvalu = value as String?;
                                    print(value);

                                  });
                                },
                              )
                          )),
                          Text('الوصف'),
                          DefaultTextInput(tec: cubit.dESCRIPTIONDescriptionTEC, hintText: 'الوصف', obscureText: false),
                          Text('المرفقات'),
                          ButtonOrder(
                              backgroundColor: Color(0xff01579b),
                              onPressed: (){
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
                                          cubit.AddPhotoAttachmentGalary();
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          cubit.AddPhotoAttachmentCamera();
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
                              }, text: 'المرفقات'),
                          SizedBox(height: 20,)
                        ],
                      ) ,
                    ),

                    cubit.imageFileList!.length>0?Container(
                      height:height *0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child:
                      GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemCount: cubit.imageFileList!.length,
                        itemBuilder: (context,index){
                          return Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Image.file(
                              File(cubit.imageFileList![index].path),
                              fit: BoxFit.cover,),
                          );
                        },


                      ),
                    ):Container(),

                    Center(
                      child: ButtonOrder(onPressed: (){cubit.openSend();
                        // cubit.uploadimage();
                        setState(() {

                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeIn);
                        });
                      }, text: 'ادراج التوقيع'),
                    ),

                    cubit.isSend?Column(
                      children: [
                        Text('التوقيع',style: TextStyle(fontWeight: FontWeight.bold),),
                        DefaultTextInput(tec: cubit.signiturpasstec, hintText: 'كلمة المرور', obscureText: true),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                      cubit.closeSend();
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
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                              child: Image.asset('assets/images/men-face-winkling.gif',
                                                fit: BoxFit.cover,
                                              )
                                          );
                                        },
                                      );

                                      cubit.ConfirmSignitrue();
                                      // cubit.UploadPhoto();
                                      // setState(() async{
                                      //   await cubit.scrollController.animateTo(cubit.scrollController.position.maxScrollExtent,duration:Duration(seconds: 1) ,curve:Curves.easeIn );
                                      // });

                                      setState(() {

                                        scrollController.animateTo(
                                            scrollController.position.maxScrollExtent,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.easeIn);
                                      });
                                    },
                                    child: Text('حفظ'),
                                  )

                                ]
                            )
                          ],
                        )
                      ],
                    ):Container(),
                    isSend?Image.network('${cubit.signitureConfirmimg}',fit: BoxFit.cover,):Container(),

                    isSend?  Container(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: cubit.isloadsending==true?CircularProgressIndicator():ButtonOrder(onPressed: (){
                          setState(() {
                            cubit.isloadsending=true;
                          });
                          cubit.SendData();

                        }, text: 'أرسال'),
                      ),
                    ):
                    Container(),
                    SizedBox(height: 30,)

                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, state) {
          if (state is ConfirmSignitrueStateSucess) {
            isSend = true;
            Navigator.pop(context);
          }else if(state is AddphotoSucess){
          // Navigator.pop(context);

          }

          else if (state is ConfirmSignitrueStateErorr) {
            Navigator.pop(context);
            showToast(text: 'حدث خطاء', state: ToastState.ERROR);
          }else if (state is SendDataStateSucess) {
            showToast(text: 'تم ارسال الطلب بنجاح', state: ToastState.SUCCESS);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WebViweScreen()));
          } else if (state is SendDataStateErorr) {
            showToast(text: 'حدث خطاء في الارسال', state: ToastState.ERROR);
          }
        },
      ),
    );
  }
}
