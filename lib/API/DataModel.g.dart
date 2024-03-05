// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseApi _$ResponseApiFromJson(Map<String, dynamic> json) => ResponseApi(
      statusCode: json['statusCode'] as int?,
      datas: (json['datas'] as List<dynamic>?)
          ?.map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseApiToJson(ResponseApi instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'datas': instance.datas,
    };

ResponseCancel _$ResponseCancelFromJson(Map<String, dynamic> json) =>
    ResponseCancel(
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResponseCancelToJson(ResponseCancel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
    };

ResponseVourcher _$ResponseVourcherFromJson(Map<String, dynamic> json) =>
    ResponseVourcher(
      status_code: json['status_code'] as int?,
      datas: json['datas'] == null
          ? null
          : Vourcher.fromJson(json['datas'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseVourcherToJson(ResponseVourcher instance) =>
    <String, dynamic>{
      'status_code': instance.status_code,
      'datas': instance.datas,
    };

ResponseOrder _$ResponseOrderFromJson(Map<String, dynamic> json) =>
    ResponseOrder(
      id: json['id'] as int?,
      status_code: json['status_code'] as int?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResponseOrderToJson(ResponseOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status_code': instance.status_code,
      'message': instance.message,
    };

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      id: json['id'] as int?,
      nama: json['nama'] as String?,
      harga: json['harga'] as int?,
      tipe: json['tipe'] as String?,
      gambar: json['gambar'] as String?,
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'harga': instance.harga,
      'tipe': instance.tipe,
      'gambar': instance.gambar,
    };

Vourcher _$VourcherFromJson(Map<String, dynamic> json) => Vourcher(
      id: json['id'] as int?,
      kode: json['kode'] as String?,
      nominal: json['nominal'] as int?,
    );

Map<String, dynamic> _$VourcherToJson(Vourcher instance) => <String, dynamic>{
      'id': instance.id,
      'kode': instance.kode,
      'nominal': instance.nominal,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      nominal_diskon: json['nominal_diskon'] as String?,
      nominal_pesanan: json['nominal_pesanan'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ItemOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'nominal_diskon': instance.nominal_diskon,
      'nominal_pesanan': instance.nominal_pesanan,
      'items': instance.items,
    };

ItemOrder _$ItemOrderFromJson(Map<String, dynamic> json) => ItemOrder(
      id: json['id'] as int?,
      harga: json['harga'] as int?,
      catatan: json['catatan'] as String?,
    );

Map<String, dynamic> _$ItemOrderToJson(ItemOrder instance) => <String, dynamic>{
      'id': instance.id,
      'harga': instance.harga,
      'catatan': instance.catatan,
    };
