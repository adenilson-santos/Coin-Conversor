import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const hgApi = 'https://api.hgbrasil.com/finance';

void main () async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.lightBlue,
      primaryColor: Colors.white
    )
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(hgApi);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController  = TextEditingController();
  final euroController  = TextEditingController();
  final dolarController = TextEditingController();
  double dolar, euro;

  void _realChanged (String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged (String text) {
    print('dolar');
  }

  void _euroChanged (String text) {
    print('euro');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(child: Text('\$ Coin Conversor \$', style: TextStyle(color: Colors.white),), ),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: Text('Loading data...', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center));
            default:
              if(snapshot.hasError) {
                return Center(child: Text('Error to load data...', style: TextStyle(fontSize: 25.0), textAlign: TextAlign.center));
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                dolar = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 120.0, color: Colors.lightBlue),
                        Divider(),
                        buildTextField('Reais', 'R\$ ', realController, _realChanged),
                        Divider(),
                        buildTextField('Dolars', 'US\$ ', dolarController, _dolarChanged),
                        Divider(),
                        buildTextField('Euros', '€ ', euroController, _euroChanged)
                      ],
                    ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField (String label, String prefix, TextEditingController controller, Function changedAction) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.lightBlue),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.lightBlue
    ),
    onChanged: changedAction,
    keyboardType: TextInputType.number,
  );
}

// theme: ThemeData(
//   inputDecorationTheme: InputDecorationTheme(
//     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
//   )
// )