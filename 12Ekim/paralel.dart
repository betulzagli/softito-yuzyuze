
/*
Future<void> fetchDashboardData () async {
  try{

    //hepsine eş zamanlı istek attık. bunlardan gelen sonucu bekle dedik. mesela dasboard doldurucaz ve tüm verileri aynı anda çekmemiz gerekiyor o zaman kullanırız. eğer veriler aynı anda gelemiyorsa mesela üçünden biri daha sonra gelecekse oraya bir skeleton koyarız ve dolmasını beklerken o gözükür loading animasyonu gibi
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ],eagerError: true);
     //eagerError: true demek, eğer birinde hata olursa diğerlerini beklemeden hatayı fırlat diyoruz. false olursa diğerlerini bekler ve hepsini çalıştırır.


    print("tüm veriler geldi $result");
  }catch(e){
    print("isteklerden biri başarısız oldu $e");
  }

}
*/

//future: tek bir kere veri çekeceğimiz zaman kullanıyoruz ya hata ya da değer dönüp bitirir.
//stream: boru hattı şeklinde çalışır (pipe) , zaman içinde 1 10 100 sn gibi ya da sonsuz sayıda veri akışı sağlanabilir.
//borsa fiyatları çekerken, gps konum güncellerken, firebase canlı dinleme yapıldığında yani mesela login olduk login olan kişi online mı offline mı onu dinlemek için ---> stream kullanılır.

import 'dart:async';

void main(){
  //controller oluşturma
  final controller=StreamController<int>(); //stream olarka çalışacağını ve int değer alacağını belirttik.

  //dinleyici bağlama
  final subscription = controller.stream.listen(
    (data) => print("yeni veri : $data"), //gelen datayı ekrana yazsın
    onError: (err) => print("hata oluştu: $err"), //hata alınırsa
    onDone: ()=>print("yayın tamamlandı"), //bttiğinde, bitene kadar çalışmaz. milyon tane de gelse milyonuncu bitince çalışır. devamlı akış vardır.
  );


  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);
  

  //burası hata verdi çünkü bir tane dinleyici oluşturmuştuk. o yüzden hata verdi. aynı fonksiyon içinde hem tekil hem çoğul yazarsak hata verir. broadcast çoklu subs tekli oldu. duurma göre tekli veya çoklu dinleme yapılır. eğer ziyaretçi izlenecekse sadece tek veri olduğu için tekil, eğer ziyaretçimile birlikte id de tutulacaksa çoklu dinleme yapılır.
  final broadcastStream=controller.stream.asBroadcastStream();
  broadcastStream.listen((d)=>print("ui ekranı: $d"));
  broadcastStream.listen((d)=>print("analitik servis ekranı: $d"));

  controller.close(); //memory koruması

  //yukarıdaki streame örnek: altın fiyatlarını gösteren site. sitede altın fiyatı geldi ekrana bastı, tekrar geldi bastı. hata olunca hatayı verir.







}