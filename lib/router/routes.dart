// import 'dart:js';

import 'package:financial_calc/screens/breakeven.dart';
import 'package:financial_calc/screens/depreciation.dart';
import 'package:financial_calc/screens/displayBCratioResult.dart';
import 'package:financial_calc/screens/emiCalc.dart';
import 'package:financial_calc/screens/incomeTaxCacl.dart';
import 'package:financial_calc/screens/irrCalc.dart';
import 'package:financial_calc/screens/mirrCalc.dart';
import 'package:financial_calc/screens/multipleBcRatio.dart';
import 'package:financial_calc/screens/payBackCacl.dart';
import 'package:financial_calc/screens/sensitivity.dart';
import 'package:financial_calc/screens/sensitivitychart.dart';
import 'package:financial_calc/screens/breakevenchart.dart';
import 'package:flutter/material.dart';
import '../screens/compoundInterestCalc.dart';
import 'package:financial_calc/router/route_names.dart';
import 'package:financial_calc/router/routes.dart';

import 'package:financial_calc/screens/home1.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomePageWidget());

      case RouteName.emiScreen:
        return MaterialPageRoute(builder: (context) => const EmiCalc());

      case RouteName.compoundInterestScreen:
        return MaterialPageRoute(builder: (context) => const compIntCalc());

      case RouteName.breakEvenScreen:
        return MaterialPageRoute(builder: (context) => const BreakEven());

      case RouteName.incomeTaxScreen:
        return MaterialPageRoute(builder: (context) => const TaxCalc());

      case RouteName.irrScreen:
        return MaterialPageRoute(builder: (context) => const Irr());

      case RouteName.mirrScreen:
        return MaterialPageRoute(builder: (context) => const MIRR());

      case RouteName.bcRatioScreen:
        return MaterialPageRoute(builder: (context) => const BcRatio());

      case RouteName.payBackScreen:
        return MaterialPageRoute(builder: (context) => const Pbp());

      case RouteName.sensetivityScreen:
        return MaterialPageRoute(builder: (context) => const Sensitivity());

      case RouteName.depreciationScreen:
        return MaterialPageRoute(builder: (context) => const Depreciation());

      case RouteName.bcRatioResultScreen:
        return MaterialPageRoute(builder: (context) {
          print(settings.arguments);
          return DisplayBCRatio(
              data: settings.arguments as Map<String, dynamic>);
        });

      case RouteName.breakEvenChartScreen:
        return MaterialPageRoute(builder:  (context) {
          return BreakevenChart(
            tables: settings.arguments as List );
        });
      
      case RouteName.sensetivityChartScreen:
        return MaterialPageRoute(builder:  (context) {
          return SensitivityChart(
            tables: settings.arguments as List<dynamic>);
        });

      default:
        return MaterialPageRoute(builder: (context) {
          return Text('hello');
        });
    }
  }
}
