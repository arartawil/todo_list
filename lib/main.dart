import 'package:firebase_core/firebase_core.dart';
import 'todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider_auth.dart';
import 'sign_up.dart';
import 'sign_in.dart';
import 'firebase_options.dart';


Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider_(),
    child: MyApp(),
  ),);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: '/',
      routes: {
        '/': (context) =>LoginPage(),
        '/signup': (context) => SignupPage(),
         '/todo': (context) =>TodoScreen(),

      },
      title: "My App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
