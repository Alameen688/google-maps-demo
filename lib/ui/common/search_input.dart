import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String initialText;
  final TextEditingController textController;
  final Function onSubmitted;

  const SearchInput(
      {Key key,
      @required this.initialText,
      @required this.textController,
      this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(12, 8, 8, 0),
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color.fromRGBO(13, 51, 32, 0.1),
                  offset: Offset(0.0, 6.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: TextField(
              cursorColor: Color(0xFF5B616F),
              controller: textController,
              textInputAction: TextInputAction.go,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: initialText),
            ),
          ),
        )
      ],
    );
  }
}
