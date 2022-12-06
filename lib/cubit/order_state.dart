part of 'order_cubit.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}

class GetinspectionrequstSucessState extends OrderState {}
class GetinspectionrequstErorrState extends OrderState {}
class DropDownApprovedInspectionsvalueState extends OrderState {}
class GetRequestFloorListState extends OrderState {}
class AddphotoSucess extends OrderState {}
class UploadphotoSucessState extends OrderState {}
class UploadphotoErorrState extends OrderState {}
class openSendState extends OrderState {}
class closeSendState extends OrderState {}
class AddphotoError extends OrderState {}
class ConfirmSignitrueStateSucess extends OrderState {}
class ConfirmSignitrueStateErorr extends OrderState {}
class RadioButtonState extends OrderState {}
class concreteRadioButtonState extends OrderState {}
class SendDataSucessState extends OrderState {}
class SendDataErorrState extends OrderState {}
class setDtaetimeState extends OrderState {}
class SendDataStateSucess extends OrderState {}
class SendDataStateErorr extends OrderState {}
class godownstate extends OrderState {}

