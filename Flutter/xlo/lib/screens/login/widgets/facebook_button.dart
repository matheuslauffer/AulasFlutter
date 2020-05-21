import 'package:flutter/material.dart';
import 'package:xlo/blocs/login/login_bloc.dart';
import 'package:xlo/blocs/login/login_bloc_state.dart';

class FacebookButton extends StatelessWidget {

  final LoginBloc loginBloc;

  FacebookButton(this.loginBloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      height: 50.0,
      child: StreamBuilder<LoginBlocState>(
        initialData: LoginBlocState(LoginState.IDLE),
        stream: loginBloc.outState,
        builder: (context, snapshot){
          return RaisedButton(
            color: Color.fromRGBO(50, 89, 152, 1),
            disabledColor: Color.fromRGBO(50, 89, 152, 0.7),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
            ),
            onPressed: snapshot.data.state == LoginState.LOADING_FACE ? null : () async {
              final bool success = await loginBloc.loginWithFacebook();
              if(success)
                Navigator.of(context).pop();
            },
            child: snapshot.data.state == LoginState.LOADING_FACE ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
            )
            :
            Text(
              'Entrar com Facebook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              ),
            )
          );
        }
      ),
    );
  }
}