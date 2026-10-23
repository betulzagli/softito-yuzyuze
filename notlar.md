# Sözleşmeler , SOLID Prensipleri VE OOP Mimarisi

## 1.1 Interface (arayüz/sözleşme)
**Sözlük Anlamı:** İki bağımsız sistemin veya sınıfın birbiri ile nasıl konuşacağını belirleyen, içi boş metot imzalarından oluşan kurallar bütünü. Sınıflar da birbirlerinin iç detayını değil aradaki interfacei bilir.
**Neden Kullanılır:** Bir sınıfa göbekten bağımlı kalmamak (örneğin gerçek şarj istasyonu cihazı olmadan sahte/mock şarj servisiyle testi çalıştırabilmek)
**Mini Kod Örneği**
```dart
abstract interface class StationContreact{
    Future<void> startCharging(String socketId);
    Stream<double> watchLivePower();
}
```
---

## 1.2 Implements, Extends, With

### 1.2.1 implements (arayüz sözleşmesi)
**Sözlük anlamı:** Bir sınıfın, bir şablonun belirlediği kuralları kabul edip **içini sıfırdan kendisinin doldurması** zorunluluğudur.
**Neden Kullanılır:** Farklı sınıflara ortak bir standart/sözleşme dayatmak, çoklu arayüz desteği sağlamak ve koda bağımlılıkları azaltmak için.

### 1.2.2 extends (Kalıtım/Miras)
**Sözlük Anlamı** Bir sınıfın, başka bir sınıfın özelliklerini ve metotlarını doğrudan devralması.
**Neden Kullanılır:** Kod tekrarını önlemek(DRY), mantıksal bir sınıf hiyerarşisi oluşturmak için.

### 1.2.3 with (mixin/yetenek aşılama)
**Sözlük Anlamı:** Sınıf hiyerarşisini bozmadan bağımsız bir sınıfa hazır kod blokları(metotlar ve değişkenler) enjekte etme mekanizmasıdır. 
**Neden Kullanılır:** Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım kimliğini önlemek ve modülerliği arttırmak için.

## 1.3 SOLID Prensipleri (Mobil & Dart Odaklı)

### 1. S - Single Responsibility Principle (Tek Sorumluluk Prensibi)
**Kural:** Bir sınıfın ya da dosyanın değişmesi için **yalnızca 1 sebebi** olmalıdır.

### 2. O - Open/Closed Principle (Açık/Kapalı Prensibi)
**Kural:** Yazılım varlıkları(sınıflar, modüller) **genişletilmeye AÇIK, ancak değiştirilmeye KAPALI** olmalıdır.

### 3. L - Liskov Substitution Principle (Liskov Yerine Koyma Prensibi)
**Kural:** Bir üst sınıfın yerine onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalı ve hata fırlatmamalıdır.

### 4. I - Interface Segregation Principle (Arayüz Soyutlama Prensibi)
**Kural:** İstemciler (sınıflar), kullanmadıkları metotları içermeye zorlanmamalıdır. Şişman(fat) interfaceler yerine küçük, amaca yönelik arayüzler kurulmalıdır.

### 5. D - Dependency Inversion Principle (Bağımlılık Tersine Çevirme Prensibi)
**Kural:** Yüksek seviyeli modüller (UI , iş mantığı), düşük seviyeli modüllere (veritabanı, API, HTTP İstemcisi) doğrudan bağımlı olmamalıdır. Bunun yerine ikisi de soyut (abstract) arayüzlere bağımlı olmalıdır.

--- 

## 1.4 Coupling (Bağlaşıklık) & Cohesion (Uyum)
***Tigthly Coupled(sıkı bağımlı):*** Sınıfların birbirinin her detayını bilmesi. Birinde yapılan bir harflik değişiklik diğer beş dosyayı bozuyorsa sistem sıkı bağımlıdır.
***loosely Coupled(Gevşek Bağımlı):*** Sınıfların sadece interface üzerinden konuşması. Biri değiştiğinde diğeri etkilenmez.
***high Cohesion(Yüksek Uyum):*** Bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması. 

---
## STREAM TEMELLERİ, CUBIT & ENTERPRICE BLOC

### 2.1 Stream Nedir? (BloC'un Kalbindeki Motor)
**Sözlük Anlamı:** Zaman içinde parça parça gelen, akıp giden asenkron veri dizisi. Future tek bardak su. stream ise şebeke su verisi. musluğu kapatana kadar su akmaya devam eder. bloc içinde streamcontroller var. eventler borunun bir ucundan girer bloc bunları işler ve borunun öbür tarafından state(durum) olarak dışarı çıkar.
**Bloc Sırrı:**BloC kütüphanesi sihirli bir şey yapmaz. BloC'un içinde gizli bir `StreamController` vardır. Eventler borunun bir ucundan girer(`sink.add`), BloC onları işler ve diğer ucundan ekrana state akıtır(`stream.listen`).

### 2.2 BloC'un 3 Temel Elemanı: 'Event', 'State' ve 'Emitter'
**Event(Olay):** Kullanıcının veya sistemin BloC'a attığı emir fişi.
*Mini Sözdizimi:* `class StartChargingRequested extends ChargingEvent{final String socketId;}`

**State(durum):** Ekranın milisaniyedeki dondurulmuş fotoğrafı(snapshot).
*Mini Sözdizimi:* `class ChargingActiveState extends ChargingState{final double kwh}`

**Emitter** BloC'un ürettiği yeni state'i ekrana fırlattığı megafon borusu.
*Kural:* Senkron çalışır; ` emit(NewState())` dendiği anda UI'daki builder'lar tetiklenir.

* Kullanıcı ekrandayken asenkron işlem başlar (await api.fetchSockets()). Kullanıcı cevap gelmeden geri tuşuna basıp sayfayı kapatır. BLoC/Cubit yok edildiği (closed) için hemen ardından gelen emit() satırı:

💥 StateError: Cannot emit new states after calling close

hatasını fırlatır ve uygulama çöker!
Çözüm: Asenkron await satırından sonraki her emit mutlaka şu şekilde korunmalıdır:
final data = await repository.getData();
if (!isClosed) {
  emit(DataLoaded(data));
}

----
### 3.1 `Side Effect` (Yan Etkiler) Neden `BlockBuilder`İçine Yazılamaz?
* BlockBuilder tek görevi widget döndürmektir.
* Flutter motoru ekranı saniyede 60 kez çizebilir (rebuild). Eğer siz BlockBuilder içine ScaffoldMessenger.showSnackBar veya Navigatore.push yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açılduğında kullanıcıya üst üste 10 defa SnackBar patlar veya 10 kez yeni sayfa açılır
* Kural: Yan etkiler sadece BlockListener içine yazılır; çünkü 'listener' sayfa rebuild olduğunda değil; yalnızca State değiştiğinde 1 kez tetiklenir.

### 3.2 BlocSelector (mikro performans & pil tasarrufu)
* Kavram: Statein içindeki onlarca alandan sadece 1 tanesini süzüp izlemek.
* örnek: mesela telefon şarj oluyor, ekranda bir sürü şey var. pil dolarken yüzdesini artırmak ve doluluğunu artırmak için ekranı tekrar tekrar basmayız sadece pili izleriz.

-----
## 4. Eşitlik, Değişmezlik & BlocObserver
### 4.1 Referential Equality vs Value Equality
* Dartta varsayılan (referans eşitliği): İki nesnenin bellekteki ram adresi aynı mı?
    SOket('A') == Soket('A') --> false çıkar.
    içerikleri ayı olsa da ramde farklı adreslerdedirler.
* Değer Eşitliği (Value Equality): Nesnelerin içindeki veriler aynı mı?
    Equatable paketi tam olarak bunu çözer: nesneleri ram adresine göre değil, props listesindeki alanların değerine göre karşılaştırır.

### 4.2 props Listesi Yazılmazsa ne olur?
* Bloc ekran kartını yormamak için şu denetimi yapar: if (yeniState == eskiState) ekraniCizme();
* eğer siz StationLoaded stateine yeni bir filterType alanı eklerseniz ama props içine yazmayı unutursanı; Bloc iki statei eşit zanneder ve ekranı güncellemez , arayüz donuk kalır.

### 4.3 Immutability (Değişmezlik) ve copyWith Metodu
* Kural: State sınıflarının tüm alanları final olmalıdır. değişmez 
* copywith mantığı : eski nesnenin 5 alanını koruyup, sadece değişen 1 alanını güncelleyerek taze bir nesne üretme yöntemidir.
    final guncel = state.copyWith(isCharhing:true);

### 4.4 BlockObserver (tüm uygulamayı röntgenleme)
* Kavram: Uygulamadaki tüm Bloc ve Cubitlerin arkasında çalışan merkezi bir kara kutu / telemetri kaydedici
* Ne işe yarar: Hangi ekranda hangi event fırlatıldı, State nereden nereye geçti(onTransition) ve nereed hata fırlatıldı (onError) tek merkezden konsola loglanır. Kurumsal projelerde analitik ve çökme takibi için zorunludur.

## 5. Clean Architecture Katmanları & Sorumluluk Duvarlaır
### 5.1 Entity vs Model/DTO
* Entity (varlık) : Saf iş nesnesidir. Bir şarj soketinin gerçek hayattaki özelliklerini (id,kw,durum) tutar. fromJson veya toJson içermez.
* Model/DTO (data transfer object) : Apiden gelen ham Json verisini karşılayan taşıyıcıdır. Entityden türer; fromJson ve toJson metotlarını barındırır.
* Neden entity içine fromJson yazmıyoruz: yarın backend içine json yerine xml veya Protobuf formatına geçerse; domain katmanındaki iş kurallarımız ve Uı sayfalarımız zerre kadar etkilenmesin sadece DATA katmanındaki Model etkilensin diye.

### 5.2 UseCase (kullanım senaryosu)
* kavram: kullanıcının veya sistemin gerçekleştirebileceği tek ve atomil bir iş kuralı
* örnekler : StartChargingSessionUseCase, GetStationSocketUseCase,RefundWalletBalanceUseCase.
* kural : her UseCase sınıfının içinde sadece tek bir call() veya execute() fonksiyonu bulunur.

### 5.3 Repository Contract vs Repository Implementation
* Contract (Domain Katmanında): Sadece sözleşmedir (abstract interface class StationRepository). Verinin nereden geleceğini bilmez.
* Implementation (Data Katmanında): Sözleşmeyi uygulayan somut sınıftır (class StationRepositoryImpl implements StationRepository). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.

## 6. Bağımlılık Yönetimi : Dependency Injection & get_it

### 6.1 Neden new Dio() Yazmak Yasaktır?
Eğer 5 ayrı sayfada final dio = Dio(); derseniz:
* Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
* Base URL veya Timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
* Test yazarken sahte (mock) veri enjekte edemezsiniz.

### 6.2 GetIt Kayıt Tipleri : Singleton vs LazySingleton vs Factory
* Singleton: Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.
* LazySingleton: Uygulama açıldığında üretmez! Ne zaman ilk kez birisi sl<Dio>() derse o an üretir ve sonrasında hep aynı nesneyi verir. (Bellek ve açılış hızı dostudur).
* Factory: Her çağrıldığında yepyeni, sıfır bir kopya üretir.

### 6.3 Bloclar Sayfaya Kaydedilirken Neden Singleton yerine Factory Kullanılır?
Çünkü her sayfa kendi yalıtkan dünyasına (sandbox) sahip olmalıdır. Eğer Singleton yaparsak, A sayfasında açılan Bloc'un internal state'i (örneğin bir counter değeri), B sayfasındaki CounterBloc'a sızar ve birbirlerini bozarlar. 

---
## 7. Kurumsal Ağ Mimarisi: Dio , Interceptor & Http Status Kodları
* Sözlük anlamı: ağ isteği telefondan çıkıp internete gitmeden önce veya sunucudan cevap gelip koda düşmeden önce araya girip paketi inceleyen/değiştiren güvenlik noktası.

### 7.1 Bearer Token & Payload
* Bearer Token: "Bu anahtarı taşıyan kişi giriş yapmaya yetkilidir" anlamına gelen şifrelenmiş kimlik kartı metni (Authorization: Bearer eyJhbGci...).
* Payload: Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesi (Body).

### 7.2 Http Durum Kodları Sözlüğü
200 OK: İstek başarılı, veri gövdede.
201 Created: Yeni kayıt (örneğin yeni şarj oturumu) başarıyla oluşturuldu.
400 Bad Request: İstemci hatası; eksik veya hatalı parametre gönderdin.
401 Unauthorized: Token yok veya süresi dolmuş; hemen Login'e yönlendir!
403 Forbidden: Giriş yaptın ama bu veriyi görmeye yetkin yok (Admin değilsin).
404 Not Found: Aradığın soket veya istasyon sunucuda bulunamadı.
500 Internal Server Error: Backend sunucusu patladı; istemcilik bir hata yok.

-----

## 8. Veri Dayanıklılığı : Cache-First & Savunmacı Kodlama
### 8.1 Cache First Mantığı
* Mantık: Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi 0.01 milisaniyede ekrana bas. Arka planda sunucudan taze veriyi çek; gelince ekranı ve diski sessizce güncelle.

### 8.2 Savunmacı Kodlama (Defensive Coding)
* Mantık: Sunucudan gelen veriye asla %100 güvenmeme prensibi.

