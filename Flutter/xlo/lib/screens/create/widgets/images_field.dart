import 'package:flutter/material.dart';
import 'package:xlo/screens/create/widgets/image_source_sheet.dart';

class ImagesField extends StatelessWidget {

  final FormFieldSetter<List> onSaved;
  final List initialValue;

  ImagesField({this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return FormField<List>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: (images){
        if(images.isEmpty)
          return "Campo obrigatório";
        return null;
      },
      builder: (state){
        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              height: 140.0,
              child: ListView.builder(
                itemBuilder: (context, index){
                  if(index == state.value.length){
                    return GestureDetector(
                      onTap: (){
                        showModalBottomSheet(context: context, builder: (context) => ImageSourceSheet(
                          (image){
                            if(image != null)
                              state.didChange(state.value..add(image));
                            Navigator.of(context).pop();
                          }
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 52,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                size: 50.0,
                                color: Colors.white,
                              ),
                              Text(
                                '+ inserir',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }else {
                    return GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.file(state.value[index]),
                                FlatButton(
                                  onPressed: (){
                                    state.didChange(state.value..removeAt(index));
                                    Navigator.of(context).pop();
                                  }, 
                                  child: Text('Excluir'),
                                  textColor: Colors.red,
                                )
                              ],
                            ),
                          )
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                        child: CircleAvatar(
                          backgroundImage: FileImage(state.value[index]),
                          radius: 52,
                        ),
                      ),
                    );
                  }
                },
                scrollDirection: Axis.horizontal,
                itemCount: state.value.length + 1,
              ),
            ),
            if(state.hasError)
              Container(
                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              )
          ],
        );
      },
    );
  }
}