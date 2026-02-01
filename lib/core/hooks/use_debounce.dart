import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

String useDebounce(String input, Duration duration) {
  final debounced = useState(input);

  useEffect(() {
    final timer = Timer(duration, () {
      debounced.value = input;
    });

    return timer.cancel;
  }, [input]);

  return debounced.value;
}
