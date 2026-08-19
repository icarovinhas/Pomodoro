import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoService {
  final FlutterLocalNotificationsPlugin _notificacoes =
      FlutterLocalNotificationsPlugin();

  Future<void> inicializar() async {
    if (kIsWeb) {
      await _inicializarWeb();
    } else {
      await _inicializarAndroid();
    }
  }

  Future<void> _inicializarWeb() async {
    const WebInitializationSettings configuracaoWeb =
        WebInitializationSettings();

    const InitializationSettings configuracoes = InitializationSettings(
      web: configuracaoWeb,
    );

    await _notificacoes.initialize(settings: configuracoes);
  }

  Future<void> _inicializarAndroid() async {
    const AndroidInitializationSettings configuracaoAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings configuracoes = InitializationSettings(
      android: configuracaoAndroid,
    );

    await _notificacoes.initialize(settings: configuracoes);
  }

  Future<void> mostrarNotificacao({
    required String titulo,
    required String mensagem,
  }) async {
    if (kIsWeb) {
      await _mostrarNotificacaoWeb(titulo: titulo, mensagem: mensagem);
    } else {
      await _mostrarNotificacaoAndroid(titulo: titulo, mensagem: mensagem);
    }
  }

  Future<void> _mostrarNotificacaoWeb({
    required String titulo,
    required String mensagem,
  }) async {
    await _notificacoes.show(id: 0, title: titulo, body: mensagem);
  }

  Future<void> _mostrarNotificacaoAndroid({
    required String titulo,
    required String mensagem,
  }) async {
    const AndroidNotificationDetails detalhesAndroid =
        AndroidNotificationDetails(
          'pomodoro',
          'Pomodoro',
          channelDescription: 'Notificações do Pomodoro',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails detalhes = NotificationDetails(
      android: detalhesAndroid,
    );

    await _notificacoes.show(
      id: 0,
      title: titulo,
      body: mensagem,
      notificationDetails: detalhes,
    );
  }

  Future<void> solicitarPermissaoWeb() async {
    if (kIsWeb) {
      final webPlugin = _notificacoes
          .resolvePlatformSpecificImplementation<
            WebFlutterLocalNotificationsPlugin
          >();

      await webPlugin?.requestNotificationsPermission();
    }
  }
}
