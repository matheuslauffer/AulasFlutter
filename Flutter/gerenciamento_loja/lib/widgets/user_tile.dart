import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {

    final _textStyle = TextStyle(color: Colors.white);
    return ListTile(
      title: Text('title', style: _textStyle,),
      subtitle: Text('subtitle', style: _textStyle,),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('pedidos: 0', style: _textStyle,),
          Text('Gasto: 0', style: _textStyle,),
        ],
      ),
    );
  }
}