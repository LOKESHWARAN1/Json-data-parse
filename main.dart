import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Details',
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List users = [];
  bool isLoading = false;

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url = 'https://reqres.in/api/users?page=2';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var item = json.decode(response.body)['data'];
      setState(() {
        users = item;
        isLoading = false;
      });
    } else {
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.blueGrey,
        Colors.indigoAccent,
      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Center(child: Text('Details Page')),
        ),
        body: (users.contains(null) || users.length < 0 || isLoading)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.blueAccent,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(users[index]['avatar']),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, left: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        users[index]['first_name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        users[index]['last_name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    users[index]['email'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}