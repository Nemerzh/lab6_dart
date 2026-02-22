/// Вхідні дані для калькулятора електричних навантажень.
class CalculatorInputData {
  /// Коефіцієнт ефективності (η).
  final double nominalEfficCoefEp;

  /// Коефіцієнт потужності (cos φ).
  final double loadPowerCoef;

  /// Номінальна напруга, кВ (Uном).
  final double loadVoltage;

  /// Кількість приладів по групах (n, шт).
  final List<int> numberOfEps;

  /// Номінальна потужність по групах, кВт (Рном).
  final List<double> nominalPowerOfEps;

  /// Коефіцієнти використання (Кв).
  final List<double> coefUsings;

  /// Коефіцієнти реактивної потужності (tg φ).
  final List<double> reactivePowerCoefs;

  const CalculatorInputData({
    this.nominalEfficCoefEp = 0.92,
    this.loadPowerCoef = 0.9,
    this.loadVoltage = 0.38,
    this.numberOfEps = const [4, 2, 4, 1, 1, 1, 2, 1, 2, 2],
    this.nominalPowerOfEps = const [
      20.0, 14.0, 42.0, 36.0, 20.0, 40.0, 32.0, 20.0, 100.0, 120.0
    ],
    this.coefUsings = const [
      0.15, 0.12, 0.15, 0.3, 0.5, 0.2, 0.2, 0.65, 0.2, 0.8
    ],
    this.reactivePowerCoefs = const [
      1.33, 1.0, 1.33, 1.52, 0.75, 1.0, 1.0, 0.75, 3.0
    ],
  });

  CalculatorInputData copyWith({
    double? nominalEfficCoefEp,
    double? loadPowerCoef,
    double? loadVoltage,
    List<int>? numberOfEps,
    List<double>? nominalPowerOfEps,
    List<double>? coefUsings,
    List<double>? reactivePowerCoefs,
  }) {
    return CalculatorInputData(
      nominalEfficCoefEp: nominalEfficCoefEp ?? this.nominalEfficCoefEp,
      loadPowerCoef: loadPowerCoef ?? this.loadPowerCoef,
      loadVoltage: loadVoltage ?? this.loadVoltage,
      numberOfEps: numberOfEps ?? List.from(this.numberOfEps),
      nominalPowerOfEps:
          nominalPowerOfEps ?? List.from(this.nominalPowerOfEps),
      coefUsings: coefUsings ?? List.from(this.coefUsings),
      reactivePowerCoefs:
          reactivePowerCoefs ?? List.from(this.reactivePowerCoefs),
    );
  }
}
