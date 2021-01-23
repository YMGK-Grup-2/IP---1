import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
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
  bool _secildimi = false;

  _openGallary(BuildContext context) async {
    var picture =
        imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      String boyut = imageFile.lengthSync().toString();
      int son = boyut.length - 3;
      int _boyut =
          int.parse(imageFile.lengthSync().toString().substring(0, son));
      if (_boyut > 1000) {
        imageFile = null;
        _secildimi = false;
        yeniimage = null;
        Fluttertoast.showToast(
            timeInSecForIosWeb: 2,
            msg: "1 MB Altında Dosya Seçiniz!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture =
        imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    this.setState(() {
      imageFile = picture;
      String boyut = imageFile.lengthSync().toString();
      int son = boyut.length - 3;
      int _boyut =
          int.parse(imageFile.lengthSync().toString().substring(0, son));
      print(_boyut);

      if (_boyut > 1000) {
        imageFile = null;
        _secildimi = false;
        yeniimage = null;
        Fluttertoast.showToast(
            timeInSecForIosWeb: 2,
            msg: "1 MB Altında Dosya Seçiniz!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
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
        style: TextStyle(
            fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      );
    } else {
      return Container(
          height: 200, child: Image.file(imageFile, width: 400, height: 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: AppBar(
        title: Text("YMGK GRUP 2"),
        centerTitle: mounted,
        backgroundColor: Colors.orange[700],
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: size.height * 0.30, child: _decideImageView()),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.red)),
                color: Colors.orange[700],
                onPressed: () {
                  setState(() {
                    _secildimi = false;
                    imageFile = null;
                    yeniimage = null;
                  });

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
              Container(height: size.height * 0.30, child: _sifreliImage()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.orange[700],
                      onPressed: () {
                        _sifrele();
                      },
                      child: Text(
                        "Resmi Şifrele",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: size.width * 0.40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.red)),
                      color: Colors.orange[700],
                      onPressed: () {
                        if (yeniimage != null) {
                          decrypt();
                        } else {
                          Fluttertoast.showToast(
                              timeInSecForIosWeb: 2,
                              msg: "Resim Şifrelenmedi!!!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        }
                      },
                      child: Text(
                        "Şifreyi Çöz",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Timer timer;
  void decrypt() {
    yeniimage = null;
    _secildimi = true;
    Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: "Şifreleme kaldırılıyor. \nLütfen Bekleyiniz...!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
    int _start = 10;
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        if (_start < 1) {
          timer.cancel();
          Fluttertoast.showToast(
              timeInSecForIosWeb: 2,
              msg: "Şifreleme kaldırıldı.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white);
          setState(() {
            imageFile = null;
            yeniimage = null;
            _secildimi = false;
          });
        } else {
          _start = _start - 1;
        }
      }),
    );
  }

  String yeniimage;

  _sifrele() async {
    print(imageFile.path);

    setState(() {
      _secildimi = true;
    });
    imageFile.readAsBytes().then((response) {
      var tmpByte = response;

      var mpFile = http.MultipartFile.fromBytes('photo', tmpByte,
          filename: basename(imageFile.path));
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://webmenudemo.online/api/File/Upload'));
      request.files.add(mpFile);
 
      request.send().then((response) {
        if (response.statusCode == 200) {
          response.stream.bytesToString().then((value) {
            print("GELDİ");
            print(value);

            setState(() {
              var tmpVal = value.substring(1, value.length - 1);

              yeniimage = tmpVal.toString();
            });
          });
        }
      });
    });
  }

  Widget _sifreliImage() {
    if (yeniimage != null) {
      return Container(
        height: 200,
        child: Image.network('http://' + yeniimage),
      );
    } else if (_secildimi == true && yeniimage == null) {
      return Image.asset("assets/images/yukleme.gif");
    } else {
      return Text(
        "Resim Bekleniyor...",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }
  }
}
