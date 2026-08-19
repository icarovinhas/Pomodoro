import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/notificacao_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificacaoService = NotificacaoService();

  await notificacaoService.inicializar();

  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Pomodoro',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),

      home: const HomePage(),
    );
  }
}