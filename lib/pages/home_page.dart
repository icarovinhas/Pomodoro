import 'package:flutter/material.dart';

import '../models/pomodoro_model.dart';
import '../services/armazenamento_service.dart';
import 'pomodoro_page.dart';
import 'historico_page.dart';
import 'configuracoes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;

  final List<Pomodoro> historico = [];

  final ArmazenamentoService armazenamento = ArmazenamentoService();

  int minutosFoco = 25;
  int minutosPausa = 5;
  int minutosPausaLonga = 15;

  Future<void> adicionarPomodoro(Pomodoro pomodoro) async {
    setState(() {
      historico.add(pomodoro);
    });

    await armazenamento.salvarHistorico(historico);
  }

  Future<void> limparHistorico() async {
    setState(() {
      historico.clear();
    });

    await armazenamento.limparHistorico();
  }

  Future<void> salvarConfiguracoes(int foco, int pausa, int pausaLonga) async {
    setState(() {
      minutosFoco = foco;
      minutosPausa = pausa;
      minutosPausaLonga = pausaLonga;
    });

    await armazenamento.salvarConfiguracoes(
      minutosFoco: foco,
      minutosPausa: pausa,
      minutosPausaLonga: pausaLonga,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      PomodoroPage(
        minutosFoco: minutosFoco,
        minutosPausa: minutosPausa,
        minutosPausaLonga: minutosPausaLonga,
        onPomodoroConcluido: adicionarPomodoro,
      ),

      HistoricoPage(historico: historico, onLimparHistorico: limparHistorico),

      ConfiguracoesPage(
        minutosFoco: minutosFoco,
        minutosPausa: minutosPausa,
        minutosPausaLonga: minutosPausaLonga,
        onSalvar: salvarConfiguracoes,
      ),
    ];

    return Scaffold(
      body: paginas[paginaAtual],

      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaAtual,

        onDestinationSelected: (index) {
          setState(() {
            paginaAtual = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),

          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Histórico',
          ),

          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    carregarHistorico();
    carregarConfiguracoes();
  }

  Future<void> carregarHistorico() async {
    final dados = await armazenamento.carregarHistorico();

    setState(() {
      historico.clear();
      historico.addAll(dados);
    });
  }

  Future<void> carregarConfiguracoes() async {
    final configuracoes = await armazenamento.carregarConfiguracoes();

    setState(() {
      minutosFoco = configuracoes['minutosFoco']!;
      minutosPausa = configuracoes['minutosPausa']!;
      minutosPausaLonga = configuracoes['minutosPausaLonga']!;
    });
  }
}
