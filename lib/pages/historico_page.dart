import 'package:flutter/material.dart';
import '../models/pomodoro_model.dart';

class HistoricoPage extends StatelessWidget {
  final List<Pomodoro> historico;
  final VoidCallback onLimparHistorico;

  const HistoricoPage({
    super.key,
    required this.historico,
    required this.onLimparHistorico,
  });

  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  String formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';
  }

  int calcularMinutosTotais() {
    return historico.fold(
      0,
      (total, pomodoro) => total + pomodoro.duracao,
    );
  }

  void mostrarConfirmacao(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Limpar histórico?',
          ),

          content: const Text(
            'Todos os Pomodoros registrados '
            'serão removidos.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'CANCELAR',
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);

                onLimparHistorico();
              },

              child: const Text(
                'LIMPAR',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final minutosTotais = calcularMinutosTotais();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),

        actions: [
          if (historico.isNotEmpty)
            IconButton(
              onPressed: () {
                mostrarConfirmacao(context);
              },

              icon: const Icon(
                Icons.delete_outline,
              ),

              tooltip: 'Limpar histórico',
            ),
        ],
      ),

      body: historico.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Nenhum Pomodoro concluído',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,

                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 30,
                              color: Colors.red,
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '${historico.length}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const Text(
                              'Pomodoros',
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 30,
                              color: Colors.blue,
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '$minutosTotais min',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const Text(
                              'Tempo de foco',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: historico.length,

                    itemBuilder: (context, index) {
                      final pomodoro =
                          historico[index];

                      return Card(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),

                        child: ListTile(
                          leading: const Icon(
                            Icons.timer,
                            color: Colors.red,
                          ),

                          title: Text(
                            '${pomodoro.duracao} minutos',

                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            '${formatarData(pomodoro.data)} '
                            'às ${formatarHora(pomodoro.data)}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}