import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import '../../storage/local_storage.dart';

class DocumentDetailScreen extends StatefulWidget {
  final DocumentModel doc;
  const DocumentDetailScreen({super.key, required this.doc});

  @override
  State<DocumentDetailScreen> createState() =>
      _DocumentDetailScreenState();
}

class _DocumentDetailScreenState
    extends State<DocumentDetailScreen> {
  late DocumentModel doc;

  @override
  void initState() {
    super.initState();
    doc = widget.doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doc.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Titular: ${doc.holderName}'),
            Text('Vencimento: ${doc.expiryDate.day}/${doc.expiryDate.month}/${doc.expiryDate.year}'),
            Text('Dias para vencer: ${doc.daysToExpire}'),

            const SizedBox(height: 20),

            if (doc.imagePath != null)
              Image.file(File(doc.imagePath!)),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _replaceImage,
              child: Text(
                doc.imagePath == null
                    ? 'Adicionar imagem'
                    : 'Substituir imagem',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _replaceImage() async {
    // mock de caminho (integração câmera/file vem depois)
    const fakePath = '/tmp/document.jpg';

    final updated = doc.copyWith(imagePath: fakePath);
    await LocalStorage.save(updated);

    setState(() => doc = updated);
  }
}
