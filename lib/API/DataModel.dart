// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'DataModel.g.dart';

@JsonSerializable()
class ResponseApi{
  int? statusCode;
  List<Menu>? datas;

  ResponseApi({this.statusCode, this.datas});

  factory ResponseApi.fromJson(Map<String, dynamic> json) => _$ResponseApiFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseApiToJson(this);
}

@JsonSerializable()
class ResponseCancel{
  int? statusCode;
  String? message;

  ResponseCancel({this.statusCode, this.message});

  factory ResponseCancel.fromJson(Map<String, dynamic> json) => _$ResponseCancelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseCancelToJson(this);
}

@JsonSerializable()
class ResponseVourcher{
  int? status_code;
  Vourcher? datas;

  ResponseVourcher({this.status_code, this.datas});

  factory ResponseVourcher.fromJson(Map<String, dynamic> json) => _$ResponseVourcherFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseVourcherToJson(this);
}

@JsonSerializable()
class ResponseOrder{
  int? id;
  int? status_code;
  String? message;

  ResponseOrder({this.id, this.status_code, this.message});

  factory ResponseOrder.fromJson(Map<String, dynamic> json) => _$ResponseOrderFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseOrderToJson(this);
}

@JsonSerializable()
class Menu{
  int? id;
  String? nama;
  int? harga;
  String? tipe;
  String? gambar;

  Menu({this.id, this.nama, this.harga, this.tipe, this.gambar});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}

@JsonSerializable()
class Vourcher{
  int? id;
  String? kode;
  int? nominal;

  Vourcher({this.id, this.kode, this.nominal});

  factory Vourcher.fromJson(Map<String, dynamic> json) => _$VourcherFromJson(json);
  Map<String, dynamic> toJson() => _$VourcherToJson(this);
}

@JsonSerializable()
class Order{
  String? nominal_diskon;
  String? nominal_pesanan;
  List<ItemOrder>? items;

  Order({this.nominal_diskon, this.nominal_pesanan, this.items});
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class ItemOrder{
  int? id;
  int? harga;
  String? catatan;

  ItemOrder({this.id, this.harga, this.catatan});
  factory ItemOrder.fromJson(Map<String, dynamic> json) => _$ItemOrderFromJson(json);
  Map<String, dynamic> toJson() => _$ItemOrderToJson(this);
}