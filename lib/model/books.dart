class Books {
   final int id;
   final String title;
   Books({required this.id, required this.title});
   
   factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      id: json['id'],
      title: json['title'],
    );
  }


}


