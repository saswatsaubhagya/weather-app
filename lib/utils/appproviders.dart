import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

import '../controllers/weather.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => WeatherController()),
];
