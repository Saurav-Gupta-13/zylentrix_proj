import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");

    try {
      final response = await http.get(url);
      await Future.delayed(Duration(seconds: 2)); // Simulate loading delay
      if (response.statusCode == 200) {
        setState(() {
          posts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error fetching data. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API Fetch Example")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              : Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostTile(title: posts[index]['title'], body: posts[index]['body']);
                    },
                  ),
                ),
    );
  }
}

class PostTile extends StatelessWidget {
  final String title;
  final String body;

  PostTile({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(body),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.article, color: Colors.white),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
