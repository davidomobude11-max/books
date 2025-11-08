from flask import Flask, request, jsonify
from info import db, BookDB  # Import from info.py

app = Flask(__name__)

# PostgreSQL connection
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:David2011.@localhost/Books'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize database
db.init_app(app)

Books = [
    {"id": 1, "title": "A guide to coding"},
    {"id": 2, "title": "Coding for beginners"}
]

@app.route("/API/info")
def home():
    return {"course": "topic"}


@app.route('/books', methods=['GET'])
def get_books_from_db():
    books = BookDB.query.all()
    return jsonify([{'id': b.id, 'title': b.title, 'author': b.author} for b in books])


@app.route("/books/<int:book_id>", methods=["GET"])
def get_book_by_id(book_id):
    for i in Books:
        if i["id"] == book_id:
            return jsonify(i)
    return jsonify({"error": "book not found"}), 404


# --- POST: Add new book (static list for now) ---
@app.route('/books', methods=['POST'])
def add_book():
    data = request.get_json()
    title = data.get('title')
    if not title:
        return jsonify({'error': 'Title required'}), 400
    new_book = {
        'id': len(Books) + 1,
        'title': title
    }
    Books.append(new_book)
    return jsonify(new_book), 201


# --- PUT: Update existing book ---
@app.route("/books/<int:book_id>", methods=["PUT"])
def update_book(book_id):
    updated_book = request.get_json()
    for book in Books:
        if book["id"] == book_id:
            book.update(updated_book)
            return jsonify(book)
    return jsonify({"error": "Book not found"}), 404


# --- DELETE: Remove book ---
@app.route("/books/<int:book_id>", methods=["DELETE"])
def delete_book(book_id):
    for i in Books:
        if i["id"] == book_id:
            Books.remove(i)
            return jsonify({"message": "book deleted successfully"})
    return jsonify({"error": "book not found"}), 404


# --- Initialize DB tables only once ---
with app.app_context():
    db.create_all()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
