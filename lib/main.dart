import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> products = [];
  String? selectedTitle;
  String? selectedSubtitle;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productList = data['products'];

        setState(() {
          products = productList;
        });
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<String> getSubtitles(String title) {
    final product = products.firstWhere((element) => element['title'] == title);
    final List<dynamic> subtitles = product['subtitles'];

    return subtitles
        .map<String>((dynamic subtitle) => subtitle.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: selectedTitle,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTitle = newValue;
                  selectedSubtitle = null;
                });
              },
              items: products
                  .map<DropdownMenuItem<String>>(
                    (product) => DropdownMenuItem<String>(
                      value: product['title'],
                      child: Text(product['title']),
                    ),
                  )
                  .toList(),
            ),
            // DropdownButton(
            //   value: selectedTitle,
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedTitle = newValue;
            //       selectedSubtitle = null;
            //     });
            //   },
            //   items: products
            //       .map<DropdownMenuItem<String>>(
            //         (product) => DropdownMenuItem<String>(
            //           value: product['brand'],
            //           child: Text(product['brand']),
            //         ),
            //       )
            //       .toList(),
            // ),
            SizedBox(height: 20),
            // DropdownButton(
            //   value: selectedSubtitle,
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedSubtitle = newValue;
            //     });
            //   },
            //   items: selectedTitle != null
            //       ? getSubtitles(selectedTitle!)
            //           .map<DropdownMenuItem<String>>(
            //             (subtitle) => DropdownMenuItem<String>(
            //               value: subtitle,
            //               child: Text(subtitle),
            //             ),
            //           )
            //           .toList()
            //       : [],
            // ),
          ],
        ),
      ),
    );
  }
}
