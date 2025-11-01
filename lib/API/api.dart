import 'dart:convert';
import 'package:books_app/model/books.dart';
import 'package:http/http.dart' as http;


class Api {
  String url = "http://10.0.2.2:5000";
  Future<List<Books>> get_books() async {
    final response = await http.get(Uri.parse("$url/books"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Books.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load books");
    }
  }


  Future<Books> post_books({int? id,required String title}) async {
    // (1) Build the payload we want to send
    final payload = <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
    };


    // (2) Prepare the POST
    final uri = Uri.parse('$url/books');


    final res = await http.post(
      uri,
      // (3) Tell the server we're sending JSON
      headers: {
        'Content-Type': 'application/json',
        // 'Accept': 'application/json',  // optional; most APIs default to JSON
      },
      // (4) Convert the Dart Map to a JSON string
      body: jsonEncode(payload),
    );


    // (5) Handle the response
    if (res.statusCode == 201 || res.statusCode == 200) {
      // API created/returned the new book; parse it
      final Map<String, dynamic> data = jsonDecode(res.body);
      return Books.fromJson(data);
    }


    // (6) Surface an error with response details for debugging
    throw Exception(
      'Failed to create book: ${res.statusCode} ${res.body}',
    );
  }
  }





