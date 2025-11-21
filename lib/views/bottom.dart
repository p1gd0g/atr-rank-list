import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .center,
      children: [
        // TextButton.icon(
        //   onPressed: () =>
        //       launchUrlString('https://x.p1gd0g.cc/assets/assets/mp.jpg'),
        //   label: Text('关注作者 @p1gd0g'),
        //   icon: Icon(Icons.account_circle),
        // ),
        TextButton.icon(
          onPressed: () => launchUrlString(
            'https://mp.weixin.qq.com/s/bwxiZmZ3MzXMEFltwkdN5g',
          ),
          label: Text('指标解释'),
          icon: Icon(Icons.help),
        ),
        // TextButton.icon(
        //   onPressed: () => launchUrlString('https://x.p1gd0g.cc'),
        //   label: Text('Gridder 网格交易测试工具'),
        //   icon: Icon(Icons.link),
        // ),
        // dropdown menu for Gridder and 关注作者
        PopupMenuButton<int>(
          // icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Icon(Icons.link),
                  SizedBox(width: 8),
                  Text('Gridder 网格交易测试工具'),
                ],
              ),
              onTap: () => launchUrlString('https://x.p1gd0g.cc'),
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 8),
                  Text('关注作者 @p1gd0g'),
                ],
              ),
              onTap: () =>
                  launchUrlString('https://x.p1gd0g.cc/assets/assets/mp.jpg'),
            ),
          ],
          child: Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [Icon(Icons.more_vert), Text('更多'), SizedBox(width: 8)],
          ),
        ),
      ],
    );
  }
}
