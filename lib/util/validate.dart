class ValidateService{
  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }
  bool validateEmail(String value){
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    String? isEmpty = isEmptyField(value);

    if(isEmpty != null){
      return false;
    }
    else if(!regExp.hasMatch(value)){
      return false;
    }
    return true;
  }
}