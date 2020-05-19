import 'package:rxdart/rxdart.dart';
import 'package:xlo/blocs/login/button_state.dart';
import 'package:xlo/blocs/login/field_state.dart';
import 'package:xlo/blocs/login/login_bloc_state.dart';
import 'package:xlo/validators/login_validator.dart';

class LoginBloc with LoginValidator{

  final BehaviorSubject<LoginBlocState> _stateController = BehaviorSubject<LoginBlocState>
  .seeded(LoginBlocState(LoginState.IDLE));
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  Function(String)get changeEmail => _emailController.sink.add;
  Function(String)get changePassword => _passwordController.sink.add;

  Stream<LoginBlocState> get outState => _stateController.stream;
  Stream<FieldState> get outEmail => Rx.combineLatest2(_emailController.stream.transform(emailValidator), outState, (a, b){
    a.enabled = b.state != LoginState.LOADING;
    return a;
  });
  Stream<FieldState> get outPassword => Rx.combineLatest2(_passwordController.stream.transform(passwordValidator), outState, (a, b){
    a.enabled = b.state != LoginState.LOADING;
    return a;
  });
  Stream<ButtonState> get outLoginButton => Rx.combineLatest3(outEmail, outPassword, outState, (email, pass, state){
    return ButtonState(
      loading: state == LoginState.LOADING,
      enabled: email.error == null && pass.error == null && state != LoginState.LOADING,
    );
  });
  
  void dispose(){
    _emailController.close();
    _passwordController.close();    
  }

  Future<bool> loginWithEmail() async{
    _stateController.add(LoginBlocState(LoginState.LOADING));

    await Future.delayed(Duration(seconds: 2));

    _stateController.add(LoginBlocState(LoginState.DONE));
    return true;
  }

  Future<bool> loginWithFacebook() async{
    _stateController.add(LoginBlocState(LoginState.LOADING_FACE));

    await Future.delayed(Duration(seconds: 2));

    _stateController.add(LoginBlocState(LoginState.DONE));
    return true;
  }

}