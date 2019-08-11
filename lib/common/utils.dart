import 'package:intl/intl.dart';

/*
 * 时间格式化
 */
String timeFormat(String time, {String format = 'yyyy-MM-dd HH:mm'}) {
  final DateFormat f = new DateFormat(format);
  final DateTime cur = time != '' ? DateTime.parse(time).toLocal() : DateTime.now();
  return f.format(cur);
}

/*
 * 文档标签汉化映射
 */
String genDocName(String type) {
  var name = '全部';
  switch (type) {
    case 'guide':
      name = '新人指引';
      break;
    case 'standard':
      name = '开发规范';
      break;
    case 'tool':
      name = '工具组件';
      break;
    case 'yy':
      name = '手Y';
      break;
    case 'pcyy':
      name = 'PCYY';
      break;
    case 'zhuikan':
      name = '追看视频';
      break;
    case 'zhuidu':
      name = '追读小说';
      break;
    case 'wechat':
      name = '微信';
      break;
    case 'mini':
      name = '小程序';
      break;
    default:
      break;
  }
  return name;
}