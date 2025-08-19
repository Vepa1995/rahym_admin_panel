import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final nameC = TextEditingController();   // Kime degişli
  late TextEditingController phoneC;       // Telefon
  final amountC = TextEditingController(); // Möçber

  final List<_Transfer> transfers = [];

  static const int kDailyAmountLimit = 350;
  static const int kDailyCountLimit = 7;

  @override
  void initState() {
    super.initState();
    // Telefon meýdanynyň öňünden +993 ýazylgy ýagdaýda açylmagy
    phoneC = TextEditingController(text: "+993");
  }

  bool _isValidTMCell(String phone) {
    // diňe +9936 bilen başlasa we jemi 12 nyşan bolsa
    final reg = RegExp(r'^\+9936\d{7}$');
    return reg.hasMatch(phone);
  }

  int _todayTotalFor(String phone) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    int sum = 0;
    for (var t in transfers) {
      if (t.phone == phone && t.time.isAfter(start) && t.time.isBefore(end)) {
        sum += t.amount;
      }
    }
    return sum;
  }

  int _todayCountFor(String phone) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    int count = 0;
    for (var t in transfers) {
      if (t.phone == phone && t.time.isAfter(start) && t.time.isBefore(end)) {
        count++;
      }
    }
    return count;
  }

  void _send() {
    final name = nameC.text.trim();
    final phone = phoneC.text.trim();
    final amountStr = amountC.text.trim();

    if (name.isEmpty) {
      _showError("Kime degişli ýazylmaly.");
      return;
    }
    if (!_isValidTMCell(phone)) {
      _showError("Nomer diňe +9936xxxxxxx görnüşinde bolmaly.");
      return;
    }
    if (amountStr.isEmpty || int.tryParse(amountStr) == null) {
      _showError("Möçber san bolmaly.");
      return;
    }

    final amount = int.parse(amountStr);
    if (amount < 1 || amount > 50) {
      _showError("Möçber 1–50 manat aralygynda bolmaly.");
      return;
    }

    final todaySum = _todayTotalFor(phone);
    final todayCount = _todayCountFor(phone);

    if (todayCount >= kDailyCountLimit) {
      _showError("Bu gün şol nomere $kDailyCountLimit gezekden köp geçirim edip bolmaýar.");
      return;
    }
    if (todaySum + amount > kDailyAmountLimit) {
      _showError("Bu gün 350 manatdan köp pul geçrip bolmaýar.");
      return;
    }

    setState(() {
      transfers.insert(0, _Transfer(name: name, phone: phone, amount: amount, time: DateTime.now()));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Geçirim üstünlikli (UI diňe)")),
    );

    amountC.clear();
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Duýduryş"),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = phoneC.text.trim();
    final validPhone = _isValidTMCell(phone);
    final sum = validPhone ? _todayTotalFor(phone) : 0;
    final cnt = validPhone ? _todayCountFor(phone) : 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Transfer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(
                labelText: "Kime degişli",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Telefon meýdany öňünden +993 bilen
            TextField(
              controller: phoneC,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[+\d]')),
                LengthLimitingTextInputFormatter(12),
              ],
              decoration: const InputDecoration(
                labelText: "Telefon (+9936xxxxxxx)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: amountC,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Möçber (1–50 manat)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: validPhone
                  ? Text(
                "Şu gün jemi: $sum m. | Galýan limit: ${kDailyAmountLimit - sum} m. | Geçirim sany: $cnt/$kDailyCountLimit",
                style: const TextStyle(fontSize: 12),
              )
                  : const Text("Nomer: diňe +9936xxxxxxx görnüşinde bolmaly", style: TextStyle(fontSize: 12)),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _send,
                child: const Text("Ugrat"),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Soňky geçirimler", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: transfers.length,
                itemBuilder: (context, i) {
                  final t = transfers[i];
                  final hh = t.time.hour.toString().padLeft(2, '0');
                  final mm = t.time.minute.toString().padLeft(2, '0');
                  return ListTile(
                    leading: const Icon(Icons.arrow_upward, color: Colors.teal),
                    title: Text("${t.name} (${t.phone})"),
                    subtitle: Text("Wagt: $hh:$mm"),
                    trailing: Text("${t.amount} m."),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Transfer {
  final String name;
  final String phone;
  final int amount;
  final DateTime time;
  _Transfer({required this.name, required this.phone, required this.amount, required this.time});
}
