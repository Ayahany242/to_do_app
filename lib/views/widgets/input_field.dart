import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_task/views/size_config.dart';

import '../../controllers/theme_provider.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    ProviderLogic provider = Provider.of<ProviderLogic>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: provider.headingStyle,
          ),
          Container(
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // color: Theme.of(context).primaryColor,
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller,
                  autofocus: false,
                  readOnly: widget != null ? true : false,
                  style: provider.subTitleStyle,
                  cursorColor:
                      provider.isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: provider.subTitleStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).backgroundColor, width: 0),
                    ),
                    //   focusedBorder: ,
                  ),
                )),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
