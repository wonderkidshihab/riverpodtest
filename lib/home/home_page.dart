import 'dart:html';
import 'dart:js_util';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

@JSExport()
class _HomePageState extends State<HomePage> {
  final listOfSales = [
    SalesData('Jan', 35),
    SalesData('Feb', 28),
    SalesData('Mar', 34),
    SalesData('Apr', 32),
    SalesData('May', 40)
  ];

  @override
  void initState() {
    setProperty(window, "increament", allowInterop(addSalesData));
    setProperty(window, "decreament", allowInterop(removeSalesData));
    final export = createDartExport(this);
    setProperty(globalThis, 'appstate', export);
    setProperty(globalThis, 'sendFromJS', allowInterop(recieveDataFromJS));
    super.initState();
  }

  recieveDataFromJS(SalesDataJS salesData) {
    print(salesData.month);
    print(salesData.sales);
    setState(() {
      listOfSales.add(SalesData(salesData.month ?? "N\A", salesData.sales));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return SyncFusionChart(
                listOfSales: listOfSales,
              );
            },
            itemCount: 20,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Add/Remove Data with flutter',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        addSalesData();
                      },
                      child: Text('Add'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        removeSalesData();
                      },
                      child: Text('Remove'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  addSalesData() {
    setState(() {
      listOfSales.add(SalesData(_getNextMonth(listOfSales.last.month),
          Random().nextInt(100).toDouble()));
    });
  }

  _getNextMonth(String? month) {
    switch (month) {
      case 'Jan':
        return 'Feb';
      case 'Feb':
        return 'Mar';
      case 'Mar':
        return 'Apr';
      case 'Apr':
        return 'May';
      case 'May':
        return 'Jun';
      case 'Jun':
        return 'Jul';
      case 'Jul':
        return 'Aug';
      case 'Aug':
        return 'Sep';
      case 'Sep':
        return 'Oct';
      case 'Oct':
        return 'Nov';
      case 'Nov':
        return 'Dec';
      case 'Dec':
        return 'Jan';
      default:
        return 'Jan';
    }
  }

  removeSalesData() {
    setState(() {
      listOfSales.removeLast();
    });
  }
}

@JS('recieveDataFromDart')
external void recieveDataFromDart(salesData);

class SyncFusionChart extends StatelessWidget {
  const SyncFusionChart({super.key, required this.listOfSales});
  final List<SalesData> listOfSales;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<SalesData, String>(
            dataSource: listOfSales,
            xValueMapper: (SalesData sales, _) => sales.month,
            yValueMapper: (SalesData sales, _) => sales.sales,
            onPointTap: (pointInteractionDetails) {
              recieveDataFromDart(listOfSales
                  .elementAtOrNull(pointInteractionDetails.pointIndex!)
                  ?.toMap());
            },
          )
        ],
      ),
    );
  }
}

class SalesData {
  String? month;
  double sales = 0;

  SalesData(this.month, this.sales);

  SalesData.fromJS(SalesDataJS salesDataJS) {
    this.month = salesDataJS.month;
    this.sales = salesDataJS.sales;
  }

  SalesDataJS toJS() {
    return SalesDataJS(this.month ?? "N\A", this.sales);
  }

  @override
  String toString() {
    return 'SalesData{month: $month, sales: $sales}';
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'sales': sales,
    };
  }
}

@JS()
class SalesDataJS {
  external String? get month;
  external double get sales;

  external SalesDataJS(String month, double sales);
}
