// ignore_for_file: depend_on_referenced_packages, file_names, non_constant_identifier_names

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:venturo_test/API/DataModel.dart';

part 'Dao.g.dart';

@RestApi(baseUrl: 'https://tes-mobile.landa.id/api')
abstract class ApiService{
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/menus')
  Future<ResponseApi> getMenus();

  @GET('/vouchers')
  Future<ResponseVourcher> CheckVourcher(@Query('kode') String kode);

  @POST('/order')
  Future<ResponseOrder> OrderRequest(@Body() String body);

  @POST('/order/cancel/{id}')
  Future<ResponseCancel> CancelOrder(@Path() int id);
}