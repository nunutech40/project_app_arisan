import 'dart:async';
import 'dart:math';

abstract class InputPesertaPageEvent {
  const InputPesertaPageEvent();

  @override
  List<Object?> get props => [];
}

class InputPesertaEvent extends InputPesertaPageEvent {
  final String nama;
  InputPesertaEvent(this.nama);
}

class FindWinnerEvent extends InputPesertaPageEvent {
  final Set<String> namas;
  FindWinnerEvent(this.namas);
}

class InputPesertaBloc {
  String namaPeserta = "";

  // Controller untuk menangani event input nama peserta
  final StreamController<InputPesertaPageEvent> _eventController =
      StreamController<InputPesertaPageEvent>();

  // Getter untuk mempermudah pengiriman event ke stream
  StreamSink get eventSink => _eventController.sink;

  // Controller untuk mengirimkan nama peserta yang telah diinput ke UI
  final StreamController<String> _inputPesertaController =
      StreamController<String>();
  // Stream yang akan digunakan oleh UI untuk mendapatkan nama peserta yang diinput
  Stream<String> get inputPesertaStream => _inputPesertaController.stream;

  // Controller untuk mengirimkan nama peserta yang telah diinput ke UI
  final StreamController<String> _findWinnerController =
      StreamController<String>();
  // Stream yang akan digunakan oleh UI untuk mendapatkan nama peserta yang diinput
  Stream<String> get findWinnerStream => _findWinnerController.stream;

  InputPesertaBloc() {
    // Mendengarkan event dari eventController. Setiap kali ada event baru (InputPesertaEvent),
    // eventnya adalah input nama
    _eventController.stream.listen((event) {
      // Mengambil nama dari event dan mengirimkannya ke inputPesertaController
      // untuk kemudian dapat ditampilkan di UI

      if (event is InputPesertaEvent) {
        _inputPesertaController.add(event.nama);
      } else if (event is FindWinnerEvent) {
        String winnerName = toFindWinner(event.namas);
        _findWinnerController.add(winnerName);
      }
    });
  }

  String toFindWinner(Set<String> namas) {
    Map<int, String> dataArisan = Map();
    int counter = 0;
    for (final nama in namas) {
      counter++;
      dataArisan[counter] = nama;
    }

    Random dataRandom = Random();
    int getWinnerNumber = dataRandom.nextInt(namas.length);
    String winnerName = dataArisan[getWinnerNumber + 1]!;
    return winnerName;
  }

  void dispose() {
    _eventController.close();
    _inputPesertaController.close();
    _findWinnerController.close();
  }
}
