import 'package:flutter/foundation.dart';

import '../domain/calculation_engine.dart';
import '../models/calculator_input_data.dart';

class CalculatorViewModel extends ChangeNotifier {
  final CalculationEngine _engine = CalculationEngine();

  CalculatorInputData _inputData = const CalculatorInputData();
  CalculatorInputData get inputData => _inputData;

  Map<String, dynamic> _calculationResults = {};
  Map<String, dynamic> get calculationResults => _calculationResults;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateNominalEfficCoefEp(double value) {
    _inputData = _inputData.copyWith(nominalEfficCoefEp: value);
    notifyListeners();
  }

  void updateLoadPowerCoef(double value) {
    _inputData = _inputData.copyWith(loadPowerCoef: value);
    notifyListeners();
  }

  void updateLoadVoltage(double value) {
    _inputData = _inputData.copyWith(loadVoltage: value);
    notifyListeners();
  }

  void updateNumberOfEp(int index, int value) {
    if (index < _inputData.numberOfEps.length) {
      final list = List<int>.from(_inputData.numberOfEps);
      list[index] = value;
      _inputData = _inputData.copyWith(numberOfEps: list);
      notifyListeners();
    }
  }

  void updateNominalPowerOfEp(int index, double value) {
    if (index < _inputData.nominalPowerOfEps.length) {
      final list = List<double>.from(_inputData.nominalPowerOfEps);
      list[index] = value;
      _inputData = _inputData.copyWith(nominalPowerOfEps: list);
      notifyListeners();
    }
  }

  void updateCoefUsing(int index, double value) {
    if (index < _inputData.coefUsings.length) {
      final list = List<double>.from(_inputData.coefUsings);
      list[index] = value;
      _inputData = _inputData.copyWith(coefUsings: list);
      notifyListeners();
    }
  }

  void updateReactivePowerCoef(int index, double value) {
    if (index < _inputData.reactivePowerCoefs.length) {
      final list = List<double>.from(_inputData.reactivePowerCoefs);
      list[index] = value;
      _inputData = _inputData.copyWith(reactivePowerCoefs: list);
      notifyListeners();
    }
  }

  void performCalculations() {
    _isLoading = true;
    notifyListeners();

    try {
      final d = _inputData;
      _calculationResults = _engine.performCalculations(
        nominalEfficCoefEp: d.nominalEfficCoefEp,
        loadPowerCoef: d.loadPowerCoef,
        loadVoltage: d.loadVoltage,
        numberOfEps: d.numberOfEps,
        nominalPowerOfEps: d.nominalPowerOfEps,
        coefUsings: d.coefUsings,
        reactivePowerCoefs: d.reactivePowerCoefs,
      );
    } catch (e, st) {
      debugPrint('Calculator error: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetToDefaults() {
    _inputData = const CalculatorInputData();
    _calculationResults = {};
    notifyListeners();
  }
}
