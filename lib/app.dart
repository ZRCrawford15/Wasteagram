import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import './screens/details.dart';
import 'package:test/screens/home_screen.dart';
import './screens/new_entry.dart';


class App extends StatelessWidget {

  const App({ Key? key }) : super(key: key);

  static final routes = {
    '/': (context) => HomeScreen(),
    NewEntry.routeName: (context) => NewEntry(),
    Details.routeName: (contextt) => Details()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        routes: App.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(secondary: Colors.blue),
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24
            )
          ), 
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            )
          )
          
        ),
      );
  }
}
