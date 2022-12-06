import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class IwareHousScreen extends StatefulWidget {
  const IwareHousScreen({Key? key}) : super(key: key);

  @override
  State<IwareHousScreen> createState() => _IwareHousScreenState();
  
}

class _IwareHousScreenState extends State<IwareHousScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetDate();
  }
  DateTime ?dateTime;
  GetDate()async{
    Dio dio = new Dio();
    try{
      Response response = await dio.get('https://iwarehouse-api.birdcloud.qa/Order/GetCustomerOrders?customerID=89');
      if(response.statusCode==200) {
        print(response.data['Data'][0]['CreatedDate']);
        var dateTime= DateTime.parse(response.data['Data'][0]['CreatedDate']);

        print("${dateTime.year}-${dateTime.month}-${dateTime.day}");
      }else{
        print('Hello');
      }
    }catch(e){}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(dateTime==null?'':"${dateTime!.year}-${dateTime!.month}-${dateTime!.day}",style: TextStyle(fontSize: 25),)),
    );
  }
}
