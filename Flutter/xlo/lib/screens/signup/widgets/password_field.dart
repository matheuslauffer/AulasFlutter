import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {

 final FormFieldSetter<String> onSaved;

 PasswordField({this.onSaved, this.enabled});

 final bool enabled;

  @override
  Widget build(BuildContext context) {

    Widget _buildBar(int n, String pass){
      final int level = _calcScore(pass);
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: n <= level ? _getColor(level) : Colors.transparent,
            border: n > level ? Border.all(color: Colors.grey) : null
          ),
        )
      );
    }
    return FormField<String>(
      initialValue: '',
      onSaved: onSaved,
      validator: (text){
        if(text.isEmpty || _calcScore(text) < 2){
          return "Senha inválida";
        }
        return null;
      },
      builder: (state){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              obscureText: true,
              onChanged: state.didChange,
              enabled: enabled,
            ),
            if(state.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 6.0),
                height: 8.0,
                child: Row(
                  children: <Widget>[
                    _buildBar(0, state.value),
                    _buildBar(1, state.value),
                    _buildBar(2, state.value),
                    _buildBar(3, state.value),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 10.0),
              child: state.value.isNotEmpty || state.hasError ? Text(
                state.value.isNotEmpty ? _getText(_calcScore(state.value)) : state.errorText,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: _getColor(_calcScore(state.value)),
                  fontSize: 12.0
                ),
              ): Container(),
            )
          ],
        );
      },
    );
  }

  int _calcScore(String text){
    int score = 0;
    if(text.length > 8)
      score += 1;
    if(text.contains(RegExp(r'[0-9]')))
      score += 1;
    if(text.contains(RegExp(r'[A-Z]')))
      score += 1;

    return score;
  }

  Color _getColor(int level){
    switch (level) {
      case 0:
        return Colors.red;
        break;
      case 1:
        return Colors.orange;
        break;
      case 2:
        return Colors.greenAccent;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.red;
    }
  }

  String _getText(int level){
    switch (level) {
      case 0:
        return "Senha muito fraca";
        break;
      case 1:
        return "Senha razoalvelmente fraca";
        break;
      case 2:
        return "Senha razoavelmente forte";
        break;
      case 3:
        return "Senha forte";
        break;
      default:
        return "";
    }
  }

}