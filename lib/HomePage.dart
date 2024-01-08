import 'dart:convert';

import 'package:activity_ring/activity_ring.dart';
import 'package:bookwarm/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String bookname = 'lotr';
  String? title;
  String? author;
  String? desc;
  String? img;

  Future<void> getApi() async {
    ///https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2020-01-01&endtime=2020-01-02
    ///https://www.googleapis.com/books/v1/volumes?q=kürk%20mantolu%20madonna

    try {
      // Make the HTTP request
      var response = await http.get(
          Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$bookname'));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        var dataParsed = jsonDecode(response.body);

        // Extract information and update the UI using setState
        setState(() {
          title = dataParsed['items'][0]['volumeInfo']['title'];
          author = dataParsed['items'][0]['volumeInfo']['authors'][0];

          // Check if 'description' exists in the response before accessing it
          desc = dataParsed['items'][0]['volumeInfo']['description'] ??
              'No description available';

          // Check if 'imageLinks' and 'smallThumbnail' exist in the response before accessing them
          img = dataParsed['items'][0]['volumeInfo']['imageLinks'] != null
              ? dataParsed['items'][0]['volumeInfo']['imageLinks']
                  ['smallThumbnail']
              : 'https://i0.wp.com/tacm.com/wp-content/uploads/2018/01/no-image-available.jpeg?ssl=1';

          // Print the extracted information
          print(title);
          print(author);
          print(desc);
          print(img);
        });
      } else {
        // If the request was not successful, print the status code
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions that may occur during the process
      print('Error: $error');
    }
  }

  @override
  void initState() {
    getApi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (title == null)
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey,
              child: Ring(
                percent: 100,
                color: RingColorScheme(
                    ringGradient: [Colors.red, Colors.blue, Colors.green]),
                radius: 80,
                width: 10,
                child: Center(child: Text('')),
              ),
            )
          : Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/photo1.jpg'),fit: BoxFit.fill),
        ),
            child: Scaffold(
        backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent, elevation: 0,
              ),
              body: Center(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.transparent,
                        child: Image.network(
                          img!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(title!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(author!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(desc!),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          bookname = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
                          );
                          getApi();
                        },
                        child: Text("Go to Search Page"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
