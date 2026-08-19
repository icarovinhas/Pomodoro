class Pomodoro {
  final DateTime data;
  final int duracao;

  Pomodoro({
    required this.data,
    required this.duracao,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data.toIso8601String(),
      'duracao': duracao,
    };
  }

  factory Pomodoro.fromMap(Map<String, dynamic> map) {
    return Pomodoro(
      data: DateTime.parse(map['data']),
      duracao: map['duracao'],
    );
  }
}