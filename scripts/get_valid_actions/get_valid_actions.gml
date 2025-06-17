function get_valid_actions(_time_to_check = time_of_day) {
    // Mulai dengan sebuah daftar kosong
    var _valid_actions = [];
    // Cek setiap aksi berdasarkan aturan dari tabel yang di buat di awal
    // Aksi: Tidur (Malam, atau bayi kapanpun)
    if (_time_to_check == "malam" || age <= 5) {
        array_push(_valid_actions, ACTIONS.Tidur);
    }
    // Aksi: Makan (Semua Usia, kapanpun saat lapar) -> Anggap selalu bisa
    array_push(_valid_actions, ACTIONS.Makan);
    // Aksi: Bermain (Semua Usia, Siang)
    if (_time_to_check == "siang") {
        array_push(_valid_actions, ACTIONS.Bermain);
    }
    // Aksi: Menangis (Khusus bayi 0-5)
    if (age <= 5) {
        array_push(_valid_actions, ACTIONS.Menangis);
    }
    // Aksi: Belajar (Usia 6-22, Siang)
    if (age >= 6 && age <= 22 && _time_to_check == "siang") {
        array_push(_valid_actions, ACTIONS.Belajar);
    }
    // Aksi: Istirahat (Semua Usia, Siang)
    if (_time_to_check == "siang" && age >= 18) {
        array_push(_valid_actions, ACTIONS.Istirahat);
    }
    // Aksi: Bekerja (Usia 13-60, Siang-Malam)
    if (age >= 13 && age <= 60) {
        array_push(_valid_actions, ACTIONS.Bekerja);
    }
    // Aksi: Bersosialisasi (Usia >= 6, Siang-Malam)
    if (age >= 6) {
        array_push(_valid_actions, ACTIONS.Bersosialisasi);
    }
    // Aksi: Olahraga (Usia 13-60, Pagi-Siang)
    if (age >= 13 && age <= 60 && (_time_to_check == "pagi" || _time_to_check == "siang")) {
        array_push(_valid_actions, ACTIONS.Olahraga);
    }
    // Aksi: Liburan (Usia 18-60, Siang)
    if (age >= 18 && age <= 60 && _time_to_check == "siang") {
        array_push(_valid_actions, ACTIONS.Liburan);
    }
    // Aksi: Menikah (Usia 25-60, Siang)
    if (age >= 25 && age <= 60 && _time_to_check == "siang") {
        // Tambahkan cek lain jika perlu, misal: !is_married
        array_push(_valid_actions, ACTIONS.Menikah);
    }
    // Aksi: Punya Anak (Usia 32-60, Kapanpun)
    if (age >= 32 && age <= 60) {
        // Tambahkan cek lain jika perlu, misal: is_married
        array_push(_valid_actions, ACTIONS.Punya_Anak);
    }
    // Aksi: Rawat Jalan (Untuk yang sakit, Siang)
    if (is_sick && _time_to_check == "siang") {
        array_push(_valid_actions, ACTIONS.Rawat_Jalan);
    }
    
    // Jika setelah semua filter tidak ada aksi yang bisa dilakukan,
    // maka harus punya pilihan fallback, misalnya "Tunggu".
    // (Untuk ini maka harus menambahkan ACTIONS.Tunggu ke enum).
    // Untuk sekarang, asumsikan akan selalu ada aksi yang valid.
    
    return _valid_actions;
}