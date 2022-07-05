import 'package:flutter/material.dart';
import 'package:flutter_dio/model/usermodel.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Using Dio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<UserModel>> _getUserList() async {
    try{
      var response = await Dio().get('https://jsonplaceholder.typicode.com/users');
      List<UserModel> _userList = [];
      if(response.statusCode == 200){
        _userList = (response.data as List).map((e) => UserModel.fromMap(e)).toList();

      }
      return _userList;
    }on DioError catch(e){
      debugPrint(e.toString());
      return Future.error(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUserList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: FutureBuilder<List<UserModel>>(
          future:_getUserList(),
          builder:(context,snapshot) {
            if (snapshot.hasData) {
              var userList = snapshot.data!;
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder:(context,index){
                  var user = userList[index];
                  return ListTile(
                    title: Text(user.email) ,
                    subtitle: Text(user.address.toString()),
                    leading: Text(user.id.toString()),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else
              return CircularProgressIndicator();

          },
        ),
      ),
    );
  }
}
