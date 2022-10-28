import 'dart:async';

class AuthBloc {
  final StreamController _nameControlller = StreamController();
  final StreamController _emailControlller = StreamController();
  final StreamController _passControlller = StreamController();
  final StreamController _phoneControlller = StreamController();

  Stream get nameStream => _nameControlller.stream;
  Stream get emailStream => _emailControlller.stream;
  Stream get passStream => _passControlller.stream;
  Stream get phoneStream => _phoneControlller.stream;

  bool isValid(String name, String email, String pass, String phone) {
    if (name.isEmpty) {
      _nameControlller.sink.addError("Nhap ten");
      return false;
    }
    _nameControlller.sink.add("");

    if (phone.isEmpty) {
      _phoneControlller.sink.addError("Nhap SDT");
      return false;
    }
    _phoneControlller.sink.add("");

    if (email.isEmpty) {
      _emailControlller.sink.addError("Nhap email");
      return false;
    }
    _emailControlller.sink.add("");

    if (pass.length < 6) {
      _passControlller.sink.addError("Mat Khau phai tren 5 ky tu");
      return false;
    }
    _passControlller.sink.add("");

    return true;
  }

  bool isValidLogin(String email, String pass) {
    if (email.isEmpty) {
      _emailControlller.sink.addError("Nhap email");
      return false;
    }
    _emailControlller.sink.add("");

    if (pass.isEmpty) {
      _passControlller.sink.addError("Nhap password");
      return false;
    }
    _passControlller.sink.add("");

    return true;
  }

  void dispose() {
    _nameControlller.close();
    _passControlller.close();
    _phoneControlller.close();
    _emailControlller.close();
  }
}
