// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, must_be_immutable, unused_local_variable

import 'package:image_network/image_network.dart';
import 'package:flutter/material.dart';
import 'package:venturo_test/API/Dao.dart';
import 'package:dio/dio.dart';
import 'package:venturo_test/API/DataModel.dart';
import 'package:venturo_test/page/detailOrderPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 77, 183, 187)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, this.isreset = false});
  final String title;
  bool isreset;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<Map>> list = [];
  List<String> listPesan = [];
  int menu = 0;
  int harga = 0;
  int harga_sebenarnya = 0;
  int diskon = 0;
  bool resetState = false;
  String vourcher_text = 'Input vourcher';
  ApiService apiService = ApiService(Dio());
  final _formKey = GlobalKey<FormState>();
  TextEditingController vourcher = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      harga = 0;
      diskon = 0;
      harga_sebenarnya = 0;
      menu = 0;
      list.clear();
      listPesan.clear();
    });
    checkTotalHarga();
  }

  Future checkVourcher(String params) async {
    var data = await apiService.CheckVourcher(params);
    if (data.datas?.kode != null && data.datas?.nominal != null) {
      setState(() {
        vourcher_text = '${data.datas!.kode!} \n Rp.${data.datas!.nominal!}';
        diskon = data.datas!.nominal!;
        checkTotalHarga();
      });
    } else {
      setState(() {
        diskon = 0;
        vourcher_text = 'Input vourcher';
        checkTotalHarga();
      });
    }
  }

  void checkTotalHarga() {
    setState(() {
      harga_sebenarnya = harga - diskon;
      if (harga_sebenarnya < 0) {
        harga_sebenarnya = 0;
      }
    });
  }

  void pesan() {
    var indexl = 0;
    List<Map<String, dynamic>> daftarPesanan = [];
    for (var element in list) { 
        for (var element in element) {
          daftarPesanan.add(
            {
              "id": element['id'], 
              "harga": element['harga'], 
              "catatan": listPesan[indexl]
            }
          );
        }
        indexl++;
      }
    var m = {
      "nominal_diskon" : diskon.toString(),
      "nominal_pesanan" : harga.toString(),
      "items" : daftarPesanan
    };
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailOrder(data: m, diskon: diskon, harga: harga, total: harga_sebenarnya, totalPesanan: daftarPesanan.length)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: FutureBuilder(
                future: apiService.getMenus(),
                builder: (con, snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    ResponseApi data = snap.data!;
                    for (var element in data.datas!) {
                      list.add([]);
                      listPesan.add('-');
                    }
                    return ListView.builder(
                      itemCount: data.datas!.length,
                      itemBuilder: (context, index) {
                        return Container(
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
                                      child: ImageNetwork(image: data.datas![index].gambar!, height: 50, width: 50),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data.datas![index].nama!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                                          Text('Rp.${data.datas![index].harga!.toString()}'),
                                          TextField(
                                            onSubmitted: (value) {
                                              setState(() {
                                                listPesan[index] = value;
                                              });
                                            },
                                            controller: TextEditingController.fromValue(
                                              TextEditingValue(text: listPesan[index])
                                            ),
                                            decoration:  const InputDecoration(
                                              labelText: 'Catatan',
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                harga -= data.datas![index].harga!;
                                                checkTotalHarga();
                                                list[index].removeLast();
                                                menu--;
                                              });
                                            }, 
                                            icon: const Icon(Icons.remove)
                                          ),
                                          Text(list[index].length.toString()),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                harga += data.datas![index].harga!;
                                                checkTotalHarga();
                                                list[index].add(
                                                  {
                                                    'id' : data.datas![index].id,
                                                    'harga' : data.datas![index].harga
                                                  }
                                                );
                                                menu++;
                                              });
                                            }, 
                                            icon: const Icon(Icons.add)
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const LinearProgressIndicator();
                  }
                }
              )
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: [ 
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4,child: Text('Total Pesanan ($menu Menu):', style: const TextStyle(fontSize: 18),),),
                          Expanded(child: Text('Rp.$harga', textAlign: TextAlign.right,))
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
                                Icon(Icons.confirmation_num, size: 30,),
                                SizedBox(width: 10,),
                                Text('Vourcher'),
                              ],
                            )
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context, 
                                  builder: (context) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 30),
                                      height: 300, width: MediaQuery.sizeOf(context).width,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context).width,
                                            height: 40,
                                            child: const Row(
                                              children: [
                                                SizedBox(width: 10,),
                                                Icon(Icons.confirmation_num, size: 30,),
                                                SizedBox(width: 10,),
                                                Text('Punya kode vourcher?', style: TextStyle(fontSize: 25),),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 10),
                                            width: MediaQuery.sizeOf(context).width,
                                            child: const Text('Masukkan kode vourcher', style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 10),
                                            width: MediaQuery.sizeOf(context).width,
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller: vourcher,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(context).width,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (vourcher.text != ""){
                                                          checkVourcher(vourcher.text);
                                                        } else {
                                                          setState(() {
                                                            diskon = 0;
                                                            vourcher_text = 'Input vourcher';
                                                            checkTotalHarga();
                                                          });
                                                        }
                                                        vourcher.clear();
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: const Text('Validasi Voucher')
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                          )
                                        ],
                                      ), 
                                    );
                                  },
                                );
                              },
                              child: Text(vourcher_text, textAlign: TextAlign.right,),
                            )
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
                                const Icon(Icons.shopping_bag_outlined, size: 30,),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total Pembayaran'),
                                    Text('Rp.$harga_sebenarnya')
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
                                  if (menu != 0) {
                                    pesan();
                                  }
                                },
                                child: const Text('Pesan Sekarang', style: TextStyle(color: Colors.white, fontSize: 12),),
                              )
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
