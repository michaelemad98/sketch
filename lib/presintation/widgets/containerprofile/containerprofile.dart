import 'package:flutter/material.dart';
class ContainerProfile extends StatelessWidget {
  final String? titletext,bodytext;
  const ContainerProfile({Key? key,this.titletext,this.bodytext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin:EdgeInsets.only(left: 16 ,right: 16),
            child: Text('${titletext}',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900))),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16 ,right: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${bodytext}',style: TextStyle(color: Color(0xff01579b),fontSize: 16,fontWeight: FontWeight.w900),)
            ],
          ),

        ),
      ],
    );
  }
}
