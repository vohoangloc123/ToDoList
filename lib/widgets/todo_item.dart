import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants/colors/colors.dart';
import 'package:to_do_list/models/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  const TodoItem({Key?key, required this.todo, required this.onToDoChanged, required this.onDeleteItem}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom:20),
        child: ListTile(
          //Thuộc tính onTap xác định hành động khi người dùng nhấn vào ListTile.
          // Ở đây, hàm onToDoChanged(todo) được gọi, kích hoạt sự thay đổi trạng thái của mục todo.
          onTap: (){
            onToDoChanged(todo);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: Icon(todo.isDone? Icons.check_box: Icons.check_box_outline_blank, color: tdBlue),
          title: Text(
            todo.todoText!,
            style: TextStyle(
              fontSize:16,
              color: tdBlack,
              decoration: todo.isDone? TextDecoration.lineThrough: null,
            ),
          ),
          //trailing được đặt ở phía bên phải của ListTile, bao bọc trong một Container.
          // Hiển thị một IconButton với biểu tượng xóa (Icons.delete).
          // Nút có màu nền là tdRed và kích hoạt hàm onDeleteItem(todo.id) khi được nhấn, truyền id của mục todo.
          trailing: Container(
            padding: EdgeInsets.all(0),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: tdRed,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              color: Colors.white,
              iconSize: 18,
              icon: Icon(Icons.delete),
              onPressed: (){
                onDeleteItem(todo.id);
              },
            ),
          ),
        ));
  }
}
