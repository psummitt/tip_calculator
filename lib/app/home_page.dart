import 'dart:math';
import 'package:flutter/material.dart';

import 'widget/amount_text.dart';
import 'widget/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _bill = 0;
  double _tipValue = 0; // Can be a percentage OR a flat amount
  int _numberOfPeople = 1;

  final _billAmountController = TextEditingController();
  final _tipAmountController = TextEditingController(); // Flat cash tip
  final _numberOfPeopleController = TextEditingController(text: '1');

  String? _selectedPreset;
  final List<String> _presets = ['5', '10', '15', '25', '50'];

  @override
  void initState() {
    super.initState();
    _billAmountController.addListener(_onBillAmountChanged);
    _tipAmountController.addListener(_onCustomTipChanged);
    _numberOfPeopleController.addListener(_numberOfPeopleChanged);
  }

  void _onBillAmountChanged() {
    setState(() {
      _bill = double.tryParse(_billAmountController.text) ?? 0;
    });
  }

  void _onCustomTipChanged() {
    if (_tipAmountController.text.isNotEmpty) {
      setState(() {
        _selectedPreset = null;
        _tipValue = double.tryParse(_tipAmountController.text) ?? 0;
      });
    } else if (_selectedPreset == null) {
      setState(() {
        _tipValue = 0;
      });
    }
  }

  void _numberOfPeopleChanged() {
    setState(() {
      final int? value = int.tryParse(_numberOfPeopleController.text);
      if (value != null && value > 0) {
        _numberOfPeople = value;
      } else {
        _numberOfPeople = 1; // Safeguard for division
      }
    });
  }

  double _getTipAmount() {
    if (_selectedPreset != null) {
      return (_bill * _tipValue) / 100;
    }
    return _tipValue;
  }

  double _getTotalAmount() => _bill + _getTipAmount();

  double _getPerPersonAmount() => _getTotalAmount() / _numberOfPeople;

  void _resetButtonAction() {
    setState(() {
      _selectedPreset = null;
      _bill = 0;
      _tipValue = 0;
      _numberOfPeople = 1;
      _billAmountController.clear();
      _tipAmountController.clear();
      _numberOfPeopleController.text = '1';
    });
  }

  @override
  void dispose() {
    _billAmountController.dispose();
    _tipAmountController.dispose();
    _numberOfPeopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isDesktop = maxWidth > 800;
            const double sidePadding = 32.0;
            const double contentMaxWidth = 1000.0;
            
            // Calculate available width for the input section
            // Padding (32*2) + Spacing (48) in desktop
            final double horizontalPadding = sidePadding * 2;
            const double desktopSpacing = 48.0;
            
            final double availableWidth = isDesktop 
                ? max(0.0, (min(maxWidth, contentMaxWidth) - horizontalPadding - desktopSpacing) / 2)
                : max(0.0, maxWidth - horizontalPadding);

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    children: [
                      logoWidget(),
                      Padding(
                        padding: isDesktop
                            ? const EdgeInsets.only(bottom: 40)
                            : EdgeInsets.zero,
                        child: Container(
                          decoration: isDesktop
                              ? desktopContainerDecoration
                              : containerDecoration,
                          padding: const EdgeInsets.all(sidePadding),
                          child: isDesktop
                              ? IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: _buildInputSection(
                                          availableWidth: availableWidth,
                                          columns: 3,
                                        ),
                                      ),
                                      const SizedBox(width: 48),
                                      Expanded(child: _buildOutputSection(expand: true)),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    _buildInputSection(
                                      availableWidth: availableWidth,
                                      columns: availableWidth > 400 ? 3 : 2,
                                    ),
                                    const SizedBox(height: 32),
                                    _buildOutputSection(expand: false),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required double availableWidth,
    required int columns,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Total Due:',
          controller: _billAmountController,
          icon: Icons.attach_money,
          hint: '0',
          textInputAction: TextInputAction.next,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 40),
        _buildTextField(
          label: 'Ways to split bill:',
          controller: _numberOfPeopleController,
          icon: Icons.person,
          hint: '1',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          errorText: _numberOfPeopleController.text == '0' ? "Can't be zero" : null,
        ),
        const SizedBox(height: 40),
        Text('Tip Percentage:', style: labelText),
        const SizedBox(height: 16),
        _buildTipGrid(width: availableWidth, columns: columns),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required TextInputAction textInputAction,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: labelText),
            if (errorText != null)
              Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Semantics(
          label: label,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8FB),
              borderRadius: BorderRadius.circular(5),
              border: errorText != null
                  ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
                  : null,
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              textInputAction: textInputAction,
              style: const TextStyle(
                fontSize: 24,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: keyboardType,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: textColor),
                hintText: hint,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipGrid({required double width, required int columns}) {
    const double spacing = 16;
    final double itemWidth = max(0.0, (width - (spacing * (columns - 1))) / columns);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        ..._presets.map((p) => _buildPresetButton(p, itemWidth)),
        _buildCustomTipInput(itemWidth),
      ],
    );
  }

  Widget _buildPresetButton(String percentage, double width) {
    bool isSelected = _selectedPreset == percentage;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$percentage percent tip',
      child: SizedBox(
        width: width,
        height: 48,
        child: Material(
          color: isSelected ? accentColor : primaryColor,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPreset = percentage;
                _tipValue = double.parse(percentage);
                _tipAmountController.clear();
              });
            },
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: Text(
                '$percentage%',
                style: TextStyle(
                  color: isSelected ? primaryColor : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTipInput(double width) {
    return Semantics(
      label: 'Custom flat tip amount',
      child: Container(
        width: width,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F8FB),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: TextField(
            controller: _tipAmountController,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 18,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Custom',
              hintStyle: TextStyle(fontSize: 16),
              prefixIcon: Icon(Icons.attach_money, color: textColor, size: 18),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutputSection({bool expand = false}) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _buildOutputBox('Tip Amount', _getTipAmount()),
          const SizedBox(height: 24),
          _buildOutputBox('TOTAL DUE', _getTotalAmount()),
          const Divider(color: accentColor, height: 48, thickness: 1),
          _buildOutputBox('Split Due:', _getPerPersonAmount()),
          if (expand) const Spacer() else const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: (_bill > 0 || _tipValue > 0 || _numberOfPeople > 1)
                  ? _resetButtonAction
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: primaryColor,
                disabledBackgroundColor: accentColor.withOpacity(0.2),
                disabledForegroundColor: primaryColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('RESET'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputBox(String label, double amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          AmountText(
            text: amount.toStringAsFixed(2),
            label: label,
          ),
        ],
      ),
    );
  }
}
