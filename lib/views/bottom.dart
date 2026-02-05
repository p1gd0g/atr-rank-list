import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .center,
      children: [
        FButton(
          style: FButtonStyle.ghost(),
          onPress: () => launchUrlString(
            'https://mp.weixin.qq.com/s/JYESvqKBXMbGTPbzuhw39w',
          ),
          prefix: Icon(FIcons.circleQuestionMark),
          child: Text('指标解释'),
        ),

        // PopupMenuButton<int>(
        //   itemBuilder: (context) => [
        //     PopupMenuItem(
        //       value: 1,
        //       child: Row(
        //         children: [
        //           Icon(Icons.link),
        //           SizedBox(width: 8),
        //           Text('Gridder 网格交易测试工具'),
        //         ],
        //       ),
        //       onTap: () => launchUrlString('https://x.p1gd0g.cc'),
        //     ),
        //     PopupMenuItem(
        //       value: 2,
        //       child: Row(
        //         children: [
        //           Icon(Icons.link),
        //           SizedBox(width: 8),
        //           Text('USDer 美元/人民币理财对比'),
        //         ],
        //       ),
        //       onTap: () => launchUrlString('https://u.p1gd0g.cc'),
        //     ),
        //     PopupMenuItem(
        //       value: 3,
        //       child: Row(
        //         children: [
        //           Icon(Icons.account_circle),
        //           SizedBox(width: 8),
        //           Text('关注作者 @p1gd0g'),
        //         ],
        //       ),
        //       onTap: () => launchUrlString(
        //         'https://mp.weixin.qq.com/s/yoFS-PvjhuvyNDBxZNO9Vg',
        //       ),
        //     ),
        //   ],
        //   child: Row(
        //     mainAxisAlignment: .center,
        //     crossAxisAlignment: .center,
        //     children: [Icon(Icons.more_vert), Text('更多'), SizedBox(width: 8)],
        //   ),
        // ),
        FPopoverMenu.tiles(
          menu: [
            FTileGroup(
              children: [
                FTile(
                  title: Text('Gridder 网格交易测试工具'),
                  onPress: () => launchUrlString('https://x.p1gd0g.cc'),
                ),
                FTile(
                  title: Text('USDer 美元/人民币理财对比'),
                  onPress: () => launchUrlString('https://u.p1gd0g.cc'),
                ),
                FTile(
                  title: Text('关注作者 @p1gd0g'),
                  onPress: () => launchUrlString(
                    'https://mp.weixin.qq.com/s/yoFS-PvjhuvyNDBxZNO9Vg',
                  ),
                ),
              ],
            ),
          ],
          builder: (context, value, child) {
            return FButton(
              style: FButtonStyle.ghost(),
              prefix: Icon(FIcons.ellipsisVertical),
              child: Text('更多'),
              onPress: () {
                value.toggle();
              },
            );
          },
        ),
      ],
    );
  }
}
