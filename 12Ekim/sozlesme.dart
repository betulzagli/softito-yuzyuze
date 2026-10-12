//soyutlama abstraction kavramı

/*
//1. adım contrat sözleşmeler
abstract class AutReposity {
    Future <String> login(String email, String password);
    Future <void> logout();
    bool get isAuth;
}

//implements kullanıldığında contracttır kodu kullanamayız tekrardan göndermek gerekir sözleşme imzasını alır metotları sıfırdan yazıp gönderirirz. kodu değil imzasını alır içini biz doldururuz.
//extendste ise hem davranışı hem de kodu alır. 
class FirebaseAuthReposity implements AutReposity{
    @override 
    Future <String> login(String email, String password) async {
        //gerçek database çağırsı firebase sdk çağrısı
        return "firebase_token_xyz_123";
    }

    @override
    Future<void> logout() async{
      //firebase logout
    }

    @override 
    bool get isAuth => true;

}


//test ve offline simülasyon
class MockAuthReposity implements AutReposity{
  @override 
  Future<String> login(String email, String password) async{
    await Future.delayed(Duration(seconds: 1));
    return "mock_token_abc_789";
  }

  @override 
  Future<void> logout() async{}

  @override
  bool get isAuth => false;

}


//mixin kullanımı
mixin Logger {
  void log(String msg)=> print ("LOG: $msg");
}

mixin Analytics {
  void log (String msg)=> print ("ANALİZ: $msg");
}

class PaymentService with Logger,Analytics{
  void pay(){
    log("ödeme yapıldı");
  }
} //burada analitik logu ezecek çünkü asenkron çalıştırmadık ikisini aynı anda çalıştırabilirisn demedik. önce logu aldı baktı analitik geliyo ezdi analitiği çalıştırdı. en son çalışanı ekrana yazdırdı. 
//eğer kodların ikiis de aynı anda çalışsın istiyorsak asenkron yazmamız ve çalıştırmamız gerekir. ÖNEMLİ !!!!!!


//mixin tek yerde çalıştırma, sadece base widgetta ve alt sınıflarında kullansın
abstract class BaseWidget{}

mixin LifeLogger on BaseWidget{ //on dediğimiz için burası artık sadece basewidget ve altında kullanılır. mesela sadece belli bir sayfada çalışmasını istediğimiz bir özellik var, o zaman on ile kullanırız.
  void logInit()=> print("Widget başlatıldı");
}



//extension kullanımı: hazır bir yapının içine sonradan gömmek istediğimiz özellikleri nasıl ekleriz 

//hazır extension aşağıda
extension StringValidator on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  //extension geliştirme. burası eklediğimiz kısım.
  String toCapitalize(){
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

// kullanımı
void main() {
  String email = "betul@gmail.com";
  if(email.isValidEmail){
    print("Geçerli email");
  }else{
    print("Geçersiz email");
  }
}


//tip belirsizliğini ortadan kaldırma
abstract class Identifiable{
  String get id;
}

//dynamic olarak kullandığımız verileri herhangi bir tip belirtmeden kullanabiiliriz. generic ile tip belirsizliğini ortadan kaldırabiliriz.
//T tipi mutlaka identifiable arayüzünü uygulamak ZORUNDADIR
//imza ile biz yukarıda veri tipini de almış olduk string diye.  biz imza olarak aldığımız verileri komple almak zorundayız yani hem tipi hem kendisi olarak.

class GenericCache<T extends Identifiable>{
  final Map<String,T> _storage = {};

  void save (T item){
    _storage[item.id]=item;
    print ("ID: ${item.id} önbelleğe alındı");
  }

  //gelen id string ise yaz içine yoksa yazdırma dedik. tip güvenliği sağladık. 
  T? getById(String id) => _storage[id];
}
*/


import 'dart:async';
//dartta asenkron loop örneği
void main(){
  //sıralama 1-5-2-4-3
  //future bir sözleşme olarak çalıştırır. örneğin bir veri var ama tipi yok. future bunu istenilen tipte çalıştırmaya yarar. bir işlemi fonksiyonu future ile başlattığımızda o işlemi takip edebilir alınna hataları yakalayabilir ve o işlemi veri tipinden bağımsız çalıştırabiliriz. loglamayı da otomatik yapar ve takip edilebilen bir yapı oluşturulmuş olur. 
  print("1. senkron başladı");

  scheduleMicrotask((){
    print("2. task oluştu (vip kuyruk)");
  });
  Future((){
    print("3.standart event kuyruğu");
  });
  Future.microtask((){ //burada future yazmamızın sebebi işlem sonucunu bize ver, devam mı ediyor tamamlandı mı hata mı verdi bunu bize göster diyoruz.
    print("4. future olan microtask çalıştı");
  });

  print("5. senkron kod tamamlandı.");
  
}