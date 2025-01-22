import 'package:flutter/material.dart';
import 'package:hijriyah_indonesia/hijriyah_khgt.dart';

String arabic = 'ar';
String indonesia = 'id';

void main() {
  /* set locale add this */
  //Hijriyah.setLocal(indonesia);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.green.shade800),
            colorScheme: ColorScheme.light(primary: Colors.green.shade800)),
        home: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Hijriyah Indonesia',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          Hijriyah.fromDate(DateTime(2025, 01, 20)).toString(),
              //.toFormat("EEEE, dd MMMM yyyy"),
          style: const TextStyle(color: Colors.white),
        ), /* converter to hijriyah indonesia */
      ),
    );
  }
}
