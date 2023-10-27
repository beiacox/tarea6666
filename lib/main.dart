import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Determiner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = '';
  String age = '';
  String imageUrl = '';

  void fetchData() async {
    var response =
        await http.get(Uri.parse('https://api.agify.io/?name=$name'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        age = data['age'];
        if (int.parse(age) < 18) {
          imageUrl = 'URL_DE_LA_IMAGEN_DE_PERSONA_JOVEN';
        } else if (int.parse(age) >= 18 && int.parse(age) < 60) {
          imageUrl = 'URL_DE_LA_IMAGEN_DE_PERSONA_ADULTA';
        } else {
          imageUrl = 'URL_DE_LA_IMAGEN_DE_PERSONA_ANCIANA';
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age Determiner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter a name',
              ),
            ),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Determine Age'),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            imageUrl != ''
                ? Image.network(
                    imageUrl,
                    width: 150,
                    height: 150,
                  )
                : Container(),
            SizedBox(height: 20),
            age != 0
                ? int.parse(age) < 18
                    ? Text('You are young')
                    : int.parse(age) < 60
                        ? Text('You are an adult')
                        : Text('You are elderly')
                : Container(),
          ],
        ),
      ),
    );
  }
}
