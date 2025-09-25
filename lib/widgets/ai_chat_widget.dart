import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIChatWidget extends StatefulWidget {
  const AIChatWidget({super.key});

  @override
  State<AIChatWidget> createState() => _AIChatWidgetState();
}

class _AIChatWidgetState extends State<AIChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  String? _massageCatalogText;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMassageCatalog();
  }

  Future<void> _loadMassageCatalog() async {
    try {
      final locale = context.locale.languageCode;
      final path = 'assets/massages_catalog_$locale.json';

      final exists = await rootBundle
          .loadStructuredData(path, (s) async => s)
          .then((_) => true)
          .catchError((_) => false);

      if (!exists) {
        setState(() => _massageCatalogText = "⚠️ Brak pliku: $path");
        return;
      }

      final jsonString = await rootBundle.loadString(path);
      final jsonData = jsonDecode(jsonString);
      final catalog = jsonData['catalog'] as Map<String, dynamic>;
      final buffer = StringBuffer();

      catalog.forEach((category, massages) {
        buffer.writeln("Kategoria: $category");
        for (var m in massages) {
          buffer.writeln("Tytuł: ${m['title']}");
          buffer.writeln("Opis: ${m['opis']}");
          buffer.writeln("Korzyści: ${m['korzysci']}\n");
        }
      });

      setState(() => _massageCatalogText = buffer.toString());
    } catch (e) {
      setState(
        () => _massageCatalogText = "⚠️ Błąd ładowania katalogu masaży.",
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': '❌ Brakuje klucza API.',
        });
      });
      _scrollToBottom();
      return;
    }

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _loading = true;
    });
    _scrollToBottom();

    final systemPrompt = '''
Jesteś przyjaznym asystentem w salonie masażu Maykay. Masz na imię Maja.
Pomagasz dobrać masaż. Zadaj 2–3 pytania o potrzeby i dobierz coś z katalogu:

${_massageCatalogText ?? "🔄 Katalog masaży jeszcze się ładuje..."}
''';

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": systemPrompt},
            ..._messages,
          ],
          "temperature": 0.6,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiReply = data['choices'][0]['message']['content'];
        setState(() {
          _messages.add({'role': 'assistant', 'content': aiReply});
          _loading = false;
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': '❌ AI błąd: ${response.statusCode}',
          });
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': '❌ Błąd połączenia: $e',
        });
        _loading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFD9F5D9) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg['content'] ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr('ai.assistant_title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textScaler.scale(20),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00B400),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              tr('ai.jak_sie_czujesz'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textScaler.scale(16),
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            if (_messages.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  children: _messages.map(_buildMessage).toList(),
                ),
              ),
            if (_loading) const LinearProgressIndicator(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: tr('ai.type_here'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        _sendMessage(value.trim());
                        _controller.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.green,
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      _sendMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
