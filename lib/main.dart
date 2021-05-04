
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; //para converter p json

const request = "https://api.hgbrasil.com/finance?format=json&key=d873be86";

void main () async { //assincrona

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.black,
    primaryColor: Colors.white,)
  ));
}

Future<Map> getData() async { 
  http.Response response = await http.get(request); //await retorna um dado futuro
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

      final realController = TextEditingController();
      final dolarController = TextEditingController();
      final euroController = TextEditingController();


      double dolar;
      double euro;

  num get real => null;


    void _realChanged(String text){
      if(text.isEmpty){
        _clearAll();
        return;
      }
        double real = double.parse(text); 
        dolarController.text= (real/dolar).toStringAsFixed(2);
        euroController.text= (real/euro).toStringAsFixed(2);
    }

    void _dolarChanged(String text){
      if(text.isEmpty){
        _clearAll();
        return;
      }
        double dolar = double.parse(text); // transforma meu texto em double dolar
        realController.text = (dolar * this.dolar).toStringAsFixed(2);
        euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }

    void _euroChanged(String text){
      if(text.isEmpty){
        _clearAll();
        return;
      }
        double euro = double.parse(text);
        realController.text = (euro * this.euro).toStringAsFixed(2);
        dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }

    void _clearAll (){
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("\$Conversor\$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body:FutureBuilder<Map>(
        future: getData(),
        // ignore: non_constant_identifier_names
        // ignore: missing_return
        builder: (context, AsyncSnapshot) {
            switch (AsyncSnapshot.connectionState){
              case ConnectionState.none: 
              case ConnectionState.waiting:

                return Center(
                  child: Text("Carregando dados...",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25),
                      textAlign: TextAlign.center,
                )
                );

            default: 
                if(AsyncSnapshot.hasError){
                  return Center(
                  child: Text("Erro ao carregar dados :( ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25),
                      textAlign: TextAlign.center,)
                );

                } else {
                  dolar = AsyncSnapshot.data["results"] ["currencies"] ["USD"] ["buy"];
                  euro = AsyncSnapshot.data["results"] ["currencies"] ["EUR"] ["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                          Icon(Icons.monetization_on, size: 150, color: Colors.amber),

                          Divider(),

                          buildTextField("Reais", "R\$", realController, _realChanged),

                          Divider(),


                          buildTextField("Dólares", "US\$", dolarController, _dolarChanged),


                          Divider(),

                          buildTextField("Euros", "€", euroController, _euroChanged),
                      ],
                      ),
                  );
                }
            }
        }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
    return TextField(
              controller: c,
            decoration: InputDecoration(
              labelText: label,
                labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    prefixText: prefix
                    ),
                    style: TextStyle(color: Colors.black,
                    fontSize: 18,),
                    onChanged: f,
                    keyboardType: TextInputType.number,
                         );


}