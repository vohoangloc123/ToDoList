import 'package:flutter/material.dart';
import 'package:to_do_list/constants/colors/colors.dart';
import 'package:to_do_list/widgets/todo_item.dart';


import '../../models/todo.dart';
class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList=ToDo.todoList();

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
                  Expanded(child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top:50,
                            bottom: 20
                        ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize:30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for(ToDo todo in todosList)
                      TodoItem(todo: todo, onToDoChanged: _handleToDoChange,
                      onDeleteItem: (){},),
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
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20
                  ),
                padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                    color: tdGrey,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.0,
                  ),],
                  borderRadius: BorderRadius.circular(10)
                ),
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                        hintText: 'Add a new to do item',
                        border: InputBorder.none,
                    ),
                  ),
                ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    child: Text('+',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Đặt góc cong nhẹ
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
  void _handleToDoChange(ToDo todo)
  {
    setState(() {
      todo.isDone=!todo.isDone;
    });
  }
  Widget searchBox()
  {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
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
