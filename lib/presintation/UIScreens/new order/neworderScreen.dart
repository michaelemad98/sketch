import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sketch/cubit/app_cubit.dart';
import 'package:sketch/presintation/UIScreens/new%20order/screen.dart';
import 'package:sketch/presintation/widgets/buttons/buttonorder.dart';
import 'package:sketch/presintation/widgets/inputText/inputText.dart';

import '../../../constant/compontents.dart';
import '../../../function/sharedprefrenc.dart';
import '../webview/webviwe.dart';

class NewOrderScreen extends StatefulWidget {
  final String projectid;

  const NewOrderScreen({Key? key, required this.projectid}) : super(key: key);

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
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
          AppCubit()..AddProject(widget.projectid),
      child: BlocConsumer<AppCubit, AppState>(
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          int _value = 1;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'طلب معاينة',
                style: TextStyle(
                    color: Color(0xff01579b), fontWeight: FontWeight.w600),
              ),
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
              child: Container(
                padding: EdgeInsets.all(16),
                child: ListView(
                  controller:scrollController ,
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
                    // ButtonOrder(onPressed: (){cubit.UploadPhoto();}, text: 'أرسال'),
                    DefaultTextInput(
                        tec: cubit.tablnumberTEC,
                        hintText: 'رقم جدول كميات',
                        obscureText: false),
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 250,
                      width: double.infinity,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 0,
                            childAspectRatio: 3,
                          ),
                          itemCount: cubit.WorkTypes.length,
                          itemBuilder: (BuildContext context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Radio(
                                    value: '${cubit.WorkTypes[index]['id']}',
                                    groupValue: cubit.valueG,
                                    onChanged: (value) {
                                      cubit.OnRadioButton(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                        '${cubit.WorkTypes[index]['name']}'))
                              ],
                            );
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      child: Text(
                        'وصف الأعمال',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        height: 100,
                        child: Column(
                          children: [
                            Text('الوصف الرئيسى'),
                            Expanded(
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
                                  Expanded(
                                    child: Text(
                                      'الوصف الرئيسى',
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
                              items: cubit.WorkTypesCategories.map(
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
                              value: cubit.dropdownWorkmainvalu,
                              onChanged: (value) {
                                setState(() {
                                  cubit.dropdownWorkmainvalu = value as String?;
                                  print(value);
                                  cubit.GetRespon(value);
                                });
                              },
                            ))),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        children: [
                          Text('الوصف الفرعى'),
                          Expanded(
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
                                Expanded(
                                  child: Text(
                                    'الوصف الفرعى',
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
                            items: cubit.Worksuptypchild.map(
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
                            value: cubit.dropdownWorksupvalu,
                            onChanged: (value) {
                              setState(() {
                                cubit.dropdownWorksupvalu = value as String?;
                                cubit.GetPlacee();
                                cubit.AddLitsWorkSup(value);
                              });
                            },
                          ))),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text('توصيف تفصيلى'),
                          DefaultTextInput(
                              tec: cubit.detailedDescriptionTEC,
                              hintText: 'توصيف تفصيلى',
                              obscureText: false),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cubit.GetPlacee();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: Text(
                          'المكان',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        children: [
                          Text('نوع المبني'),
                          Expanded(
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
                                Expanded(
                                  child: Text(
                                    'نوع المبنى',
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
                            items: cubit.places
                                .map((item) => DropdownMenuItem<Object>(
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
                                    ))
                                .toList(),
                            value: cubit.dropdownplacesvalu,
                            onChanged: (value) {
                              setState(() {
                                cubit.dropdownplacesvalu = value as String?;
                                print(value);
                                cubit.GetFloor(value);
                              });
                            },
                          ))),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        children: [
                          Text('الادوار'),
                          Expanded(
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
                                Expanded(
                                  child: Text(
                                    'الادوار',
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
                            items: cubit.Floors.map(
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
                            value: cubit.dropdownfloorsvalu,
                            onChanged: (value) {
                              setState(() {
                                cubit.dropdownfloorsvalu = value as String?;
                                print(value);
                                cubit.GetDWGNumebers();
                                cubit.AddFlorsValue(value);
                              });
                            },
                          ))),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        children: [
                          Text('نوع الرسومات'),
                          Expanded(
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
                                Expanded(
                                  child: Text(
                                    'نوع الرسومات',
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
                            items: cubit.DWGNumebers.map(
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
                            value: cubit.dropdownGetDWGNumebersalu,
                            onChanged: (value) {
                              setState(() {
                                cubit.dropdownGetDWGNumebersalu =
                                    value as String?;
                                print(value);
                                cubit.Getplates(value);
                              });
                            },
                          ))),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        children: [
                          Text('أرقام اللوحات'),
                          Expanded(
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
                                Expanded(
                                  child: Text(
                                    'أرقام اللوحات',
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
                            items: cubit.platesnumber
                                .map((item) => DropdownMenuItem<Object>(
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
                                    ))
                                .toList(),
                            value: cubit.dropdownplatessvalu,
                            onChanged: (value) {
                              setState(() {
                                cubit.dropdownplatessvalu = value as String?;
                                print(value);
                                cubit.AddtolistPlate(value);
                              });
                            },
                          ))),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 50,
                    //   child:  ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: cubit.listpalte.length,
                    //       itemBuilder: (context,index){
                    //         return Row(children: [
                    //           Text("${cubit.listpalte[index]}"),
                    //           IconButton(onPressed: (){
                    //             cubit.RemoveListplate(cubit.listpalte[index]);
                    //           }, icon: Icon(Icons.clear))
                    //         ],);
                    //       }),
                    // ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: Text(
                          'الطلب المقدم من المقاول للمعاينة',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text('تاريخ المعاينة المطلوب'),
                              GestureDetector(
                                onTap: () async {
                                  cubit.date = (await showDatePicker(
                                      context: context,
                                      initialDate: cubit.date,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100)))!;
                                  cubit.SetDtaetime();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  padding: EdgeInsets.only(
                                      left: 25, top: 5, right: 25),
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
                                  child: Text(
                                      '${cubit.date.year}-${cubit.date.month}-${cubit.date.day}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text('وقت المعاينة المطلوب'),
                              GestureDetector(
                                onTap: () async {
                                  cubit.time = (await showTimePicker(
                                      context: context,
                                      initialTime:
                                          TimeOfDay(hour: 12, minute: 00)))!;
                                  cubit.SetDtaetime();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(15),
                                  padding: EdgeInsets.only(
                                      left: 25, top: 5, right: 25),
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
                                  child: Text(
                                      '${cubit.time.hour} ${cubit.time.minute}'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: Text(
                          'مرفقات المقاول',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(
                      'الاوراق المطلوبة',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      '1- صور الموقع - Photos of the site (العدد 3)',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.red),
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
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('التصنيف'),
                          Expanded(
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
                            items: cubit.catigory
                                .map((item) => DropdownMenuItem<Object>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: cubit.dropdownCategoryvalu,
                            onChanged: (value) {
                              setState(() {
                                cubit.dropdownCategoryvalu = value as String?;
                                print(value);
                              });
                            },
                          ))),
                          Text('الوصف'),
                          DefaultTextInput(
                              tec: cubit.dESCRIPTIONDescriptionTEC,
                              hintText: 'الوصف',
                              obscureText: false),
                          Text('المرفقات'),
                          ButtonOrder(
                              backgroundColor: Color(0xff01579b),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                          height: height * 0.15,
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                      'اختار صورة من المعرض'),
                                                ),
                                                onTap: () {
                                                  cubit
                                                      .AddPhotoAttachmentGalary();
                                                },
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  cubit
                                                      .AddPhotoAttachmentCamera();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child:
                                                      Text('صورة من الكاميرة'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                              },
                              text: 'المرفقات'),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),

                    cubit.imageFileList!.length > 0
                        ? Container(
                            height: height * 0.4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemCount: cubit.imageFileList!.length,
                              itemBuilder: (context, index) {
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
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    ButtonOrder(
                        onPressed: () {
                          cubit.openSend();

                          setState(() {

                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeIn);
                          });
                        },
                        text: 'ادراج التوقيع'),
                    cubit.isSend
                        ? Column(
                            children: [
                              Text(
                                'التوقيع',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              DefaultTextInput(
                                  tec: cubit.signiturpasstec,
                                  hintText: 'كلمة المرور',
                                  obscureText: true),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Color(0xffd0d0d0), // background
                                            onPrimary:
                                                Color(0xff01579b), // foreground
                                          ),
                                          onPressed: () {
                                            cubit.closeSend();
                                          },
                                          child: Text('الغاء'),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Color(0xff019b22), // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                    child: Image.asset(
                                                  'assets/images/men-face-winkling.gif',
                                                  fit: BoxFit.cover,
                                                ));
                                              },
                                            );
                                            cubit.ConfirmSignitrue();
                                            setState(() {
                                              scrollController.animateTo(
                                                  scrollController.position.maxScrollExtent,
                                                  duration: Duration(seconds: 1),
                                                  curve: Curves.easeIn);
                                            });
                                          },
                                          child: Text('حفظ'),
                                        )
                                      ])
                                ],
                              )
                            ],
                          )
                        : Container(),
                    isSend
                        ? Image.network(
                            '${cubit.signitureConfirmimg}',
                            fit: BoxFit.cover,
                          )
                        : Container(),

                    isSend
                        ? cubit.isloadsending?CircularProgressIndicator():ButtonOrder(
                            onPressed: () {
                              setState(() {
                                cubit.isloadsending=true;
                              });
                              cubit.SendData();
                            },
                            text: 'أرسال')
                        : Container(),
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
          } else if (state is ConfirmSignitrueStateErorr) {
            Navigator.pop(context);
            showToast(text: 'حدث خطاء', state: ToastState.ERROR);
          } else if (state is SendDataStateSucess) {
            showToast(text: 'تم ارسال الطلب بنجاح', state: ToastState.SUCCESS);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WebViweScreen()));
          } else if (state is SendDataStateErorr) {
            showToast(text: 'حدث خطاء', state: ToastState.ERROR);
          }
        },
      ),
    );
  }
}
