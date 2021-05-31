import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'SecondScreen.dart';
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


class FirstScreen extends StatefulWidget {


  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  //final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
//
//  final imgUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  String imgUrl = "";

  bool downloading = false;
  var progressString = "";


  // @override
  void initState() {
    getPermission();
  }





  void getPermission() async {
    print("getPermission");
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }



  Future<void> downloadFile(String url) async {
    Dio dio = Dio();
    var path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    String fullPath=path.toString()+"/camrinFilims_"+getRandomString(5)+".pdf";
    try {
      var dir = await getApplicationDocumentsDirectory();


      await dio.download(url, "$fullPath",
     // await dio.download(url, path,
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total path:$fullPath , url:$url");

            setState(() {
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
      String passData=fullPath;
      print(fullPath);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context)=>ViewPdf(),
              settings: RouteSettings(
                arguments: passData
              )
          )
      );
    });
    print("Download completed");
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camrin Filims"),
      ),
      body: Center(
        child: downloading
            ? Container(
          height: 120.0,
          width: 200.0,
          child: Card(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Downloading File: $progressString",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        )
            :Padding(
          padding: EdgeInsets.all(25),
              child: Center(child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
    TextField(
    controller: myController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(25.0))),
        labelText: 'Url',
      ),
    ),
    ElevatedButton(
    onPressed: () {
      imgUrl=myController.text;
      if(imgUrl!="") {
        downloadFile(imgUrl);
      }


    }
    ,
    child: Text('Download'),
    )
    ],),
              ),),
            )

    ));
  }
}
