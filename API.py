from flask import Flask, request, jsonify

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

from Database import BookDB

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:yourpassword@localhost/Books'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

@app.route("/API/info")
def home():
   return {"course": "topic"}
Books = [{"id": 1, "title" : "A guide to coding"},{"id":2, "title": "Coding for beginners"}]


# Get API
"""@app.route("/books",methods = ["GET"])
def books():
   return jsonify(Books)"""

@app.route('/books', methods=['GET'])
def get_books():
    books = BookDB.query.all()
    return jsonify([{'id': b.id, 'title': b.title, 'author': b.author} for b in books])

db.create_all()


@app.route("/books/<int:book_id>", methods = ["GET"])
def get_books(book_id):
   for i in Books:
       if i["id"] == book_id:
           return jsonify(i)
   return jsonify({"error": "book not found"}),404


@app.route('/books', methods=['POST'])
def add_book():
    data = request.get_json()
    title = data.get('title')
    if not title:
        return jsonify({'error': 'Title required'}), 400
    new_book = {
    'id': len(Books) + 1, # auto-generate
    'title': title
    }

    Books.append(new_book)
    return jsonify(new_book), 201




#Hello
@app.route("/books/<int:book_id>", methods=["PUT"])
def update_book(book_id):
   updated_book = request.get_json()
   for book in Books:
       if book["id"] == book_id:
           book.update(updated_book)
           return jsonify(book)
   return jsonify({"error": "Book not found"}), 404


@app.route("/books/<int:book_id>", methods=["DELETE"])
def delete_book(book_id):
   for i in Books:
       if i["id"] == book_id:
           Books.remove(i)
           return jsonify({"message": "book deleted successfully"})
   return jsonify({"error": "book not found"}), 404




if __name__ == "__main__":
   # debug=True = auto-reload on code changes, show errors
   app.run(host="0.0.0.0", port=5000, debug=True)
