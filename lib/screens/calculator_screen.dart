import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/calculator_input_data.dart';
import '../presentation/calculator_view_model.dart';
import '../widgets/calculate_button.dart';
import '../widgets/input_field.dart';
import '../widgets/result_field.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  static const _groupNames = [
    'ШР-1\nШліфувальні верстати (1-4)',
    'ШР-1\nСвердлильні верстати (5-6)',
    'ШР-1\nФугувальні верстати (9-12)',
    'ШР-1\nЦиркулярна пила (13)',
    'ШР-1\nПрес (16)',
    'ШР-1\nПолірувальні верстати (24)',
    'ШР-1\nФрезерні верстати (26-27)',
    'ШР-1\nВентилятори (36)',
    'всього ШР 1',
    'всього ШР 2',
    'всього ШР 3',
  ];

  static const _tableHeaders = [
    'Найменування ЕП',
    'η',
    'cos φ',
    'Uном, кВ',
    'n, шт',
    'Рном, кВт',
    'n⋅Рном',
    'Кв',
    'tg φ',
    'n⋅Рном⋅Кв, кВт',
    'n⋅Рном⋅Кв⋅tg φ, кВАр',
    'n⋅Р²',
    'nᵉ',
    'Кр',
    'Ррасч, кВт',
    'Qрасч, кВАр',
    'Sрасч, кВА',
    'Iрасч, А',
  ];

  static const _resultFieldKeys = [
    'result_4_1_list',
    'result_mult_on_reactive_power_coefs',
    'result_pow_number_ep_mult_on_nominal_power',
    'result_4_2',
    'result_4_3',
    'result_4_4',
    'result_4_5',
    'result_4_6',
    'result_4_7',
  ];

  static const _summaryData = [
    ('results_ep_count', 'Кількість приладів:'),
    ('results_count_3_1_first_8', 'n * Pн, кВт:'),
    ('results_count_4_1', 'Kв:'),
    ('result_4_1_sum', 'n * Pн * Kв, кВт:'),
    ('sum_mult_on_reactive_power', 'n * Pн * Kв * tan, квар:'),
    ('sum_pow_number_ep_mult_on_nominal_power', 'Сума n⋅P²:'),
    ('result_6_1', 'Сума Кв:'),
    ('result_6_2', 'Сума n^e:'),
    ('result_6_3', 'Сума Кр:'),
    ('result_6_4', 'Сума Рр:'),
    ('result_6_5', 'Сума Qр:'),
    ('result_6_6', 'Сума Sp:'),
    ('result_6_7', 'Сума Ір:'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<CalculatorViewModel>(
            builder: (context, vm, _) {
              final inputData = vm.inputData;
              final results = vm.calculationResults;

              return ListView(
                children: [
                  Text(
                    "Калькулятор для розрахунку електричних навантажень об'єктів",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _TableHeaders(headers: _tableHeaders),
                  const SizedBox(height: 8),
                  ...List.generate(10, (index) {
                    return _DeviceGroupRow(
                      groupIndex: index,
                      inputData: inputData,
                      calculationResults: results,
                      viewModel: vm,
                      groupName: index < _groupNames.length
                          ? _groupNames[index]
                          : 'ШР ${index + 1}',
                    );
                  }),
                  const SizedBox(height: 16),
                  _SummaryRows(results: results),
                  const SizedBox(height: 16),
                  CalculateButton(
                    onPressed: vm.performCalculations,
                    loading: vm.isLoading,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TableHeaders extends StatelessWidget {
  const _TableHeaders({required this.headers});

  final List<String> headers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: headers.map((header) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SizedBox(
                width: 100,
                height: 50,
                child: Center(
                  child: Text(
                    header,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DeviceGroupRow extends StatelessWidget {
  const _DeviceGroupRow({
    required this.groupIndex,
    required this.inputData,
    required this.calculationResults,
    required this.viewModel,
    required this.groupName,
  });

  final int groupIndex;
  final CalculatorInputData inputData;
  final Map<String, dynamic> calculationResults;
  final CalculatorViewModel viewModel;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).colorScheme.surface,
              child: SizedBox(
                width: 150,
                height: 70,
                child: Center(
                  child: Text(
                    groupName,
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            InputField(
              label: 'η',
              value: inputData.nominalEfficCoefEp.toString(),
              onValueChange: (v) {
                final x = double.tryParse(v);
                if (x != null) viewModel.updateNominalEfficCoefEp(x);
              },
              width: 100,
            ),
            InputField(
              label: 'cos φ',
              value: inputData.loadPowerCoef.toString(),
              onValueChange: (v) {
                final x = double.tryParse(v);
                if (x != null) viewModel.updateLoadPowerCoef(x);
              },
              width: 100,
            ),
            InputField(
              label: 'Uном, кВ',
              value: inputData.loadVoltage.toString(),
              onValueChange: (v) {
                final x = double.tryParse(v);
                if (x != null) viewModel.updateLoadVoltage(x);
              },
              width: 100,
            ),
            if (groupIndex < inputData.numberOfEps.length)
              InputField(
                label: 'n, шт',
                value: inputData.numberOfEps[groupIndex].toString(),
                onValueChange: (v) {
                  final x = int.tryParse(v);
                  if (x != null) viewModel.updateNumberOfEp(groupIndex, x);
                },
                width: 100,
                keyboardType: TextInputType.number,
              ),
            if (groupIndex < inputData.nominalPowerOfEps.length)
              InputField(
                label: 'Рном, кВт',
                value: inputData.nominalPowerOfEps[groupIndex].toString(),
                onValueChange: (v) {
                  final x = double.tryParse(v);
                  if (x != null) viewModel.updateNominalPowerOfEp(groupIndex, x);
                },
                width: 100,
              ),
            ResultField(
              value: _getResultList('results_3_1', groupIndex),
              width: 100,
            ),
            if (groupIndex < inputData.coefUsings.length)
              InputField(
                label: 'Кв',
                value: inputData.coefUsings[groupIndex].toString(),
                onValueChange: (v) {
                  final x = double.tryParse(v);
                  if (x != null) viewModel.updateCoefUsing(groupIndex, x);
                },
                width: 100,
              ),
            if (groupIndex < inputData.reactivePowerCoefs.length)
              InputField(
                label: 'tg φ',
                value: inputData.reactivePowerCoefs[groupIndex].toString(),
                onValueChange: (v) {
                  final x = double.tryParse(v);
                  if (x != null) viewModel.updateReactivePowerCoef(groupIndex, x);
                },
                width: 100,
              ),
            ...CalculatorScreen._resultFieldKeys.map((key) {
              final val = calculationResults[key];
              String text;
              if (val is List) {
                text = (groupIndex < val.length ? val[groupIndex] : '-').toString();
              } else if (val is num) {
                text = groupIndex == 0 ? val.toString() : '-';
              } else {
                text = '-';
              }
              return ResultField(value: text, width: 100);
            }),
          ],
        ),
      ),
    );
  }

  String _getResultList(String key, int index) {
    final list = calculationResults[key];
    if (list is! List || index >= list.length) return '-';
    return list[index].toString();
  }
}

class _SummaryRows extends StatelessWidget {
  const _SummaryRows({required this.results});

  final Map<String, dynamic> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: CalculatorScreen._summaryData.map((e) {
        final (key, label) = e;
        final value = results[key]?.toString() ?? '-';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
