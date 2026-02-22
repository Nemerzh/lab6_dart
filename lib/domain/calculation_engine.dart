import 'dart:math';

/// Двигун розрахунків електричних навантажень.
class CalculationEngine {
  static const _sqrt3 = 1.7320508075688772; // sqrt(3)

  /// Виконує всі розрахунки за вхідними даними.
  Map<String, dynamic> performCalculations({
    required double nominalEfficCoefEp,
    required double loadPowerCoef,
    required double loadVoltage,
    required List<int> numberOfEps,
    required List<double> nominalPowerOfEps,
    required List<double> coefUsings,
    required List<double> reactivePowerCoefs,
  }) {
    // 3.1: n * P для кожної групи
    final results31 = <double>[];
    for (var i = 0; i < numberOfEps.length; i++) {
      results31.add(_calculate31(numberOfEps[i], nominalPowerOfEps[i]));
    }

    final resultsCount31First8 =
        results31.take(8).fold<double>(0, (a, b) => a + b);

    // 3.2
    final resultList32 = results31
        .map((r) =>
            double.parse((r / (_sqrt3 * loadVoltage * loadPowerCoef * nominalEfficCoefEp)).toStringAsFixed(1)))
        .toList();

    // 4.1: n * P * Kв
    final result41List = <double>[];
    for (var i = 0; i < results31.length; i++) {
      if (i < coefUsings.length) {
        result41List.add(double.parse(
            (results31[i] * coefUsings[i]).toStringAsFixed(1)));
      }
    }

    final result41Sum =
        result41List.take(8).fold<double>(0, (a, b) => a + b);

    // n * P * Kв * tg φ
    final resultMultOnReactivePowerCoefs = <double>[];
    final nReactive = min(reactivePowerCoefs.length, result41List.length);
    for (var i = 0; i < nReactive; i++) {
      resultMultOnReactivePowerCoefs.add(double.parse(
          (reactivePowerCoefs[i] * result41List[i]).toStringAsFixed(2)));
    }

    final sumMultOnReactivePower =
        resultMultOnReactivePowerCoefs.take(8).fold<double>(0, (a, b) => a + b);

    // n * P²
    final resultPowNumberEpMultOnNominalPower = <double>[];
    for (var i = 0; i < numberOfEps.length; i++) {
      resultPowNumberEpMultOnNominalPower
          .add(numberOfEps[i] * pow(nominalPowerOfEps[i], 2).toDouble());
    }

    final sumPowNumberEpMultOnNominalPower =
        resultPowNumberEpMultOnNominalPower.take(8).fold<double>(0, (a, b) => a + b);

    // 4.2 - 4.7
    final result42 =
        (pow(resultsCount31First8, 2) / sumPowNumberEpMultOnNominalPower).ceil();
    const result43 = 1.25;
    final result44 = result43 * result41Sum;
    final result45 =
        result43 * double.parse(sumMultOnReactivePower.toStringAsFixed(3));
    final result46 = sqrt(pow(result44, 2) + pow(result45, 2));
    final result47 = result44 / loadVoltage;

    final resultsEpCount =
        numberOfEps.take(8).fold<int>(0, (a, b) => a + b);

    // 6.1 - 6.7 (фіксовані значення як в оригіналі)
    const result61 = 752.0 / 2330.0;
    final result62 = pow(2330.0, 2) / 96388.0;
    const result63 = 0.7;
    const result64 = result63 * 752.0;
    const result65 = result63 * 657.0;
    final result66 = sqrt(pow(result64, 2) + pow(result65, 2));
    final result67 = result64 / loadVoltage;

    final resultsCount41 = result41Sum / resultsCount31First8;

    return {
      'results_3_1': results31,
      'results_ep_count': resultsEpCount,
      'results_count_3_1_first_8': resultsCount31First8,
      'results_count_4_1': double.parse(resultsCount41.toStringAsFixed(2)),
      'result_4_1_list': result41List,
      'result_4_1_sum': double.parse(result41Sum.toStringAsFixed(2)),
      'result_mult_on_reactive_power_coefs': resultMultOnReactivePowerCoefs,
      'sum_mult_on_reactive_power': sumMultOnReactivePower.toInt(),
      'result_pow_number_ep_mult_on_nominal_power':
          resultPowNumberEpMultOnNominalPower,
      'sum_pow_number_ep_mult_on_nominal_power':
          sumPowNumberEpMultOnNominalPower,
      'result_4_2': result42,
      'result_4_3': result43,
      'result_4_4': double.parse(result44.toStringAsFixed(2)),
      'result_4_5': double.parse(result45.toStringAsFixed(2)),
      'result_4_6': double.parse(result46.toStringAsFixed(2)),
      'result_4_7': double.parse(result47.toStringAsFixed(2)),
      'result_list_3_2': resultList32,
      'result_6_1': double.parse(result61.toStringAsFixed(2)),
      'result_6_2': double.parse(result62.toStringAsFixed(2)),
      'result_6_3': double.parse(result63.toStringAsFixed(2)),
      'result_6_4': double.parse(result64.toStringAsFixed(2)),
      'result_6_5': double.parse(result65.toStringAsFixed(2)),
      'result_6_6': double.parse(result66.toStringAsFixed(2)),
      'result_6_7': double.parse(result67.toStringAsFixed(2)),
    };
  }

  double _calculate31(int numberOfEp, double nominalPowerOfEp) {
    return numberOfEp * nominalPowerOfEp;
  }
}
