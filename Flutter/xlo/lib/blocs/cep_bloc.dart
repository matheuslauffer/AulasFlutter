import 'package:rxdart/rxdart.dart';
import 'package:xlo/api/api_postalcode.dart';
import 'package:xlo/models/address.dart';
import 'package:xlo/repositories/api_response.dart';

enum CepFieldState {INITIALIZING, INCOMPLETE, INVALID, VALID}

class CepBlocState{
  CepFieldState cepFieldState;
  String cep;
  Address address;

  CepBlocState({this.address, this.cep, this.cepFieldState});
}

class CepBloc{

  CepBloc(){
    onChanged('');
  }

  final BehaviorSubject<CepBlocState> _cepController = BehaviorSubject<CepBlocState>();
  Stream<CepBlocState> get outCep => _cepController.stream;

  void dispose(){
    _cepController.close();
  }

  void onChanged(String cep){
    cep = cep.trim().replaceAll('-', '').replaceAll('.', '');
    if(cep.isEmpty || cep.length < 8){
      _cepController.add(
        CepBlocState(
          cepFieldState: CepFieldState.INCOMPLETE,
          cep: cep,

        )
      );
    }else{
      searchCep(cep);
    }
  }

  void searchCep(String cep) async {
    final ApiResponse response = await getAddressFromAPI(cep);
    if(response.success){
      _cepController.add(
        CepBlocState(
          cepFieldState: CepFieldState.VALID,
          cep: cep,
          address: response.result
        )
      );
    }else{
      _cepController.add(
        CepBlocState(
          cepFieldState: CepFieldState.INVALID,
          cep: cep
        )
      );
    }
  }

}