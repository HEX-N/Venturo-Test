// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:image_network/image_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venturo_test/API/Dao.dart';
import 'package:dio/dio.dart';
import 'package:venturo_test/API/DataModel.dart';
import 'package:venturo_test/main.dart';

class DetailOrder extends StatefulWidget{
  final Map<String, dynamic> data;
  final int harga;
  final int diskon;
  final int total;
  final int totalPesanan;
  const DetailOrder({super.key, required this.data, required this.harga, required this.diskon, required this.total, required this.totalPesanan});
  @override
  State<DetailOrder> createState() => _DetailOrder();
}

class _DetailOrder extends State<DetailOrder> {
  int? id;
  int? harga = 0;
  int? jumlahSemua = 0;
  int? hargaSemua;
  ResponseOrder? resultApi;
  ApiService apiService = ApiService(Dio());

  @override
  void initState() {
    super.initState();
    checkPesanan();
  }

  Future<void> checkPesanan() async {
    // var result = await http.post(Uri.parse("https://tes-mobile.landa.id/api/order"), body: jsonEncode(widget.data), headers: {"Content-Type": "application/json"});
    // var resultdata = jsonDecode(result.body);
    var result = await apiService.OrderRequest(jsonEncode(widget.data));
    if (result.id == null) {
      Navigator.pop(context);
    } else {
      resultApi = result;
      id = result.id;
    }
  }

  void comback() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return MyHomePage(title: 'Flutter Demo Home Page', isreset: true);
        }),
        (Route<dynamic> route) => false,
      );
  }

  Future cancelPesanan(String params, BuildContext con) async {
    var data = await apiService.CancelOrder(id!);
    if (data.statusCode == 200) {
      comback();
    } else {
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  Future<void> _showMyDialog(BuildContext con) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.ac_unit),
                    SizedBox(width: 10,),
                    Expanded(child: Text('Apakah anda yakin ingin membatalkan pesanan ini?', textAlign: TextAlign.left,))
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Yakin'),
              onPressed: () {
                Navigator.of(context).pop();
                cancelPesanan(id.toString(), con);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.topCenter,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: FutureBuilder(
                future: apiService.getMenus(),
                builder: (con, snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    ResponseApi data = snap.data!;
                    jumlahSemua = jumlahSemua! + data.datas!.length;
                    return ListView.builder(
                      itemCount: data.datas!.length,
                      itemBuilder: (context, index) {
                        int jumlah = 0;
                        String catatan = "";
                        List<Map<String, dynamic>> dataSmt = widget.data['items'];
                        for (var element in dataSmt) { 
                          if (element['id'] == data.datas![index].id!) {
                            if (element['catatan'] == '-') {
                              element['catatan'] = "";
                            }
                            catatan = element['catatan'];
                            jumlah++;
                          }
                        }
                        return Opacity(
                          opacity: (jumlah == 0) ? 0.30 : 1,
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 80),
                            margin: const EdgeInsets.all(10),
                            child: Expanded(
                              child: Card(
                                elevation: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ImageNetwork(image: data.datas![index].gambar!, width: 50, height: 50,),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data.datas![index].nama!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                                            Text('Rp.${data.datas![index].harga!.toString()}'),
                                            Text(catatan),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(child: Text(jumlah.toString())),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }
              )
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [ 
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4,child: Text('Total Pesanan (${widget.totalPesanan} Menu):'),),
                          Expanded(child: Text('Rp.${widget.harga}', textAlign: TextAlign.right,))
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Icon(Icons.confirmation_num),
                                SizedBox(width: 10,),
                                Text('Vourcher'),
                              ],
                            )
                          ),
                          Expanded(
                            child: Text('${widget.diskon}', textAlign: TextAlign.right,)
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.shopping_bag_rounded),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total Pembayaran'),
                                    Text('Rp.${widget.total}')
                                  ],
                                )
                              ],
                            )
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 154, 173, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              height: 40,
                              width: 50,
                              child: TextButton(
                                onPressed: () {
                                  _showMyDialog(context);
                                },
                                child: const Text('Batalkan'),
                              )
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
          ]
        )
      ),
    );
  }
}