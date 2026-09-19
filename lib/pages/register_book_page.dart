import 'package:flutter/material.dart';

import '../controllers/register_book_controller.dart';

class RegisterBookPage extends StatefulWidget {
  const RegisterBookPage({super.key});

  @override
  State<RegisterBookPage> createState() => _RegisterBookPageState();
}

class _RegisterBookPageState extends State<RegisterBookPage> {
  final _formKey = GlobalKey<FormState>();
  late final RegisterBookController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterBookController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (await _controller.saveBook() && mounted) {
      Navigator.pop(context, true);
    }
  }

  String? _requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Cadastrar livro')),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: _requiredField,
                  onChanged: _controller.updateTitle,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Autor'),
                  validator: _requiredField,
                  onChanged: _controller.updateAuthor,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 4,
                  validator: _requiredField,
                  onChanged: _controller.updateDescription,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'URL da imagem'),
                  keyboardType: TextInputType.url,
                  validator: _requiredField,
                  onChanged: _controller.updateImageUrl,
                ),
                const SizedBox(height: 24),
                if (_controller.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_controller.errorMessage!),
                  ),
                FilledButton(
                  onPressed: _controller.isSaving ? null : _saveBook,
                  child: _controller.isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
