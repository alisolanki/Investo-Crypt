import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/crypto_model.dart';

class DataProvider extends ChangeNotifier {
  List<CryptoModel> cryptoList = [];
  Map<String, double> percentages = {};

  Future<void> getCryptoList() async {
    cryptoList = [];
    final snapshot =
        await FirebaseFirestore.instance.collection('crypto').get();
    print("length: ${snapshot.docs.length}");
    snapshot.docs.forEach((crypto) {
      print(crypto.id);
      Map<String, Map<String, double>> priceChangeTemp = {};
      (crypto.data()['priceChange'] as Map<String, dynamic>)
          .forEach((duration, highLowMap) {
        priceChangeTemp.addAll({
          duration: {
            'low': highLowMap['low'],
            'high': highLowMap['high'],
          },
        });
      });
      cryptoList.add(
        CryptoModel(
          id: crypto.data()['id'],
          logoUrl: crypto.data()['logoUrl'],
          name: crypto.data()['name'],
          priceInUSD: (crypto.data()['priceInUSD'] as double),
          ticker: crypto.data()['ticker'],
          weight: crypto.data()['weight'],
          highLowData: priceChangeTemp,
        ),
      );
    });
    print('got cryptoList: ${cryptoList.length}');
    notifyListeners();
  }

  void calculatePercentages(
    double risk,
    double duration,
  ) {
    Map<String, double> diffPercent = {};
    Map<String, double> weight = {};
    Map<String, double> volatility = {};
    Map<String, double> scoreMap = {};
    double totalDiff = 0.0;
    double totalScore = 0.0;
    String durationString = convertDurationToString(duration);
    cryptoList.forEach((crypto) {
      //api call to get high and low
      double high = crypto.highLowData[durationString]?['high']?.toDouble() ??
          crypto.priceInUSD.toDouble();
      double low =
          crypto.highLowData[durationString]?['low']?.toDouble() ?? 0.0;
      double diff = ((high - low) * 100) / low;
      totalDiff += diff;
      weight.addAll({crypto.id: crypto.weight});
      diffPercent.addAll({crypto.id: diff});
    });
    diffPercent.forEach((cryptoId, diff) {
      double _vol = (diff * 100) / totalDiff;
      volatility.addAll({cryptoId: _vol});
    });
    volatility.forEach((cryptoId, vol) {
      final _w = weight[cryptoId] ?? 0.0;
      final _score = ((log(100 / risk) * _w) - (vol - risk).abs() + 100) / 3;
      scoreMap.addAll({cryptoId: _score});
      totalScore += _score;
    });
    scoreMap.forEach((cryptoId, sc) {
      percentages.addAll({cryptoId: (sc * 100) / totalScore});
    });
    notifyListeners();
  }

  String convertDurationToString(
    double duration,
  ) {
    if (duration < 10) {
      return "1day";
    } else if (duration < 25) {
      return "7day";
    } else if (duration < 40) {
      return "14day";
    } else if (duration < 55) {
      return "30day";
    } else if (duration < 70) {
      return "60day";
    } else if (duration < 85) {
      return "200day";
    }
    return "365day";
  }
}
