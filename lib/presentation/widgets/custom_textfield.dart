import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String lableText;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.lableText,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isValid = true;
  bool _showTick = false;
  bool _obscureText = true;

  bool _validateEmail(String value) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value);
  }

  void _onChanged(String value) {
    setState(() {
      if (widget.isPassword) {
        _isValid = value.length >= 6;
      } else {
        _isValid = _validateEmail(value);
      }
      _showTick = _isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: _onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffEFEFEF),
          labelText: widget.lableText,
          helperStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorText: !_isValid
              ? widget.isPassword
                  ? 'Password must be at least 6 characters'
                  : 'Enter a valid Email'
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue[900],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : _showTick
                  ? Icon(
                      Icons.check,
                      color: Colors.blue[900],
                    )
                  : null,
        ),
      ),
    );
  }
}
