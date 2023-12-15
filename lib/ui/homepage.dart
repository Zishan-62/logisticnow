import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logisticsnow_assignment/ui/auth/login_screen.dart';
import 'package:logisticsnow_assignment/widgets/Custom_text.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;

  TextEditingController searchcontroller = TextEditingController();
  List mylist = [];
  api(String location) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://lorriservice.azurefd.net//api/autocomplete?suggest=${location}&limit=20&searchFields=new_locations'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var data = await response.stream.bytesToString();
      var data2 = json.decode(data);
      setState(() {
        mylist = data2["value"];
      });
      print(mylist);
      print(mylist.length);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    var Mheight = MediaQuery.of(context).size.height;
    var Mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: searchcontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(color: Colors.white, fontSize: Mwidth * 0.04),
                onChanged: (value) {
                  print(searchcontroller.text.toString());
                  if (searchcontroller.text.toString().length > 2) {
                    api(searchcontroller.text.toString());
                  }
                },
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                icon: Icon(Icons.logout_outlined)),
            // IconButton(
            //     onPressed: () {
            //      api();

            //     },
            //     icon: Icon(Icons.search)),
          ],
        ),
        body: mylist.length > 0
            ? ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Label",
                            fontWeight: FontWeight.bold,
                            fontSize: Mwidth * 0.06,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomText(text: "Location:"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                        text: mylist[index]["location"]
                                            ["location"]),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(text: "District:"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                        text: mylist[index]["location"]
                                            ["district"]),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomText(text: "State:"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                        text: mylist[index]["location"]
                                            ["state"]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomText(
                            text: "Co-ordinate",
                            fontWeight: FontWeight.bold,
                            fontSize: Mwidth * 0.06,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomText(text: "Latitude:"),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                    text: mylist[index]["location"]["lat"]
                                        .toString()),
                                SizedBox(
                                  width: 50,
                                ),
                                CustomText(text: "Longitude:"),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                    text: mylist[index]["location"]["lon"]
                                        .toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : Center(
                child: CustomText(text: "No Value Found"),
              ));
  }
}
