import 'package:admin/constants.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.light().copyWith(
        dataTableTheme: DataTableThemeData(
            dataRowColor: WidgetStatePropertyAll(Colors.amber),
            headingRowColor: WidgetStatePropertyAll(Colors.amber),
            
            decoration: BoxDecoration(color: Colors.white)),
        scaffoldBackgroundColor: const Color(0XFFEFEFEF),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: const Color.fromARGB(255, 39, 39, 39)),
        canvasColor: const Color.fromARGB(255, 255, 255, 255),
        // dataTableTheme: DataTableThemeData(
        //   headingRowColor: MaterialStateProperty.all(Colors.blue[300]),
        //   dataRowColor: MaterialStateProperty.all(Colors.white),
        // ),
      ),

      //     theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: Colors.grey[900],
      //   cardColor: Colors.grey[850],
      //   dataTableTheme: DataTableThemeData(
      //     headingRowColor: MaterialStateProperty.all(Colors.blue[300]),
      //     dataRowColor: MaterialStateProperty.all(Colors.grey[800]),
      //   ),
      //   textTheme: TextTheme(
      //     bodyMedium: TextStyle(color: Colors.white),
      //   ),
      // ),
      home: MainScreen(),
    );
  }
}
