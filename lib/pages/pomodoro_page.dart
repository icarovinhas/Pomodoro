import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pomodoro_model.dart';

import '../services/notificacao_service.dart';

class PomodoroPage extends StatefulWidget {
  final int minutosFoco;
  final int minutosPausa;
  final int minutosPausaLonga;
  final Function(Pomodoro) onPomodoroConcluido;

  const PomodoroPage({
    super.key,
    required this.minutosFoco,
    required this.minutosPausa,
    required this.minutosPausaLonga,
    required this.onPomodoroConcluido,
  });

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late int segundosRestantes;

  Timer? timer;

  bool estaRodando = false;
  bool estaEmFoco = true;
  bool estaEmPausaLonga = false;

  int pomodorosConcluidos = 0;

  final NotificacaoService notificacaoService = NotificacaoService();

  @override
  void initState() {
    super.initState();

    segundosRestantes = widget.minutosFoco * 60;

    notificacaoService.inicializar();
  }

  @override
  void didUpdateWidget(covariant PomodoroPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.minutosFoco != widget.minutosFoco ||
        oldWidget.minutosPausa != widget.minutosPausa ||
        oldWidget.minutosPausaLonga != widget.minutosPausaLonga) {
      timer?.cancel();

      setState(() {
        segundosRestantes = widget.minutosFoco * 60;
        estaRodando = false;
        estaEmFoco = true;
        estaEmPausaLonga = false;
      });
    }
  }

  double calcularProgresso() {
    final int duracaoTotal;

    if (estaEmFoco) {
      duracaoTotal = widget.minutosFoco * 60;
    } else if (estaEmPausaLonga) {
      duracaoTotal = widget.minutosPausaLonga * 60;
    } else {
      duracaoTotal = widget.minutosPausa * 60;
    }

    return segundosRestantes / duracaoTotal;
  }

  Color obterCorModo() {
    if (estaEmFoco) {
      return Colors.red;
    }

    if (estaEmPausaLonga) {
      return Colors.blue;
    }

    return Colors.green;
  }

  Color obterCorFundo() {
    if (estaEmFoco) {
      return Colors.red.shade50;
    }

    if (estaEmPausaLonga) {
      return Colors.blue.shade50;
    }

    return Colors.green.shade50;
  }

  String formatarTempo() {
    final minutos = segundosRestantes ~/ 60;
    final segundos = segundosRestantes % 60;

    return '${minutos.toString().padLeft(2, '0')}:'
        '${segundos.toString().padLeft(2, '0')}';
  }

  Future<void> iniciarContagem() async {
    if (estaRodando) {
      return;
    }

    await notificacaoService.solicitarPermissaoWeb();

    setState(() {
      estaRodando = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (segundosRestantes > 0) {
        setState(() {
          segundosRestantes--;
        });
      } else {
        trocarModo();
      }
    });
  }

  void pararContagem() {
    timer?.cancel();
    timer = null;

    setState(() {
      estaRodando = false;
    });
  }

  void reiniciarContagem() {
    timer?.cancel();
    timer = null;

    setState(() {
      segundosRestantes = widget.minutosFoco * 60;

      estaRodando = false;
      estaEmFoco = true;
      estaEmPausaLonga = false;

      pomodorosConcluidos = 0;
    });
  }

  void trocarModo() {
    if (estaEmFoco) {
      notificacaoService.mostrarNotificacao(
        titulo: 'Pomodoro concluído!',
        mensagem: 'Hora de fazer uma pausa.',
      );

      pomodoroConcluido();
    } else {
      notificacaoService.mostrarNotificacao(
        titulo: 'Pausa concluída!',
        mensagem: 'Hora de voltar ao foco.',
      );

      iniciarFoco();
    }
  }

  void pomodoroConcluido() {
    final pomodoro = Pomodoro(
      data: DateTime.now(),
      duracao: widget.minutosFoco,
    );

    widget.onPomodoroConcluido(pomodoro);

    setState(() {
      pomodorosConcluidos++;

      estaEmFoco = false;

      if (pomodorosConcluidos % 4 == 0) {
        estaEmPausaLonga = true;

        segundosRestantes = widget.minutosPausaLonga * 60;
      } else {
        estaEmPausaLonga = false;

        segundosRestantes = widget.minutosPausa * 60;
      }
    });
  }

  void iniciarFoco() {
    setState(() {
      estaEmFoco = true;
      estaEmPausaLonga = false;

      segundosRestantes = widget.minutosFoco * 60;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corModo = obterCorModo();
    final corFundo = obterCorFundo();
    final progresso = calcularProgresso();

    return Scaffold(
      backgroundColor: corFundo,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'POMODORO',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  estaEmFoco
                      ? 'FOCO'
                      : estaEmPausaLonga
                      ? 'PAUSA LONGA'
                      : 'PAUSA CURTA',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: corModo,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: 280,
                  height: 280,

                  child: Stack(
                    alignment: Alignment.center,

                    children: [
                      SizedBox(
                        width: 280,
                        height: 280,

                        child: CircularProgressIndicator(
                          value: progresso,
                          strokeWidth: 15,

                          backgroundColor: Colors.grey[300],

                          valueColor: AlwaysStoppedAnimation<Color>(corModo),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            formatarTempo(),

                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            estaEmFoco ? 'Tempo de foco' : 'Tempo de descanso',

                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Pomodoros concluídos: $pomodorosConcluidos',

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: 220,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: estaRodando ? pararContagem : iniciarContagem,

                    icon: Icon(estaRodando ? Icons.pause : Icons.play_arrow),

                    label: Text(estaRodando ? 'PAUSAR' : 'INICIAR'),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: corModo,
                      foregroundColor: Colors.white,

                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: 220,
                  height: 50,

                  child: OutlinedButton.icon(
                    onPressed: reiniciarContagem,

                    icon: const Icon(Icons.refresh),

                    label: const Text('REINICIAR'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: corModo,

                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
