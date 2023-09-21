import 'dart:math';

import 'package:arrivo_test/blocs/todos/todos_bloc.dart';
import 'package:arrivo_test/service/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'service/user_repository.dart';
import '/models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
          create: (context) => UserRepository(), child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  int _counter = 0;
  int page = 1;
  String searchValue = '';
  final TextEditingController _controller = TextEditingController();
  List<User> userList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UsersBloc(
              RepositoryProvider.of<UserRepository>(context),
            )..add(LoadUsers()),
        child: Scaffold(
            body: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
          if (state is UsersLoaded) {
            userList = state.users;
          }
          return ListView(children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SizedBox(
                  width: 200,
                  height: 30,
                  child: TextField(
                    onChanged: (value) {
                      BlocProvider.of<UsersBloc>(context)
                          .add(SearchUser(value));
                      searchValue = value;
                      page = 1;
                      print("value: $value");
                    },
                    style: const TextStyle(fontSize: 12),
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  )),
            ),
            if (state is UsersLoaded)
              DataTable(
                columnSpacing: 2.0,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Color(0xFFE7E9EB)),
                dataRowHeight: 80,
                columns: const [
                  DataColumn(
                      label: Text(
                    'Id',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataColumn(
                      label: Text('UserId',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Title',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Body',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  if (userList.isNotEmpty)
                    for (var item in userList)
                      DataRow(cells: [
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.id.toString()))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.userId.toString()))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.title.toString()))),
                        DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.body.toString()))),
                      ])
                ],
              ),
            if (state is UsersLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            if (state is UsersError) Center(child: Text('NO DATA')),
            if (state is UsersLoaded)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: page > 1
                            ? () {
                                page -= 1;
                                BlocProvider.of<UsersBloc>(context)
                                    .add(FetchPage(page, searchValue));
                              }
                            // Your button's onPressed logic here
                            : null,
                        child: Text('Prev'),
                      )),
                  Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          page += 1;
                          BlocProvider.of<UsersBloc>(context)
                              .add(FetchPage(page, searchValue));
                          // Your button's onPressed logic here
                        },
                        child: Text('Next'),
                      )),
                ],
              )
          ]);
        })));
  }
}
