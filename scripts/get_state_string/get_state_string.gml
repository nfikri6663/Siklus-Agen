// function get_state_string()
function get_state_string() {
    // Langkah 1: Ubah setiap angka menjadi kategori teks
    var _health_cat = (health > 70) ? "tinggi" : ((health > 30) ? "sedang" : "rendah");
    var _hungry_cat = (hungry > 70) ? "SangatLapar" : ((hungry > 50) ? "lapar" : "kenyang");
    var _energy_cat = (energy > 70) ? "tinggi" : ((energy > 30) ? "sedang" : "rendah");
    var _money_cat = (money > 300) ? "kaya" : ((money > 100) ? "cukup" : "miskin");
    var _age_cat = "";
    if (age <= 5) _age_cat = "bayi";
    else if (age <= 12) _age_cat = "anak";
    else if (age <= 22) _age_cat = "remaja";
    else if (age <= 60) _age_cat = "dewasa";
    else _age_cat = "tua";
        
    // Langkah 2: Gabungkan semua kategori menjadi satu string unik
    // String ini akan menjadi "label" atau "key" untuk Q-Table
    return $"{_age_cat}_{_health_cat}_{_hungry_cat}_{_energy_cat}_{_money_cat}_{time_of_day}";
}