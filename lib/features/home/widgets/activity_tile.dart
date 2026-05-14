import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFEDE9FE),
        child: Icon(Icons.attach_money_rounded, color: Color(0xFF4F46E5)),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: Text(
        amount,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
