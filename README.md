# Activity Counter - Flutter (UTS Pemrograman Mobile)

Aplikasi Activity Counter dibuat menggunakan Flutter dan Dart dengan arsitektur MVVM, Repository, dan Data sesuai ketentuan project UTS.

## Fitur aplikasi

- Home: menampilkan daftar aktivitas, nama aktivitas, nilai counter, dan total pencapaian.
- Tambah/Edit Aktivitas: input nama aktivitas dengan validasi agar tidak kosong.
- Detail Aktivitas: tambah counter, kurangi counter (tidak dapat kurang dari nol), reset dengan konfirmasi, dan hapus dengan konfirmasi.
- SnackBar ditampilkan ketika aktivitas ditambahkan/diperbarui/dihapus dan ketika nilai counter berubah atau tidak dapat dikurangi lagi.
- Data disimpan sementara menggunakan `List` selama aplikasi berjalan (tidak menggunakan database/API).
- Antarmuka menggunakan tema Dark Professional.

## Struktur dan tanggung jawab MVVM

```text
lib/
├── main.dart
├── app_theme.dart
├── models/
│   └── activity_model.dart
├── data/
│   └── activity_data.dart
├── repositories/
│   └── activity_repository.dart
├── viewmodels/
│   └── activity_viewmodel.dart
└── views/
    ├── home_view.dart
    ├── activity_form_view.dart
    └── activity_detail_view.dart
```

- **Model** (`activity_model.dart`): mendefinisikan data aktivitas berupa ID, nama, dan nilai counter.
- **Data** (`activity_data.dart`): menyediakan dan menyimpan daftar aktivitas sementara menggunakan `List`.
- **Repository** (`activity_repository.dart`): menangani pengambilan, penambahan, pengubahan, penghapusan, dan pembaruan counter pada data.
- **ViewModel** (`activity_viewmodel.dart`): mengelola logika aplikasi dan state menggunakan `ChangeNotifier`, lalu memberi tahu View melalui `notifyListeners()`.
- **View** (`views/`): menampilkan tiga halaman dan meneruskan interaksi pengguna ke ViewModel.

## Alur perubahan data

Pengguna berinteraksi dengan halaman View. View memanggil fungsi pada ViewModel. ViewModel menjalankan operasi melalui Repository, kemudian Repository mengubah data pada List di Data. Setelah operasi selesai, ViewModel memanggil `notifyListeners()` sehingga widget yang mendengarkan perubahan state membangun ulang tampilan dengan data terbaru.
