class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning exercise', isDone: true),
      ToDo(id: '02', todoText: 'Buy groceries', isDone: false),
      ToDo(id: '03', todoText: 'Read a book', isDone: false),
      ToDo(id: '04', todoText: 'Write some code', isDone: true),
      ToDo(id: '05', todoText: 'Walk the dog', isDone: false),
    ];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }
  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      isDone: json['isDone'] ?? false, // Khởi tạo isDone mặc định là false nếu không có giá trị
    );
  }
}
