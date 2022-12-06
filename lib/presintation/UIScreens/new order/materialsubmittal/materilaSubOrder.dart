import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/app_cubit.dart';
import '../../../widgets/inputText/inputText.dart';
class MaterialSubOrderScreen extends StatefulWidget {
  final String projectid;
  const MaterialSubOrderScreen({Key? key,required this.projectid}) : super(key: key);

  @override
  State<MaterialSubOrderScreen> createState() => _MaterialSubOrderScreenState();
}

class _MaterialSubOrderScreenState extends State<MaterialSubOrderScreen> {
  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return BlocProvider(create: (BuildContext context)=>AppCubit(),
    child: BlocConsumer<AppCubit,AppState>(
      builder: (BuildContext context,state){
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(title: Text('اعتماد مواد بناء',style: TextStyle(color: Color(0xff01579b),fontWeight: FontWeight.w600),),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios),color: Color(0xff01579b)),
          elevation: 0,),
        body:SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('مرجع المواصفات :',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),
                    DefaultTextInput(tec: cubit.tecSpecification, hintText: 'مرجع المواصفات', obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('المواصفات الأصلية للرسومات التفصيلية:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),

                    DefaultTextInput(tec: cubit.tecSpecificationOriginal, hintText: 'المواصفات الأصلية للرسومات التفصيلية', obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('الرسومات التفصيلية المقدمة:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),

                    DefaultTextInput(tec: cubit.tecSpecificationOriginal, hintText: 'الرسومات التفصيلية المقدمة:', obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('بنود قائمة الأسعار والكميات:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),

                    DefaultTextInput(tec: cubit.tecSpecificationOriginal, hintText: 'بنود قائمة الأسعار والكميات:', obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('مرجع الرسومات:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),
                    DefaultTextInput(tec: cubit.tecSpecificationOriginal, hintText: 'مرجع الرسومات:', obscureText: false),
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('الوصف',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),
                    Container(
                        margin: EdgeInsets.only(top: 16,left: 16,right: 16),
                        child: Text('إجمالى الكميات:',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)),
                    Row(
                      children: [
                        Flexible(child: DefaultTextInput(tec: cubit.tecSpecificationOriginal, hintText: 'بنود قائمة الأسعار والكميات:', obscureText: false,)),
                        Flexible(child: Column(children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_up)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.keyboard_arrow_down_rounded))
                        ],))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      },
      listener: (BuildContext context, state){

      },
    ),
    );

  }
}
