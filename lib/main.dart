import 'package:flutter/material.dart';
import 'package:ngoding_arisan/input_peserta_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App Arisan Bos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameTextController = TextEditingController();
  Set<String> dataNamas = {};

  final inputPesertaBloc = InputPesertaBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild widget utama");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16.0),
              TextField(
                controller: nameTextController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Masukan nama peserta!')),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      String getName = nameTextController.text.trim();
                      if (getName.isEmpty) {
                        return;
                      }
                      InputPesertaEvent inputEvent = InputPesertaEvent(getName);
                      inputPesertaBloc.eventSink.add(inputEvent);
                      nameTextController.clear();
                    },
                    child: const Text('Simpan Peserta')),
              ),
              StreamBuilder<Object>(
                  stream: inputPesertaBloc.findWinnerStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("only rebuild widget showdialog");
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showDialog(
                            context,
                            snapshot.data
                                as String); // Memastikan dialog hanya ditampilkan jika ada data
                      });
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.red),
                          ),
                          onPressed: () {
                            if (dataNamas.isNotEmpty) {
                              FindWinnerEvent winnerEvent =
                                  FindWinnerEvent(dataNamas);
                              inputPesertaBloc.eventSink.add(winnerEvent);
                            } else {
                              print("Tidak ada nama peserta.");
                            }
                            //_showDialog(context, snapshot.data as String);
                          },
                          child: const Text('Find The Winner')),
                    );
                  }),
              StreamBuilder(
                  stream: inputPesertaBloc.inputPesertaStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        (snapshot.hasData && snapshot.data!.isEmpty)) {
                      return const SizedBox.shrink();
                    }
                    dataNamas.add(snapshot.data!);
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dataNamas
                              .map((nama) => textDecorationCustom(nama))
                              .toList(),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String winnerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("The winner is"),
          content: Text(winnerName),
          actions: <Widget>[
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}

Widget textDecorationCustom(String text) {
  return SizedBox(
    width: double.infinity,
    child: Container(
      margin: const EdgeInsets.all(
          8.0), // Margin luar untuk memisahkan dari elemen lain
      padding: const EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 20.0), // Padding dalam untuk teks
      decoration: BoxDecoration(
        color: Colors.amber[400], // Warna latar untuk "sel"
        border: Border.all(
          color: Colors.amber[700]!, // Warna garis tepi
          width: 2, // Ketebalan garis tepi
        ),
        borderRadius: BorderRadius.circular(4), // Melengkungkan sudut
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black, // Warna teks
          fontWeight: FontWeight.bold, // Ketebalan teks
        ),
      ),
    ),
  );
}
