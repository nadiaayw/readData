import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<nama_dosen>> fetchnama_dosens(http.Client client) async {
  final response =
      await client.get('https://nadiaayw.000webhostapp.com/readDatanidn.php');

  // Use the compute function to run parsenama_dosens in a separate isolate.
  return compute(parsenama_dosens, response.body);
}

// A function that converts a response body into a List<nama_dosen>.
List<nama_dosen> parsenama_dosens(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<nama_dosen>((json) => nama_dosen.fromJson(json)).toList();
}

class nama_dosen {
  final String nidn;
  final String namadosen;
  final String jenjang_akademik;
  final String pendidikan_terakhir;
  final String home_base;

  nama_dosen({this.nidn, this.namadosen, this.jenjang_akademik, this.pendidikan_terakhir, this.home_base});

  factory nama_dosen.fromJson(Map<String, dynamic> json) {
    return nama_dosen(
      nidn: json['nidn'] as String,
      namadosen: json['namadosen'] as String,
      jenjang_akademik: json['jenjang_akademik'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
      home_base: json['home_base'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Nama Dosen';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<nama_dosen>>(
        future: fetchnama_dosens(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? nama_dosensList(nama_dosenData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class nama_dosensList extends StatelessWidget {
  final List<nama_dosen> nama_dosenData;

  nama_dosensList({Key key, this.nama_dosenData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nidn, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].namadosen, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: nama_dosenData.length,
      itemBuilder: (context, index) {
        return viewData(nama_dosenData,index);
      },
    );
  }
}