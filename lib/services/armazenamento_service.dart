import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pomodoro_model.dart';

class ArmazenamentoService {
  static const String chaveHistorico = 'historico';

  static const String chaveMinutosFoco = 'minutosFoco';
  static const String chaveMinutosPausa = 'minutosPausa';
  static const String chaveMinutosPausaLonga = 'minutosPausaLonga';

  Future<void> salvarHistorico(List<Pomodoro> historico) async {
    final preferencias = await SharedPreferences.getInstance();

    final lista = historico.map((pomodoro) => pomodoro.toMap()).toList();

    final json = jsonEncode(lista);

    await preferencias.setString(chaveHistorico, json);
  }

  Future<void> salvarConfiguracoes({
    required int minutosFoco,
    required int minutosPausa,
    required int minutosPausaLonga,
  }) async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setInt(chaveMinutosFoco, minutosFoco);

    await preferencias.setInt(chaveMinutosPausa, minutosPausa);

    await preferencias.setInt(chaveMinutosPausaLonga, minutosPausaLonga);
  }

  Future<Map<String, int>> carregarConfiguracoes() async {
    final preferencias = await SharedPreferences.getInstance();

    return {
      'minutosFoco': preferencias.getInt(chaveMinutosFoco) ?? 25,

      'minutosPausa': preferencias.getInt(chaveMinutosPausa) ?? 5,

      'minutosPausaLonga': preferencias.getInt(chaveMinutosPausaLonga) ?? 15,
    };
  }

  Future<List<Pomodoro>> carregarHistorico() async {
    final preferencias = await SharedPreferences.getInstance();

    final json = preferencias.getString(chaveHistorico);

    if (json == null) {
      return [];
    }

    final lista = jsonDecode(json) as List;

    return lista
        .map((item) => Pomodoro.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> limparHistorico() async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.remove(chaveHistorico);
  }
}
