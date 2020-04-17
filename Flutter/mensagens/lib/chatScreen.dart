import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mensagens/chatMessage.dart';
import 'package:mensagens/textComposer.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser _currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      FirebaseAuth.instance.onAuthStateChanged.listen((user){
        _currentUser = user;
      });
    });
  }

  Future<FirebaseUser> _getUser() async{
    if(_currentUser != null)
      return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(authCredential);
      final FirebaseUser user = authResult.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  void _sendMessage({String text, File imgFile}) async{
    
    final FirebaseUser user = await _getUser();

    if(user == null){
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Não foi possível fazer o login, tente novamente"),
          backgroundColor: Colors.red
        ),
      );
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "time": Timestamp.now()
    };
    
    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
        user.uid + DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

      setState(() {
        _isLoading = true;
      });
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data["imgURL"] = url;

      setState(() {
        _isLoading = false;
      });
    }
    if(text != null) data["text"] = text;
    Firestore.instance.collection("mensagens").add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _currentUser != null ? 'Olá, ${_currentUser.displayName}' : 'Chat App'
        ),
        elevation: 0,
        actions: <Widget>[
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app), 
            onPressed: (){
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              SnackBar(content: Text("Saiu com sucesso"));
            }
          ): Container(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index){
                        return ChatMessage(documents[index].data, 
                        documents[index].data['uid'] == _currentUser?.uid);
                      }
                    );
                }
              },
              stream: Firestore.instance.collection("mensagens").orderBy("time").snapshots(),
            )
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      )
    );
  }
}