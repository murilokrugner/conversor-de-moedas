import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=97526a28";
void main() async {
  runApp(MaterialApp(title: 'Conversor', home: Home(), theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
  ), ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }
  double dolar;
  double euro;
  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();
  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.dolar / euro).toStringAsFixed(2);
  }
  void _refresh(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '\$ Conversor \$',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refresh,
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando Dados...',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    'Erro ao carregar dados :(',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,),
                );
              }
              else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 120.0, color: Colors.amber),
                      buildTextField('Reais','R\$', realController, _realChanged),
                      Divider(),
                      buildTextField('Dólares','US\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField('Euros', '€', euroController, _euroChanged),
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
Widget buildTextField(String label, String prefix,
    TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25.0,
    ) ,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
