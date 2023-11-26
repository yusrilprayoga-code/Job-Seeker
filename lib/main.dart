import 'package:Jobs_Seeker/model/wishlistJobs.dart';
import 'package:Jobs_Seeker/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

String hiveBoxName = 'wishlistJobs';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<WishlistJobs>(WishlistJobsAdapter());
  await Hive.openBox<WishlistJobs>(hiveBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobs Seeker',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: GoogleFonts.palanquin().fontFamily,
      ),
      home: LoginPage(),
    );
  }
}
