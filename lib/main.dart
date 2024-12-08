import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'academia.dart';

// Configuração do Logger
final Logger _logger = Logger('AcademiasApp');

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}

void main() {
  setupLogging();
  runApp(const AcademiasApp());
}

class AcademiasApp extends StatelessWidget {
  const AcademiasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: const MenuInicial(),
    );
  }
}

class MenuInicial extends StatelessWidget {
  const MenuInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.fitness_center, // Ícone de musculação
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const Text(
              'SEJA BEM-VINDO!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Explore as melhores academias da sua região!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListaAcademias()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'LISTA DE ACADEMIAS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaAcademias extends StatefulWidget {
  const ListaAcademias({Key? key}) : super(key: key);

  @override
  State<ListaAcademias> createState() => _ListaAcademiasState();
}

class _ListaAcademiasState extends State<ListaAcademias> {
  List<Academia> academias = [];
  bool isLoading = true;

  Future<void> fetchAcademias() async {
    final url = Uri.parse('https://arquivos.ectare.com.br/academias.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          academias = (data as List).map((json) => Academia.fromJson(json)).toList();
          isLoading = false;
        });
        _logger.info('Academias carregadas com sucesso.');
      } else {
        _logger.warning('Falha ao carregar dados da API. Código: ${response.statusCode}');
        throw Exception('Falha ao carregar dados da API');
      }
    } catch (error) {
      _logger.severe('Erro ao buscar academias: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAcademias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LISTA DE ACADEMIAS'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: academias.length,
              itemBuilder: (context, index) {
                final academia = academias[index];
                int imagemIndex = index + 1;

                return Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.orange, width: 1.5),
                  ),
                  child: ListTile(
                    leading: ClipOval( // Tornando a imagem redonda
                      child: Image.asset(
                        'images/academia$imagemIndex.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      academia.nome.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.orange, size: 20),
                            const SizedBox(width: 5),
                            Text(academia.localizacao),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.fitness_center, color: Colors.orange, size: 20),
                            const SizedBox(width: 5),
                            Text(academia.tipo),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.orange, size: 20),
                            const SizedBox(width: 5),
                            Text(academia.horarioFuncionamento),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
