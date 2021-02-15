#include "FirebaseESP8266.h" // Memasukan Library Firebase 
#include <ESP8266WiFi.h> // Memasukan Library Wifi
#include <Servo.h> // Memasukan Library Servo
 
const char* ssid = "zzz"; // Inisialisasi nama wifi/SSID
const char* password = "qwertyuiop"; // Inisialisasi password wifi

String host = "iotflutter.firebaseio.com/"; // Host Project ID Firebase
String apikey = "22dM9TgS7bS8dlxyBOJACtnFElHOv26HiZAG5JrK"; // Secret Key Firebase


Servo servo; // Inisialisi Modul Servo
FirebaseData fbdo; // Inisialisasi Firebase data object
 
void setup() { // Inisialisi ketika booting up
  Serial.begin(9600); // Menjalankan serial monitoring 
  pinMode(LED_BUILTIN, OUTPUT); // Mengaktifkan Modul LED built in
  servo.attach(2); // Mengaktifkan Modul Servo pada pin D4/2
  konekWifi(); // Memanggil Fungsi KoneksiWifi
  Firebase.begin(host, apikey); // Authorisasi dengan firebase
}
 
void konekWifi() { // Fungsi Untuk Koneksi Ke wifi
  WiFi.begin(ssid, password); // Menyambungkan Wifi
  while (WiFi.status() != WL_CONNECTED) { // Jika status wifi belum terkoneksi
    delay(500); // tunggu 500ms
    Serial.print("."); // Menampilkan output pada monitoring
  }
  Serial.println("Sukses terkoneksi wifi!");
  Serial.println("IP Address:");
  Serial.println(WiFi.localIP()); // Menampilkan output local IP
}
 
void loop() { // Memerintah Mikrokontroller selama mesin hidup

  if(Firebase.getString(fbdo, "LED")){ // Mengambil Data Key tertentu
    if (fbdo.dataType() == "string") { // Mengecek tipe data Key
      
      if(fbdo.stringData() == "ON"){ // Mengambil dan membandingkan value dari key
        digitalWrite(LED_BUILTIN, LOW); // Mematikan LED Built In
      }
      
      if(fbdo.stringData() == "OFF"){
        digitalWrite(LED_BUILTIN, HIGH); // Menyalakan LED Built In
      }
    }
  }

  if(Firebase.getInt(fbdo, "SERVO")){
    servo.write(fbdo.intData()); // Mengatur posisi servo dengan data yang ada pada firebase
  }

  delay(100); // menunggu setiap 100ms
  
}
