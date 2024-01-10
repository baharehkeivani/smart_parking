import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CarPlate extends StatefulWidget {
  final FocusNode firstFocusNode;
  final FocusNode nextFocusNode;
  final TextEditingController controller;

  const CarPlate({
    Key? key,
    required this.firstFocusNode,
    required this.nextFocusNode,
    required this.controller,
  }) : super(key: key);

  @override
  CarPlateState createState() => CarPlateState();
}

class CarPlateState extends State<CarPlate> {
  late List<TextEditingController> controllers;
  late List<FocusNode> nodes;

  @override
  void initState() {
    controllers = List.generate(4, (index) => TextEditingController());
    nodes = List.generate(
        4, (index) => index == 0 ? widget.firstFocusNode : FocusNode());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: Image.asset(
            "assets/image/${Theme.of(context).brightness == Brightness.light ? "plate_iran_transparent" : "plate_iran_white"}.png",
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 25, end: 50, top: 22, bottom: 22),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 4,
                child: _textField(
                  index: 0,
                  maxLength: 2,
                  hintText: "12",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: _textField(
                  index: 1,
                  maxLength: 1,
                  hintText: 'ب',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[آ-ی]$')),
                    LengthLimitingTextInputFormatter(1)
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: _textField(
                  index: 2,
                  maxLength: 3,
                  hintText: "456",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3)
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: _textField(
                  index: 3,
                  maxLength: 2,
                  hintText: "78",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textField(
      {List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      required String hintText,
      required int index,
      required int maxLength}) {
    return TextFormField(
      controller: controllers[index],
      focusNode: nodes[index],
      inputFormatters: inputFormatters,
      textAlign: TextAlign.center,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 15),
        hintText: hintText,
      ),
      validator: MultiValidator([
        RequiredValidator(errorText: "*"),
      ]),
      onTapOutside: (event) {
        nodes[index].unfocus();
      },
      onChanged: (value) {
        if (value.length == maxLength) {
          if (index == 3) {
            widget.nextFocusNode.requestFocus();
            widget.controller.text =
                controllers.map((controller) => controller.text).join(' ');
          } else {
            nodes[index + 1].requestFocus();
          }
        }
      },
      onFieldSubmitted: (value) {
        if (index == 3) {
          widget.nextFocusNode.requestFocus();
          widget.controller.text =
              controllers.map((controller) => controller.text).join(' ');
        } else {
          nodes[index + 1].requestFocus();
        }
      },
    );
  }
}
