import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetails {
  final String email;
  final String password;
  final String name;
  final String mobileNumber;

  UserDetails({
    required this.email,
    required this.password,
    required this.name,
    required this.mobileNumber,
  });
}

class AuthProvider_ extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User? _loggedInUser;

  User? get loggedInUser => _loggedInUser;

  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String mobileNumber,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserDetails userDetails = UserDetails(
        email: email,
        password: password,
        name: name,
        mobileNumber: mobileNumber,
      );

      _loggedInUser = _auth.currentUser;
      notifyListeners();

      // Additional user data can be stored in Firebase Firestore or Realtime Database here
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _loggedInUser = _auth.currentUser;
      notifyListeners();
      return true; // Return true if sign-in is successful
    } catch (e) {
      return false; // Return false if sign-in fails
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      _loggedInUser = null;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  void _handleSignin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Use the modified signIn method that returns a boolean
      bool success = await Provider.of<AuthProvider_>(context, listen: false)
          .signIn(email: email, password: password);

      if (success) {
        Navigator.pushNamed(context, '/home'); // Navigate if sign-in is successful
      } else {
        setState(() {
          errorMessage = "Login failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _handleSignin,
              child: Text("Login"),
            ),
            if (errorMessage != null) ...[
              SizedBox(height: 8),
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
