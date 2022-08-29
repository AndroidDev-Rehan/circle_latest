import 'package:flutter/material.dart';

class NoGroupFound extends StatelessWidget {
  const NoGroupFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Group does not exist, invalid group link", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
    );
  }
}
