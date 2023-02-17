import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cifrari Classici',
      theme: FlexThemeData.light(scheme: FlexScheme.blue),
      darkTheme:
          FlexThemeData.dark(scheme: FlexScheme.blue, darkIsTrueBlack: true),
      home: const MyHomePage(title: 'Cifrari Classici'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DropdownMenuItem<String>> items =
      ['Atbash', 'Cesare', 'One Time Pad (OTP)', 'Staccionata']
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => launchUrl(Uri.parse(
              "https://it.wikipedia.org/wiki/Categoria:Cifrari_classici")),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Seleziona il cifrario:'),
            const SizedBox(
              height: 25,
            ),
            DropdownButton(
                items: items,
                focusColor: Colors.transparent,
                onChanged: (value) {
                  if (value == "Atbash") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Atbash()),
                    );
                  }

                  if (value == "Cesare") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Cesare()),
                    );
                  }

                  if (value == "One Time Pad (OTP)") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Vernam()),
                    );
                  }

                  if (value == "Staccionata") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Staccionata()),
                    );
                  }
                }),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// ----------- ATBASH -----------

class Atbash extends StatefulWidget {
  const Atbash({super.key});

  @override
  State<Atbash> createState() => _AtbashState();

  static const String routeName = '/atbash';

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const Atbash(),
    );
  }

  static const String title = 'Cifrario di Atbash';
}

class _AtbashState extends State<Atbash> {
  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  String message = '';
  String result = '';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Atbash.title), actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () =>
              launchUrl(Uri.parse("https://it.wikipedia.org/wiki/Atbash")),
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il testo da cifrare',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il testo in chiaro non può essere vuoto';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        message = messageController.text;
                        result = encodeDecode(message);
                      });
                    }
                  },
                  child: const Text('Encrypt / Decrypt'),
                ),
              ]),
              const SizedBox(
                height: 75,
              ),
              Row(
                children: <Widget>[
                  Text('Testo cifrato: $result',
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () => copyToClipboard(),
                      child: const Icon(Icons.copy, size: 20))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  copyToClipboard() {
    Clipboard.setData(ClipboardData(text: result)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Copiato negli appunti')));
    });
  }

  encodeDecode(String message) {
    String result = '';

    for (var element in message.characters) {
      int value = RegExp('[A-Z]').hasMatch(element)
          ? 155
          : RegExp('[a-z]').hasMatch(element)
              ? 219
              : 0;

      if (value != 0) {
        result += String.fromCharCode(value - element.codeUnitAt(0));
      } else {
        result += element;
      }
    }
    return result;
  }
}

// ----------- CESARE -----------

class Cesare extends StatefulWidget {
  const Cesare({super.key});

  @override
  State<Cesare> createState() => _CesareState();

  static const String routeName = '/cesare';

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const Cesare(),
    );
  }

  static const String title = 'Cifrario di Cesare';
}

class _CesareState extends State<Cesare> {
  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  final keyController = TextEditingController();
  String message = '';
  String result = '';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Cesare.title), actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => launchUrl(
              Uri.parse("https://it.wikipedia.org/wiki/Cifrario_di_Cesare")),
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il testo da cifrare',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il testo in chiaro non può essere vuoto';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: keyController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci la chiave',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il campo chiave non può essere vuoto';
                  }

                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Il campo chiave deve essere composto solo da numeri';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        message = messageController.text;
                        result = encodeDecode(message);
                      });
                    }
                  },
                  child: const Text('Encrypt / Decrypt'),
                ),
              ]),
              const SizedBox(
                height: 75,
              ),
              Row(
                children: <Widget>[
                  Text('Testo cifrato: $result',
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () => copyToClipboard(),
                      child: const Icon(Icons.copy, size: 20))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  copyToClipboard() {
    Clipboard.setData(ClipboardData(text: result)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Copiato negli appunti')));
    });
  }

  encodeDecode(String message) {
    String result = '';

    for (var element in message.characters) {
      int offset = RegExp('[A-Z]').hasMatch(element)
          ? 65
          : RegExp('[a-z]').hasMatch(element)
              ? 97
              : 0;

      if (offset != 0) {
        result += String.fromCharCode(
            ((element.codeUnitAt(0) - offset + int.parse(keyController.text)) %
                    26) +
                offset);
      } else {
        result += element;
      }
    }
    return result;
  }
}

// ----------- VERNAM -----------

class Vernam extends StatefulWidget {
  const Vernam({super.key});

  @override
  State<Vernam> createState() => _VernamState();

  static const String routeName = '/vernam';

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const Vernam(),
    );
  }

  static const String title = 'Cifrario di Vernam';
}

class _VernamState extends State<Vernam> {
  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  final keyController = TextEditingController();
  String message = '';
  String result = '';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Vernam.title), actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => launchUrl(
              Uri.parse("https://it.wikipedia.org/wiki/Cifrario_di_Vernam")),
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il testo da cifrare',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il testo in chiaro non può essere vuoto';
                  }

                  if (value.length != keyController.text.length) {
                    return 'La chiave deve essere lunga quanto il testo in chiaro';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: keyController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci la chiave',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il campo chiave non può essere vuoto';
                  }

                  if (value.length != messageController.text.length) {
                    return 'La chiave deve essere lunga quanto il testo in chiaro';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          message = messageController.text;
                          result = encode(message);
                        });
                      }
                    },
                    child: const Text('Encrypt'),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          message = messageController.text;
                          result = decode(message);
                        });
                      }
                    },
                    child: const Text('Decrypt'),
                  ),
                ],
              ),
              const SizedBox(
                height: 75,
              ),
              Row(
                children: <Widget>[
                  Text('Testo cifrato: $result',
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () => copyToClipboard(),
                      child: const Icon(Icons.copy, size: 20))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  copyToClipboard() {
    Clipboard.setData(ClipboardData(text: result)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Copiato negli appunti')));
    });
  }

  encode(String message) {
    String result = '';

    String alfabeto = 'abcdefghijklmnopqrstuvwxyz';

    message.toLowerCase();
    keyController.text.toLowerCase();

    for (var i = 0; i < message.length; i++) {
      if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(message[i])) {
        result += message[i];
        continue;
      }

      int index = alfabeto.indexOf(message[i]);

      int key = alfabeto.indexOf(keyController.text[i]);

      int sum = (index + key) % 26;

      result += alfabeto[sum];
    }
    return result;
  }

  decode(String message) {
    String result = '';

    String alfabeto = 'abcdefghijklmnopqrstuvwxyz';

    message.toLowerCase();
    keyController.text.toLowerCase();

    for (var i = 0; i < message.length; i++) {
      if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(message[i])) {
        result += message[i];
        continue;
      }

      int index = alfabeto.indexOf(message[i]);

      int key = alfabeto.indexOf(keyController.text[i]);

      int sum = index - key;

      if (sum < 0) {
        sum += 26;
      }

      result += alfabeto[sum];
    }

    return result;
  }
}

// ----------- Cifrario a staccionata -----------

class Staccionata extends StatefulWidget {
  const Staccionata({super.key});

  @override
  State<Staccionata> createState() => _StaccionataState();

  static const String routeName = '/staccionata';

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const Staccionata(),
    );
  }

  static const String title = 'Cifrario a staccionata';
}

class _StaccionataState extends State<Staccionata> {
  final _formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  final keyController = TextEditingController();
  String message = '';
  String result = '';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Staccionata.title), actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () => launchUrl(Uri.parse(
              "https://it.wikipedia.org/wiki/Cifrario_a_staccionata")),
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il testo da cifrare',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il testo in chiaro non può essere vuoto';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: keyController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci la chiave (il numero di righe)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Il campo chiave non può essere vuoto';
                  }

                  if (!RegExp("[0-9]").hasMatch(value)) {
                    return 'La chiave deve essere numerica';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          message = messageController.text;
                          result = encode(message);
                        });
                      }
                    },
                    child: const Text('Encrypt'),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          message = messageController.text;
                          result = decode(message);
                        });
                      }
                    },
                    child: const Text('Decrypt'),
                  ),
                ],
              ),
              const SizedBox(
                height: 75,
              ),
              Row(
                children: <Widget>[
                  Text('Testo cifrato: $result',
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () => copyToClipboard(),
                      child: const Icon(Icons.copy, size: 20))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  copyToClipboard() {
    Clipboard.setData(ClipboardData(text: result)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Copiato negli appunti')));
    });
  }

  encode(String message) {
    String result = '';

    message.toLowerCase();
    keyController.text.toLowerCase();

    int row = int.parse(keyController.text);

    var matrice = List.generate(row, (i) => List.filled(4, "", growable: true));

    int i = 0;

    for (int j = 0; i < message.length; j++) {
      matrice[j].insert(i, message[i]);

      if (j == row - 1) {
        j = 0;
      }

      i++;
    }

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < matrice[i].length; j++) {
        result += matrice[i][j];
      }
    }

    return result;
  }

  decode(String message) {
    String result = '';

    message.toLowerCase();
    keyController.text.toLowerCase();

    int key = int.parse(keyController.text);

    int row = key;

    var matrice = List.generate(row, (i) => List.filled(4, "", growable: true));

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < message.length / row; j++) {
        matrice[i].add(message[j]);
      }
    }

    int i = 0;

    for (int j = 0; i < message.length; j++) {
      result += matrice[j][i];

      if (j == row - 1) {
        j = 0;
      }

      i++;
    }

    return result;
  }
}
