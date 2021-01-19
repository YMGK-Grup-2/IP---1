import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(
    title: "Ymgk Proje",
    home: LandingScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;
  String sifreliFile;

  _openGallary(BuildContext context) async {
    var picture =
        imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture =
        imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDiolog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ekleme yönteminizi seçiniz."),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeri"),
                    onTap: () {
                      _openGallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Kamera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text(
        "Henüz resim Seçilmedi!",
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      );
    } else {
      return Container(
          height: 200, child: Image.file(imageFile, width: 400, height: 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YMGK2"),
        centerTitle: mounted,
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              RaisedButton(
                color: Colors.orange[700],
                onPressed: () {
                  _showChoiceDiolog(context);
                },
                child: Text(
                  "Resim Ekle",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
              ),
              _sifreliImage(),
              RaisedButton(
                color: Colors.orange[700],
                onPressed: () {
                  _sifrele();
                },
                child: Text(
                  "Şifrele",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  var yeniimage;

  _sifrele() async {
    print(imageFile.path);
    var bytes = (await rootBundle.load(imageFile.path)).buffer.asUint8List();
    
    var mpFile =
        http.MultipartFile.fromBytes('photo', bytes, filename: 'tolga.jpg');
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://webmenudemo.online/api/File/Upload'));
    request.files.add(mpFile);

    request.send().then((response) {
      if (response.statusCode == 200) {
        response.stream.bytesToString().then((value) {
          setState(() {
            yeniimage = "erqweqwewq";
          });
        });
      }
    });
  }

  Widget _sifreliImage() {
    if (yeniimage != null) {
      return Container(
        height: 200,
        child: Image.network(yeniimage),
      );
    } else {
      return Text("Bekleniyor..");
    }
  }
}
