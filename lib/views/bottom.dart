import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => launchUrlString('https://www.p1gd0g.cc'),
          label: Text('关注作者 @p1gd0g'),
          icon: Icon(Icons.account_circle),
        ),
        // Text('不构成投资建议！', style: TextStyle(color: Colors.red)),
        TextButton.icon(
          onPressed: () => launchUrlString('https://x.p1gd0g.cc'),
          label: Text('Gridder 网格交易测试工具'),
          icon: Icon(Icons.link),
        ),
      ],
    );
  }
}
