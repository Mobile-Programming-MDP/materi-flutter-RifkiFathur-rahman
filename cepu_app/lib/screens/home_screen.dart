import 'package:cepu_app/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()), (route) =>  true);

  }
  String? _idToken = "";
  String? _uid = "";
  String? _email = "";

  Future <void> getFirebaseAuthUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null){
      _uid = user.uid;
      _email = user.email;
      await user
          .getIdToken(true)
          .then(
            (value) => {
            setState(() {
              _idToken = value;
            }),
          },
        );
    }

  }

  @override
  initState() {
    super.initState();
    getFirebaseAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen"), actions: [
        IconButton(onPressed: signOut, icon: Icon(Icons.logout))
      ],),
      body: const Center(child: Text("You Have Been Signed In!")),
    );
  }
}
