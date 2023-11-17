import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcp_console/home_view.dart';

void main() {
  runApp(
    const TcpConsole(),
  );
}

class TcpConsole extends StatelessWidget {
  const TcpConsole({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}
