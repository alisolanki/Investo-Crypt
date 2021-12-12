import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riskmanagement/models/crypto_model.dart';
import 'package:riskmanagement/provider/data_provider.dart';
import 'package:riskmanagement/provider/input_provider.dart';

class ResultPage extends StatefulWidget {
  static const String route = '/result';

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int touchedIndex = -1;
  bool _init = true;
  Map<String, double> resultMap = {};
  List<CryptoModel> cryptoList = [];

  @override
  void didChangeDependencies() {
    if (_init) {
      getData();
    }
    _init = false;
    super.didChangeDependencies();
  }

  void getData() async {
    final inputProvider = Provider.of<InputProvider>(context, listen: false);
    final risk = inputProvider.riskValue;
    final durationValue = inputProvider.durationValue;

    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.getCryptoList();
    dataProvider.calculatePercentages(risk, durationValue);
    print(resultMap);
  }

  @override
  Widget build(BuildContext context) {
    cryptoList = Provider.of<DataProvider>(context).cryptoList;
    resultMap = Provider.of<DataProvider>(context).percentages;
    return Scaffold(
      body: cryptoList.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(touchCallback: (
                          FlTouchEvent event,
                          pieTouchResponse,
                        ) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        }),
                        startDegreeOffset: 180,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 10,
                        centerSpaceRadius: 40,
                        sections: formSections(),
                      ),
                    ),
                  ),
                  SelectableText(
                    'Portfolio',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.orange,
                        ),
                  ),
                  ...formCryptoList(),
                ],
              ),
            ),
    );
  }

  List<PieChartSectionData> formSections() {
    List<PieChartSectionData> _li = [];
    var len = resultMap.keys.length;
    for (var i = 0; i < len; i++) {
      final crypto = cryptoList.firstWhere(
          (cryptoModel) => cryptoModel.id == resultMap.keys.elementAt(i));
      _li.add(
        PieChartSectionData(
          color: Colors.deepPurpleAccent.withOpacity(len / (len + i)),
          radius: 80,
          showTitle: true,
          title: crypto.name,
          titleStyle: TextStyle(
            fontSize: 18,
          ),
          value: resultMap.values.elementAt(i),
        ),
      );
    }
    return _li;
  }

  List<Widget> formCryptoList() {
    List<Widget> _li = [];
    var len = resultMap.keys.length;
    for (var i = 0; i < len; i++) {
      final crypto = cryptoList.firstWhere(
          (cryptoModel) => cryptoModel.id == resultMap.keys.elementAt(i));
      _li.add(
        ListTile(
          dense: true,
          minVerticalPadding: 20,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
          title: SelectableText(
            crypto.name,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Futura',
            ),
          ),
          trailing: SelectableText(
            '\$${crypto.priceInUSD}',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Futura',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return _li;
  }
}
