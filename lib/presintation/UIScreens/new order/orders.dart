import 'package:flutter/material.dart';
import 'package:sketch/presintation/UIScreens/iwarehouseScreen.dart';

import '../../widgets/container/container.dart';
import 'concreteorder/concreteorderScreen.dart';
import 'materialsubmittal/materilaSubOrder.dart';
import 'neworderScreen.dart';
import 'siteDiaryOrderScreen.dart';
class OrdersScreen extends StatefulWidget {
  final String projectid;
  const OrdersScreen({Key? key,required this.projectid}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back_ios,color: Color(0xff01579b)),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("اختار طلب",style: TextStyle(color: Color(0xff01579b),fontWeight: FontWeight.w600),),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:
              [
                SizedBox(height: 16,),
                ContainerOrder(text: 'طلب معاينة',onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NewOrderScreen(projectid: '${widget.projectid}',)));
                },),
                SizedBox(height: 16,),
                ContainerOrder(text: 'دفتر زيارة يومي',onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> SiteDiaryScreen()));},),
                SizedBox(height: 16,),
                ContainerOrder(text: 'اعتماد مواد بناء',onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MaterialSubOrderScreen(projectid: '${widget.projectid}',)));
                },),
                SizedBox(height: 16,),
                ContainerOrder(text: 'اعتماد رسومات تنفيذية',onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>IwareHousScreen()));},),
                SizedBox(height: 16,),
                ContainerOrder(text: 'اعتماد مقاول باطن',onPressed: (){},),
                SizedBox(height: 16,),
                ContainerOrder(text: 'طلب استفهام',onPressed: (){},),
                SizedBox(height: 16,),
                ContainerOrder(text: 'طلب دفعة من المقاول',onPressed: (){},),
                SizedBox(height: 16,),
                ContainerOrder(text: 'طلب اعتماد تغير عن العقد',onPressed: (){},),
                SizedBox(height: 16,),
                ContainerOrder(text: 'طلب موعد صب خرسانه',onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ConcreateOrderScreen(projectid: '${widget.projectid}')));
                },),
                SizedBox(height: 16,),
                ContainerOrder(text: 'نتائج أختبارات',onPressed: (){},),
                SizedBox(height: 16,),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
