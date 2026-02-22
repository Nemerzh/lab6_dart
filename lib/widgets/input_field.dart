import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.label,
    required this.value,
    required this.onValueChange,
    this.width = 100,
    this.keyboardType,
    this.readOnly = false,
  });

  final String label;
  final String value;
  final ValueChanged<String> onValueChange;
  final double width;
  final TextInputType? keyboardType;
  final bool readOnly;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(InputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 56,
              child: TextField(
                readOnly: widget.readOnly,
                controller: _controller,
                keyboardType: widget.keyboardType ??
                    TextInputType.numberWithOptions(decimal: true),
                inputFormatters:
                    (widget.keyboardType ?? TextInputType.numberWithOptions(decimal: true)) == TextInputType.number
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                          ],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  border: const OutlineInputBorder(),
                ),
                onChanged:
                    widget.readOnly ? null : widget.onValueChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
