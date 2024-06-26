import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants/colors/colors.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
          onTap: (){},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:  EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: Icon(Icons.check_box, color: tdBlue),
          title: Text('Check Mail',
            style: TextStyle(fontSize:16,
              color: tdBlack,
              decoration: TextDecoration.lineThrough,
            ),
          ),
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
              onPressed: (){},
            ),
          ),
        ));
  }
}
