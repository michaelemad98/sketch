import 'package:flutter/material.dart';
class SiteDiaryScreen extends StatefulWidget {
  const SiteDiaryScreen({Key? key}) : super(key: key);

  @override
  State<SiteDiaryScreen> createState() => _SiteDiaryScreenState();
}

class _SiteDiaryScreenState extends State<SiteDiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios,color: Color(0xff01579b),),),
        title: Text('دفتر زيارة يومي',style: TextStyle(color: Color(0xff01579b),fontWeight: FontWeight.w600),),
      ),
      body: Directionality(textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               Flexible(child: Text("إسم المشروع :",style: TextStyle(fontSize: 20,color: Color(0xff01579b),fontWeight: FontWeight.w600),)),
                SizedBox(width: 16),
                Flexible(
                   child: Text("(4) عبداللطيف عبدالله ال محمود",style: TextStyle(fontSize: 20,color: Color(
                       0xff3e3e3e),fontWeight: FontWeight.w500),),
                 ),
             ],),
            SizedBox(height: 16,),
            Row(
              children: [
            Text("كود المشروع :",style: TextStyle(fontSize: 20,color: Color(0xff01579b),fontWeight: FontWeight.w600),),
            SizedBox(width: 16,),
            Text("SKSAA149",style: TextStyle(fontSize: 20,color: Color(
                0xff3e3e3e),fontWeight: FontWeight.w500),),
            ],),
            SizedBox(height: 16,),
            Text(" المالك :",style: TextStyle(fontSize: 20,color: Color(0xff01579b),fontWeight: FontWeight.w600),),
            Text("عبداللطيف عبدالله زيد آل محمود",style: TextStyle(fontSize: 20,color: Color(
                0xff3e3e3e),fontWeight: FontWeight.w500),),
            SizedBox(height: 16,),
            Text(" المقاول :",style: TextStyle(fontSize: 20,color: Color(0xff01579b),fontWeight: FontWeight.w600),),
            Text("شركة بلدرز قطر",style: TextStyle(fontSize: 20,color: Color(
                0xff3e3e3e),fontWeight: FontWeight.w500),),
            SizedBox(height: 16,),
            Row(
              children: [
                Text(" من :",style: TextStyle(fontSize: 20,color: Color(0xff01579b),fontWeight: FontWeight.w600),),
                Text("شركة بلدرز قطر",style: TextStyle(fontSize: 20,color: Color(
                    0xff3e3e3e),fontWeight: FontWeight.w500),),
                SizedBox(width: 20,),
                Text(" الى :",style: TextStyle(fontSize: 20,color: Color(0xff01579b),fontWeight: FontWeight.w600),),
                Text("علي حسن",style: TextStyle(fontSize: 20,color: Color(
                    0xff3e3e3e),fontWeight: FontWeight.w500),),
              ],
            )

          ],
        ),
      ),
      )
    );
  }
}
