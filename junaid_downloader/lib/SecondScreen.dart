

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class ViewPdf extends StatefulWidget {
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  PDFDocument doc;
  @override
  Widget build(BuildContext context) {
    //get data from first class
    String data=ModalRoute.of(context).settings.arguments;
String title=data;
    var filename1 = title.split("/").last;
    // String s = data;
    // int idx = s.indexOf("/");
    // List parts = [s.substring(s.length,idx).trim()];


    ViewNow() async {
      print("data "+data);
      var myFile = File("$data");

      doc = await PDFDocument.fromFile(myFile);
      setState(() {

      });
    }

    Widget Loading(){
      ViewNow();
      if(doc==null){
        //return
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(filename1),
      ),
      body: doc==null?Loading():PDFViewer(document: doc),
    );
  }
}