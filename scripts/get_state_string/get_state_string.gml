// function get_state_string()
function get_state_string() {
    // Langkah 1: Ubah setiap angka menjadi kategori teks
    s_health_cat = (health > 70) ? "tinggi" : ((health > 30) ? "sedang" : "rendah");
    s_hungry_cat = (hungry > 70) ? "SangatLapar" : ((hungry > 50) ? "lapar" : "kenyang");
    s_energy_cat = (energy > 70) ? "tinggi" : ((energy > 30) ? "sedang" : "rendah");
    s_money_cat = (money > 300) ? "kaya" : ((money > 100) ? "cukup" : "miskin");
    if (age <= 5) s_age_cat = "bayi";
    else if (age <= 12) s_age_cat = "anak";
    else if (age <= 22) s_age_cat = "remaja";
    else if (age <= 60) s_age_cat = "dewasa";
    else s_age_cat = "tua";
    
    // Langkah 2: Gabungkan semua kategori menjadi satu string unik
    // String ini akan menjadi "label" atau "key" untuk Q-Table
    return $"{s_age_cat}_{s_health_cat}_{s_hungry_cat}_{s_energy_cat}_{s_money_cat}_{time_of_day}";
}