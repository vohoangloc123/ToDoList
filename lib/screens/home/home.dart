import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/constants/colors/colors.dart';
import 'package:to_do_list/widgets/todo_item.dart';
import '../../models/todo.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = []; // lưu trữ tất cả các mục ToDo
  List<ToDo> _foundToDo = []; // được sử dụng để lưu trữ các mục ToDo được tìm thấy sau khi áp dụng bộ lọc tìm kiếm vào danh sách
  final _todoController = TextEditingController();
  //Được sử dụng để lấy và điều khiển nội dung nhập liệu từ một TextField trong giao diện người dùng.
  // Xóa nội dung: Cung cấp phương thức .clear() để xóa nội dung hiện tại của TextField, thường được sử dụng sau khi người dùng đã thêm một mục ToDo mới.
  // Trích xuất nội dung: Sử dụng .text để lấy nội dung hiện tại của TextField, như trong phương thức _addToDoItem để lấy giá trị ToDo mới và thêm vào todosList.

  @override
  void initState() {
    super.initState();
    _loadTodoList(); //load dữ liệu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed) //reversed là một phương thức của lớp Iterable trong Dart, nó trả về một bản sao của danh sách ban đầu với thứ tự các phần tử đảo ngược lại.
                        TodoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: tdGrey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController, //Đối tượng _todoController được sử dụng làm điều khiển cho TextField, giúp quản lý và lấy giá trị nhập liệu từ người dùng.
                      decoration: InputDecoration.collapsed(
                        hintText: 'Add a new to do item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    onPressed: () {
                      _addToDoItem(_todoController.text); // thêm một mục ToDo mới vào danh sách dựa trên nội dung mà người dùng đã nhập vào từ TextField được quản lý bởi _todoController.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _saveTodoList(todosList); // Lưu lại khi thay đổi trạng thái
    });
    // thay đổi trạng thái của một mục ToDo và sau đó lưu danh sách các mục ToDo này vào SharedPreferences.
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _foundToDo.removeWhere((item) => item.id == id); // Cập nhật danh sách hiển thị
      _saveTodoList(todosList); // Lưu lại danh sách sau khi xóa
    });
  }


  void _addToDoItem(String toDo) {
    if (toDo.isNotEmpty) {
      setState(() {
        todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo,
        ));
        _todoController.clear();
        _saveTodoList(todosList); // Lưu lại khi thêm mới

        // Cập nhật danh sách tìm thấy và giao diện ngay lập tức
        _foundToDo = List.from(todosList);
      });
    }
  }
  void _saveTodoList(List<ToDo> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todos = items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('todoItems', todos);
    print("Saved data: $todos");
  }

  void _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTodos = prefs.getStringList('todoItems');

    if (storedTodos != null) {
      setState(() {
        todosList.clear(); // Xóa hết danh sách cũ
        _foundToDo.clear();
        todosList.addAll(storedTodos.map((json) => ToDo.fromJson(jsonDecode(json))));
        _foundToDo.addAll(todosList); // Cập nhật danh sách hiển thị
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: tdBlack, size: 30),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
