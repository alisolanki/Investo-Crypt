import 'package:flutter/material.dart';

class InputProvider extends ChangeNotifier {
  double _durationValue = 1.0;
  double _riskValue = 1.0;

  set durationValue(double duration) => this._durationValue = duration;
  set riskValue(double risk) => this._riskValue = risk;

  double get durationValue {
    return _durationValue;
  }

  double get riskValue {
    return _riskValue;
  }
}
