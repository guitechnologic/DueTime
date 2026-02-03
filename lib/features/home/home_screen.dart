import 'package:flutter/material.dart';
import '../../storage/local_storage.dart';
import '../../models/document_model.dart';
import '../passport/passport_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final passports = LocalStorage.getByType(DocumentType.passport);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Documentos'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PassportFormScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (passports.isNotEmpty)
              _documentCard(
                context,
                title: 'Passaportes',
                count: passports.length,
              ),
          ],
        ),
      ),
    );
  }

  Widget _documentCard(BuildContext context,
      {required String title, required int count}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          Text('$count', style: const TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
