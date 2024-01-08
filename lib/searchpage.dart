import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String enteredText;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/photo3.jpg')),
      ),
      child: Scaffold(

        appBar: AppBar(leading: const BackButton(
          color: Colors.deepPurple,
        ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(''),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration:  InputDecoration(
                    labelText: 'Enter Text',
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Label rengi
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.deepPurple, // Odaklandığında kenarlık rengi
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.deepPurple, // Etkin olmadığında kenarlık rengi
                        width: 1.0,
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    // İsteğe bağlı olarak içeriği düzenleme
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  onPressed: () async{
                    enteredText = _textEditingController.text;
                    var response = await http.get(
                        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$enteredText'));
                    if(response.statusCode == 200){
                      Navigator.pop(context,enteredText);
                    }else{
                      AwesomeDialog(
                        context: context,
                        btnOkColor: Colors.red,
                        animType: AnimType.scale,
                        dialogType: DialogType.info,
                        body: const Center(child: Text(
                          'Aradığınız kitap bulunamadı',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),),
                        title: 'This is Ignored',
                        desc:   'This is also Ignored',
                        btnOkOnPress: () {},
                      ).show();
                    }


                    print('Entered Text: $enteredText');
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


