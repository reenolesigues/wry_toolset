import 'package:flutter/material.dart';
import 'package:wry_toolset/widgets/geolocation.dart';
import 'package:wry_toolset/widgets/homepage.dart';
import 'package:wry_toolset/widgets/qrscanner.dart';

typedef PageToolCallback = Function(int pagetool);

class NavDrawer extends StatelessWidget {
  NavDrawer(this.openPage, this.callback);
  final int openPage;
  final PageToolCallback callback;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.black12],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
              ),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/w_icon.png')
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Home'),
            enabled: (openPage == 0) ? false : true,
            onTap: () {
              Navigator.pop(context);
              callback(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Geolocation'),
            enabled: (openPage == 1) ? false : true,
            onTap: () {
              Navigator.pop(context);
              callback(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.scanner),
            title: Text('QR Scanner'),
            enabled: (openPage == 2) ? false : true,
            onTap: () {
              Navigator.pop(context);
              callback(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Close'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class WryPage extends StatefulWidget {
  @override
  _WryPageState createState() => _WryPageState();
}

class _WryPageState extends State<WryPage> {
  int page = 0;
  void pageToolCallback (int pagetool) => setState(() {
      page = pagetool;
    });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavDrawer(page, pageToolCallback),
      appBar: AppBar(
        title: Text('WRY TOOLS', style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20),),
      ),
      body: _loadPageWidget(page),
    );
  }

  Widget _loadPageWidget(int page) {
    switch(page) {
      case 0:
        return HomeWidget();
      case 1:
        return GeoWidget();
      case 2:
        return QRWidget();
      default:
        return HomeWidget();
    }
  }
}


class WryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wry Tool App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey
      ),
//      home: MainPageStructure(toolname: 'home'),
      home: WryPage(),
    );
  }
}

void main() => runApp(WryApp());