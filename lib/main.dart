import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/constants/alias_field_names.dart';
import 'package:flutter_deneme/constants/type_enums.dart';
import 'package:flutter_deneme/constants/user_field_names.dart';
import 'package:flutter_deneme/model/alias.dart';
import 'package:flutter_deneme/model/alias_instruments.dart';
import 'package:flutter_deneme/model/follow.dart';
import 'package:flutter_deneme/model/labels/label.dart';
import 'package:flutter_deneme/model/user.dart';
import 'package:flutter_deneme/services/alias_service.dart';
import 'package:flutter_deneme/services/follow.dart';
import 'package:flutter_deneme/services/authenticate_service.dart';
import 'package:flutter_deneme/services/instruments_service.dart';
import 'package:flutter_deneme/services/label/label_service.dart';

String token = "";
Future<void> _onBackgroundMessage(RemoteMessage message) async {

  //onBackgroundMessage fonksiyonu tetiklendiği zaman bu fonksiyon çalışacak.
  //Parametre olarak aldığı RemoteMessage nesnesi okunarak istenen işlemler gerçekleştirilecek.
  print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>_onBackgroundMessage Tetiklendi");
  print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.title:" +
          message.notification!.title!);
  print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.body:" +
          message.notification!.body!);
  return;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    FirebaseMessaging.instance.getToken().then((value) {
      print("Device Token: $value");
      token = value!;
    });
    FirebaseMessaging.instance.subscribeToTopic("default");
     FirebaseMessaging.onMessage.listen((message) {
      //onMessage yapısı bir stream olduğu için listen metodu ile dinliyoruz ve tetiklendiği zaman
      //döndüreceği RemoteMessage nesnesini okuyoruz.
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>onMessage Tetiklendi");
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.title:" +
              message.notification!.title!);
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.body:" +
              message.notification!.body!);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //onMessageOpenedApp yapısı da bir stream olduğu için listen metodu ile dinliyoruz ve tetiklendiği zaman
      //döndüreceği RemoteMessage nesnesini okuyoruz.
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>onMessageOpenedApp Tetiklendi");
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.title:" +
              message.notification!.title!);
      print(
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>message.notification.body:" +
              message.notification!.body!);
    });

    //onBackgroundMessage bir stream değil Future<void> tipinde bir fonksiyondur.
    //Önemli olan şart bağımsız bir alanda çalışıyor olmasıdır. Yani class dışında tanımlanan bir fonksiyon çağrılmalıdır.
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final SignUpService _signUpService = SignUpService();
  final AliasService _aliasService = AliasService();
  final FollowService _followService = FollowService();
  final InstrumentsService _instrumentsService = InstrumentsService();
  final LabelService _labelService = LabelService();
  String fullName = "";
  String company = "";
  int age = 0;
  //int _counter = 0;
  String _counter = "";
  
  void _incrementCounter() {
    setState(() {
      // _counter++;
      /*  try {
        Future<UserCredential> userCredential =  FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: "selim.celik@example.com",
            password: "SuperSecretPassword!"
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }*/

      UserModel userModel = UserModel.WithFields(
          "",
          "selimc",
          "Selim",
          "Çetin",
          "Çelik",
          "slmcelik@yandex.com",
          DateTime.now(),
          1,
          false,
          DateTime.now(),
          "",
          "",
          "");
      String password = "password1";
      String userNameOrEmail = "slmcelik@yandex.com";

      /*_signUpService.signup(userModel, password).then(
          (value) => print(value.status.toString() + " - " + value.message));*/
      /*_signUpService.signin(userNameOrEmail, password).then((value) {
        print("mesaj : " + value.data.toString());
        print(value.message.toString());
      });*/
      print(FirebaseAuth.instance.currentUser?.uid);
      /*  _signUpService.updatePassword("password11", "password1").then((response) {
        print(response.message);
      }).catchError((onError) {
        print(onError.toString());
      });*/
      /*_signUpService
          .signOut()
          .then((value) => print(value.message))
          .catchError((onError) => print("hata"));*/

      /* _signUpService
          .resetPasswordEmail('slmcelik@yandex.com')
          .then((value) => print(value.message))
          .catchError((e) => print("error")); */

      AliasModel alias = AliasModel.withFields(
          _currentUser?.uid ?? "",
          "",
          "Alias1",
          AliasType.INDUSTRY_PROFFESSIONAL,
          false,
          false,
          "",
          "",
          0,
          0,
          0,
          DateTime.now());
      ///////////////////////createAlias
      /*_aliasService.createAlias(alias).then((response) {
        print(response.message);
      });*/
      ///////////////////////////getAliassesByUserId
      /*_aliasService.getAliassesByUserId(_currentUser?.uid ?? "").then((value) {
        for (AliasModel item in value.data) {
          print(item.aliasId + " - " + item.aliasName);
        }
      });*/

      ///////////////////getAliasProfileByAlasId
      /*_aliasService
          .getAliasProfileByAlasId("NbtjMhj1TJbyPOZTrxG4")
          .then((response) {
        if (response.status == 200) {
          AliasModel amodel = response.data;
          print(amodel.aliasName +
              " - " +
              amodel.aliasId +
              " - " +
              amodel.type.toString());
        } else {
          print(response.message);
        }
      });*/
      /////////////////////////deleteAlias
      // _aliasService.deleteAlias("8mtLBMz40zIyY3fiaCfe");
      ///////////////update alias
      /*_aliasService.updateAlias("NbtjMhj1TJbyPOZTrxG4", {
        AliasFieldNames.ALIAS_BIODESCRIPTION:
            "Ali veli description update examp"
      }).then((value) => print(value.message + " - " + value.data));*/

      /*_followService
          .addFollow(FollowModel.withFields("", "NbtjMhj1TJbyPOZTrxG4",
              "32DyYFeAAG1otlTKOa6x", true, DateTime.now()))
          .then((value) => _counter = value.message);*/

      /*_followService
          .removeFollow("NbtjMhj1TJbyPOZTrxG4", "32DyYFeAAG1otlTKOa6x")
          .then((value) => _counter = value.message);*/

      /*  InstrumentsModel _instrumentsModel = InstrumentsModel.withFields(
          "32DyYFeAAG1otlTKOa6x", <String>["Gitar", "Ud"]);

      _instrumentsService.setInstrumentsToAlias(_instrumentsModel);*/

      LabelModel _labelModel = LabelModel.withFields(
          "KF44WVrwm5d4Qur2VNQN2Lf1X8u2",
          "",
          "LabelName",
          "",
          "",
          0,
          0,
          0,
          DateTime.now());
      /***********************************************************   */
      _aliasService
          .getIndustryProffAliasByUserId(_labelModel.userId)
          .then((resIndProffId) async {
        if (resIndProffId.status == 200) {
          await _labelService
              .createNewLabel(_labelModel, resIndProffId.data!.aliasId)
              .then((value) {
            if (value.status == 200) {
              _counter = "ok";
            } else {
              _counter = "error";
            }
          });
        } else {
          _counter = "You must create Industry Proffessional Alias";
        }
      });
      //_labelService.getLabelsByUser("KF44WVrwm5d4Qur2VNQN2Lf1X8u2");
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
