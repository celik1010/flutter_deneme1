import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import'package:http/http.dart' as http;

//İndirdiğimiz json dosyasından istenilen değerleri alıp buraya yerleştiriyoruz.
var serviceAccountJson ={
  "type": "service_account",
  "project_id": "flutterdeneme-fd01a",
  "private_key_id": "5cb58cd084698ac325e81ce760f2965508662948",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDY6EudfLJTosod\nk9hWH6VVVp7u5m5+mDEEYaIL9ft9WsvEqqiHlhvmj5BtuAfp6BDPRjdljljqN+5v\n5cZYaPYi6PWJZfOXvQOFUZLBkZuYBg0678f/ImXSEUg4b9007nuGtenYdOpTqePr\nlqv2wI8KCqLqYv5pqC4b1WN9Gx4/SBJ7Q5DfJPNknhplNBMSV64WyrKp1nnuLqvW\ng2BGa0FMvktxJwrwZHRVvwpTdgPl4Mowkn+NTLOSu2tVsvMbmfQSdRoJkOQTIU29\nDCYdPp0mz9ZK2VEIyyW/e4VdOnvoxHeC4L6N88PN+G98auu82lDooVmNjUn8oNio\nhMjtjeY1AgMBAAECggEAAoBhUcCcwjTjKFTjaTuGJFm5hlZoJcH+n2Nzozgs3x6j\nTeeiDVEjKkqBusKlJkZKAcib7/9rvF3DQ38LE8tw+pOWl8UyJQG0HUY9stee2cbz\nbEa37GIwCEHbtdXNGF2KDjX3B+ecmvwC5kDzHLHrFindhEmlJRXZP9Y0Bo0xpmmM\nOoEgaOOMc3jLbowTODol9QCmSK8v2vDcWrK92stE+mQkn8crwK/r78rt1EtS2j0K\ngep3DEu+N1WavkrtpTv4+8Buc2iHGWOEDsB+HAdH6MNGIgtSCvQv5BpB0HRl79Jx\nujlyrf/IqKrvciXTX0nzF5oa9WpMq31JGOP57D7NQQKBgQD8fNeMYybRj3DZ/ee/\nbHSYMv8lrkQUQBb0/a9os5dY3wHJKjGL8lYnnOfTFCTtW/d+XeEMxmm+aaclLKBG\nZhZxYxutq7yFqVqgDsqhNLd+eiEm3TE3Iwoh2bMR0a8iQa+91qOLyHvSBk72gxtl\nxSzLyQvGwBG16T9BavUJR0sK9QKBgQDb7L6/p6J9WmebwjYsT8IJUNoycWzTDzOR\nP7UUUt9tEICskUzfi4WRn8/mz/q7l6yySdW2TJHQOV6wYZ4E110bHSO04uAK2uK0\nxzgI/6ddlbXS+E8TQ/qhQNY5vevrcyXZ4MFUChki6z3peSOAvDDZP1szURQq1g+y\nXzD90AjmQQKBgQDsHjPVbcQXpfT7Z58aPOqsisRhEJ9J8MWHRtaLK6gVzDd3UKYV\nIgO/99Q0aVo/Pwoses7Di6nIEDXnZdxc+YtzbiOsPjaHKOE/XZXRO+N9u+jU13X3\nAiWvkk8MEvOdLaCT/+3iAxMITi36CpHMkqBZ0yHYNDZb0Ez/eG6+xpU/IQKBgDBc\nB7nHF+DunzfN5fGqfCVmRQSwklh60EERPDVC3+Rwq4rGzJufZ3iVJrc/ZogXmx79\nQ2Q5xBqAcwTgAkpYPR34M2DUPqXEafOMlxLLfLcEc533ghPfb95DjpfV3mnAwUL+\nvCRJsCtQhSWwwJDPUQKEfv5yxreAqKT1b6VwOHTBAoGAHCJIMXtt+wjMcv3Bd/2w\n40Cm2d8nRu9cutfJhzBF41h4JFTq4zWWcoSiDps9QWydh0AUmC3IvDG5w3bjcQLA\nhND/06uKsvU5kcW9RldfDEyCzuD10i778az89FMrJq7n7pJ1Xnzw1X7k+t4KiTSI\nneh8F4m2jXzCj2xQzJxhERc=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-d7009@flutterdeneme-fd01a.iam.gserviceaccount.com",
  "client_id": "111695603288682669816",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-d7009%40flutterdeneme-fd01a.iam.gserviceaccount.com"
};

Future<bool> sendNotification(Map<String, dynamic> notification) async {
  /*
  * sendNotification fonksiyonu ile parametre olarak aldığımız notification nesnesini kullanarak bir bildirim göndermeyi hedefliyoruz.
  */

  //yukarıda oluşturduğumuz json dosyasını parametre olarak geçerek bir accountCredential elde ediyoruz.
  //Bu credential bize API için gerekli olan accessToken'i verecek.
  final accountCredentials =
      ServiceAccountCredentials.fromJson(serviceAccountJson);

  //Scope ile hangi platforma erişmek istediğimize dair bir bilgilendirme yapıyoruz.
  List<String> scopes = ["https://www.googleapis.com/auth/cloud-platform"];

  //Oluşturduğumuz credential ve scopes değişkenlerini parametre olarak verdiğimiz fonksiyon bize access tokeni içeren bir client döndürüyor.
  //Future bir metod olduğu için then metodu içerisinde bildirim gönderme işlemini gerçekleştireceğiz.
  try {
    try {
      clientViaServiceAccount(accountCredentials, scopes)
          .then((AuthClient client) async {
        //Hazırlanan uri ile gerçekleştireceğimiz post işleminin adresini belirliyoruz.
        //URL içerisindeki your-project-name kısmına firebase'de geçerli olan proje adınızı yazacaksınız.
        //(Firebase konsoldayken tarayıcıdan URL'ye bakarsanız proje adnız orada bulunmaktadır.)
        Uri _url = Uri.https(
            "fcm.googleapis.com", "/v1/projects/your-project-name/messages:send");

        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<accessToken:${client.credentials.accessToken}");

        //client ile yeni bir post işlemi tanımlıyoruz.
        //Yukarıda tanımlanan uri ile nereye post işlemi yapacağımızı belirtiyoruz
        //header kısmında gerekli Authorization işlemi için aldığımız accessToken'i yerleştiriyoruz.
        // yük olarak ise notification nesnesini json olarak ayarlayıp gönderiyoruz.
        http.Response _response = await client.post(
          _url,
          headers: {"Authorization": "Bearer ${client.credentials.accessToken}"},
          body: json.encode(notification),
        );  
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${_response.body}");
        client.close();
      });
    } catch (e, s) {
      print(s);
    }
  } catch (e, s) {
    print(s);
  }
  return true;
}