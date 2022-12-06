part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}
class Visibility extends AppState{}
class UnVisibility extends AppState{}
class SignINSccess extends AppState{}
class SignINError extends AppState{}
class SendTokenSucess extends AppState{}
class SendTokenError extends AppState{}
class GetProfileSucess extends AppState{}
class GetProfileErorr extends AppState{}
class AddphotoSucess extends AppState{}
class AddphotoError extends AppState{}
class DeletepotoSucsess extends AppState{}
class ChangePaswordSucsess extends AppState{}
class ChangePaswordError extends AppState{}
class ChangeprofilePaswordSucsess extends AppState{}
class ChangeprofilePaswordError extends AppState{}
class ChangeprofilePaswordWarining extends AppState{}
class ShowChangeasswordstate extends AppState{}
class HideChangeasswordstate extends AppState{}


class GetProjectstateSucsess extends AppState{}
class GetProjectstateErorr extends AppState{}
class AddProjecttateSucsess extends AppState{}
class AddProjectstateErorr extends AppState{}

class ButtonColorState extends AppState{}
class DropDownWorkState extends AppState{}
class DropDownWorksupState extends AppState{}

class GetPlacesStateSucess extends AppState{}
class GetPlacesStateError extends AppState{}
class DropDownplacesState extends AppState{}
class AddListplateState extends AppState{}
class RemoveListplateState extends AppState{}
class setDtaetimeState extends AppState{}
class openSendState extends AppState{}
class closeSendState extends AppState{}
class ConfirmSignitrueStateSucess extends AppState{}
class ConfirmSignitrueStateErorr extends AppState{}
class SendDataStateSucess extends AppState{}
class SendDataStateErorr extends AppState{}
class UploadphotoSucessState extends AppState {}
class UploadphotoErorrState extends AppState {}