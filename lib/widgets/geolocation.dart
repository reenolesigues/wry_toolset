import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:get_ip/get_ip.dart';
import 'package:toast/toast.dart';

class GeoWidget extends StatefulWidget {
  @override
  _GeoWidgetState createState() => _GeoWidgetState();
}

class _GeoWidgetState extends State<GeoWidget> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  final ipController = TextEditingController();
  Position _currentPosition;
  String _currentAddress = '';
  String _publicIP = '';
  bool scanPubIP = false;

  Future<Response> scanIP() {
    _loadPubIPDetails(ipController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight/3,
                width: constraints.maxWidth,
                color: Colors.blueGrey,
                child: Center(
                  child: Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    children: [
                      _detailRowTile('Lat|Long', _currentPosition == null ? 'N/A' : _currentPosition.latitude.toStringAsFixed(4) + ' | ' + _currentPosition.longitude.toStringAsFixed(4)),
                      _detailRowTile('Address', _currentAddress == '' ? 'N/A' : _currentAddress),
                      _detailRowTile('Public IP', _currentAddress == '' ? '127.0.0.1' : _publicIP),
                      RaisedButton(
                        child: Text('Find my Location'),
                        onPressed: () {
                          _getCurrentLocation();
                        },
                      ),
                    ],
                  ),
                )
              ),
              Container(
                height: constraints.maxHeight *2/3,
                color: Colors.blue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: TextField(
                            controller: ipController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter public IP you want to check',
                            ),
                          ),
                          width: constraints.maxWidth * 3/4,
                          padding: EdgeInsets.all(5),
                        ),
                        Container(
                          width: constraints.maxWidth / 4,
                          child: RaisedButton(
                            child: Text('Scan', style: TextStyle(fontWeight: FontWeight.bold),),
                            onPressed: () {
                              setState(() {
                                scanPubIP = true;
                              });
                            },
                            padding: EdgeInsets.all(5),
                          ),
                        ),
                        FutureBuilder(
                          future: scanIP(),
                          builder: (context, snapshot) {
                            String content;
                            List<Widget> children;
                            if(snapshot.hasData) {
                              children = <Widget>[
                                Text(snapshot.data.toString())
                              ];
                            }
                            else if(snapshot.hasError) {
                              children = <Widget>[
                                Text(snapshot.error.toString())
                              ];
                            }
                            else {
                              children = <Widget>[
                                Text(snapshot.connectionState.toString())
                              ];
                            }
                            return children[0];
                          },
                        )
                      ],
                    ),
//                    scanPubIP ? _loadPubIPDetails(ipController.text) : Text(''),
                  ],
                )
              ),
            ],
          );
        },
      ),
    );
  }

  _getCurrentLocation() async {
    await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest).then((position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLong();
    }).catchError((e) => {print(e)});
  }

  _getAddressFromLatLong() async {
    try{
      List<Placemark> places = await geolocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = places[0];
      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}, ${place.isoCountryCode}";
      });
    } catch(e) {
        print(e);
    }
    _getPublicIP();
  }

  _getPublicIP() async {
    String ipAddress = await GetIp.ipAddress;
    setState(() {
      _publicIP = ipAddress;
    });
  }
}

Widget _detailRowTile(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        child: Text(label + ' : ', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      Container(
        child: Text(value),
      )
    ],
  );
}

Future<Widget> _loadPubIPDetails(String ip) async{
  var url = 'http://ip-api.com/json/${ip}?fields=66846719';
  var response = await post(url, body: null);
  print(response.statusCode);
  return Text('YES');
}