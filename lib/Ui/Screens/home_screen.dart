import 'package:books_app/API/api.dart';
import 'package:books_app/model/books.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Books>> _futureBooks;
  @override
  void initState() {
    super.initState();
    _futureBooks = Api().get_books();
  }
 void _refreshBooks() {
    setState(() {
      _futureBooks = Api().get_books();
    });
  }


  // Function to show dialog and post new book
  Future<void> _showAddBookDialog() async {
    final titleController = TextEditingController();


    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add New Book"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Enter book title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) return;


                try {
                  await Api().post_books(title: title);
                  if (context.mounted) {
                    Navigator.pop(ctx); // close dialog
                    _refreshBooks(); // reload list
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Book '$title' added!")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : Text('Book app')),
      body:
      FutureBuilder(future: _futureBooks, builder:(context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No books found"));
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                );
              },
            );
          }
        },
       
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        child: const Icon(Icons.add),
      ),
     );
  }
}
