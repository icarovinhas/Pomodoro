import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatefulWidget {
  final int minutosFoco;
  final int minutosPausa;
  final int minutosPausaLonga;

  final Function(int, int, int) onSalvar;

  const ConfiguracoesPage({
    super.key,
    required this.minutosFoco,
    required this.minutosPausa,
    required this.minutosPausaLonga,
    required this.onSalvar,
  });

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  late int minutosFoco;
  late int minutosPausa;
  late int minutosPausaLonga;

  @override
  void initState() {
    super.initState();

    minutosFoco = widget.minutosFoco;
    minutosPausa = widget.minutosPausa;
    minutosPausaLonga = widget.minutosPausaLonga;
  }

  @override
  void didUpdateWidget(covariant ConfiguracoesPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    minutosFoco = widget.minutosFoco;
    minutosPausa = widget.minutosPausa;
    minutosPausaLonga = widget.minutosPausaLonga;
  }

  void aumentarFoco() {
    setState(() {
      minutosFoco++;
    });
  }

  void diminuirFoco() {
    if (minutosFoco > 1) {
      setState(() {
        minutosFoco--;
      });
    }
  }

  void aumentarPausa() {
    setState(() {
      minutosPausa++;
    });
  }

  void diminuirPausa() {
    if (minutosPausa > 1) {
      setState(() {
        minutosPausa--;
      });
    }
  }

  void aumentarPausaLonga() {
    setState(() {
      minutosPausaLonga++;
    });
  }

  void diminuirPausaLonga() {
    if (minutosPausaLonga > 1) {
      setState(() {
        minutosPausaLonga--;
      });
    }
  }

  void salvarConfiguracoes() {
    widget.onSalvar(minutosFoco, minutosPausa, minutosPausaLonga);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Configurações salvas!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          const Text(
            'Tempo de foco',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: diminuirFoco,
                icon: const Icon(Icons.remove),
              ),

              Text(
                '$minutosFoco minutos',
                style: const TextStyle(fontSize: 20),
              ),

              IconButton(onPressed: aumentarFoco, icon: const Icon(Icons.add)),
            ],
          ),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            'Pausa curta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: diminuirPausa,
                icon: const Icon(Icons.remove),
              ),

              Text(
                '$minutosPausa minutos',
                style: const TextStyle(fontSize: 20),
              ),

              IconButton(onPressed: aumentarPausa, icon: const Icon(Icons.add)),
            ],
          ),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            'Pausa longa',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: diminuirPausaLonga,
                icon: const Icon(Icons.remove),
              ),

              Text(
                '$minutosPausaLonga minutos',
                style: const TextStyle(fontSize: 20),
              ),

              IconButton(
                onPressed: aumentarPausaLonga,
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: salvarConfiguracoes,
            child: const Text('SALVAR'),
          ),
        ],
      ),
    );
  }
}
