import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qrscan/qrscan.dart' as qrscanner;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class QRWidget extends StatefulWidget {
  @override
  _QRWidgetState createState() => _QRWidgetState();
}

class _QRWidgetState extends State<QRWidget> {
  String cameraScanResult = '';
  String generateLink = '';
  final qrInputController = TextEditingController();

  Future scanQRCode() async {
    String scanResult = await qrscanner.scan();
    setState(() {
      cameraScanResult = scanResult;
    });
  }
  void _urlOpen(String cameraScanResult) async {
    if(await canLaunch(cameraScanResult)){
      await launch(cameraScanResult);
    } else {
      Toast.show("Unable to open URL : " + cameraScanResult, context);
    }
  }
  @override
  void dispose() {
    qrInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 2 / 3,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                child: Center(
                  child: Wrap(
                    spacing: 30,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        height: (constraints.maxHeight * 2 / 3) / 2,
                        width: (constraints.maxHeight * 2 / 3) / 2,
                        child: generateLink == '' ?
                          Container(
                            child: Center(child: Text('Generated QR Here'),),
                            color: Colors.blueGrey,
                          ) :
                          QrImage(data: generateLink,),
                      ),
                      Container(
                        width: constraints.maxWidth,
                        child: TextField(
                          controller: qrInputController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter link to generate QR Code',
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.black12),
                        ),
                        child: Text('Generate QR'),
                        onPressed: () {
                          setState(() {
                            generateLink = qrInputController.text;
                          });
                        },
                      )
                    ],
                  ),
                )
              ),
              Container(
                height: constraints.maxHeight/3,
                width: MediaQuery.of(context).size.width,
                color: Colors.white10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: RichText(
                        text: TextSpan(text: cameraScanResult == '' ? 'NO RESULT' : cameraScanResult, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15,)),
                      ),
                      onTap: () => _urlOpen(cameraScanResult),
                    ),
                    SizedBox(
                      height: constraints.maxHeight/25,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.black12),
                      ),
                      child: Text('Scan QR'),
                      onPressed: scanQRCode,
                    )
                  ],
                )
              )
            ],
          );
        },
      ),
    );
  }
}

