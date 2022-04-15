import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/user_field_names.dart';
import 'package:flutter_deneme/model/user.dart';
import 'package:flutter_deneme/util/response_model.dart';
import 'package:flutter_deneme/util/validate.dart';

class SignUpService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  int statusCode = 0;
  String msg = "";

  Future<ResponseEntity> getUserProfileByUserName(userName) async {
    QuerySnapshot profileData = await _userReference
        .where(UserFieldNames.USERS_USERNAME, isEqualTo: userName)
        .get();
    if (profileData.size != 0) {
      return ResponseEntity(
          200, "Successful", UserModel.fromSnapshot(profileData.docs[0]));
    } else {
      return ResponseEntity(404, "Record Not Found", "");
    }
  }

  Future<ResponseEntity> getUserProfileByUserId(userId) async {
    QuerySnapshot profileData = await _userReference
        .where(UserFieldNames.USERS_USERID, isEqualTo: userId)
        .get();
    if (profileData.size != 0) {
      return ResponseEntity(
          200, "Successful", UserModel.fromSnapshot(profileData.docs[0]));
    } else {
      return ResponseEntity(404, "Record Not Found", "");
    }
  }

  Future<ResponseEntity> signup(UserModel _user, String _password) async {
    ResponseEntity response = ResponseEntity(0, "Request could not worked", "");
    await getUserProfileByUserName(_user.userName).then((value) async {
      if (value == null) {
        await _auth
            .createUserWithEmailAndPassword(
                email: _user.email, password: _password)
            .then((dynamic user) async {
          _user.userId = user.user.uid;

          await _userReference
              .add(_user.toJson())
              .then((value) =>
                  response = ResponseEntity(200, "User Added", _user))
              .catchError((error) => response =
                  ResponseEntity(404, "Failed to add user: $error", ""));
          statusCode = 200;
        }).catchError((error) {
          handleAuthErrors(error);
          response = ResponseEntity(404, msg, "");
        });
      } else {
        response =
            ResponseEntity(404, "User Name already Exist", _user.userName);
      }
    });
    return response;
  }

  Future<ResponseEntity> signin(String userNameOrEmail, String password) async {
    ValidateService validateService = ValidateService();
    ResponseEntity response = ResponseEntity(0, "Request could not worked", "");
    print("Giriş Yapılacak : " + userNameOrEmail);
    if (validateService.validateEmail(userNameOrEmail)) {
      await _auth
          .signInWithEmailAndPassword(
              email: userNameOrEmail, password: password)
          .then((dynamic user) async {
        response = ResponseEntity(200, "Successfully Logged in", user.user.uid);
      }).catchError((error) {
        handleAuthErrors(error);
        response = ResponseEntity(404, msg, "");
      });
    } else {
      await getUserProfileByUserName(userNameOrEmail).then((resValues) async {
        if (resValues.status == 200) {
          await _auth
              .signInWithEmailAndPassword(
                  email: resValues.data.email, password: password)
              .then((dynamic user) async {
            response =
                ResponseEntity(200, "Successfully Logged in", user.user.uid);
          }).catchError((error) {
            handleAuthErrors(error);
            response = ResponseEntity(404, msg, "");
          });
        }
      });
    }
    return response;
  }

  Future<ResponseEntity> signOut() async {
    ResponseEntity responseEntity = ResponseEntity(0, "default message", "");
    await _auth
        .signOut()
        .then((value) => responseEntity = ResponseEntity(200, "Logged Out", ""))
        .catchError((onError) =>
            responseEntity = ResponseEntity(404, "Cold not Logged Out", ""));
    return responseEntity;
  }

  Future<ResponseEntity> updatePassword(
      String oldPassword, String newPassword) async {
    ResponseEntity response = ResponseEntity(0, "Request could not worked", "");
    User? _user = _auth.currentUser;
    if (_user == null) {
      return ResponseEntity(404, "You must logged in first", "");
    }
    String email = _user.email ?? "";
    if (email == "") {
      return ResponseEntity(404, "Email cannot be empty", "");
    }
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: oldPassword,
    )
        .then((value) async {
      await _user.updatePassword(newPassword).then((_) {
        response = ResponseEntity(200, "Password succesfully changed", _user);
      }).catchError((error) {
        response = ResponseEntity(404, "Password can't be changed", "");
      });
    });
    return response;
  }

  Future<ResponseEntity> resetPasswordEmail(String email) async {
    ResponseEntity response = ResponseEntity(0, "Request could not worked", "");
    await _auth.sendPasswordResetEmail(email: email).then((v) {
      response = ResponseEntity(200, "Successfully sent email", email);
    }).catchError((error) {
      response =
          ResponseEntity(404, "Could not Password" + error.toString(), "");
    });
    return response;
  }

  void handleAuthErrors(error) {
    String errorCode = error.code;
    print(error.code);
    switch (errorCode) {
      case "email-already-in-use":
        {
          statusCode = 400;
          msg = "Email ID already existed";
        }
        break;
      case "wrong-password":
        {
          statusCode = 400;
          msg = "Password is wrong";
        }
        break;
      case "user-not-found":
        {
          statusCode = 400;
          msg = "No user found for that email";
        }
    }
  }
}
