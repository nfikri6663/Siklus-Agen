function generate_all_states() {
    // Inisialisasi array global untuk menyimpan semua string state
    all_possible_states = [];

    // Definisi semua kategori
    var age_cats    = ["bayi", "anak", "remaja", "dewasa", "tua"];
    var health_cats = ["rendah", "sedang", "tinggi"];
    var hungry_cats = ["kenyang", "lapar", "SangatLapar"];
    var energy_cats = ["rendah", "sedang", "tinggi"];
    var money_cats  = ["miskin", "cukup", "kaya"];
    var time_cats   = ["pagi", "siang", "malam"];

    // Loop bersarang untuk membuat setiap kombinasi
    for (var i = 0; i < array_length(age_cats); i++) {
    for (var j = 0; j < array_length(health_cats); j++) {
    for (var k = 0; k < array_length(hungry_cats); k++) {
    for (var l = 0; l < array_length(energy_cats); l++) {
    for (var m = 0; m < array_length(money_cats); m++) {
    for (var n = 0; n < array_length(time_cats); n++) {
        
        // Menggabungkan string menjadi satu kunci state menggunakan string formatting
        var _key = $"{age_cats[i]}_{health_cats[j]}_{hungry_cats[k]}_{energy_cats[l]}_{money_cats[m]}_{time_cats[n]}";
        
        // Menambahkan kunci ke array global
        array_push(all_possible_states, _key);
        
    }}}}}}
    
    _training_cycles = array_length(all_possible_states);
    game_phase = "auto_learning"
    step_num = 0
    step_training = [0]
}

function konversi_state_ke_struct(state_string) {
    // Memecah string menjadi komponen-komponennya dalam sebuah array
    var parts = string_split(state_string, "_");
    
    // Validasi: pastikan string memiliki format yang benar
    if (array_length(parts) != 6) {
        show_debug_message("ERROR: Format state_string tidak valid -> " + state_string);
        return undefined; // Kembalikan 'undefined' jika format salah
    }
    
    var age_str    = parts[0];
    var health_str = parts[1];
    var hungry_str = parts[2];
    var energy_str = parts[3];
    var money_str  = parts[4];
    var time_str   = parts[5];

    // Membuat struct kosong untuk menampung hasil numerik
    var nilai_numerik = {};

    // 1. Konversi Age (Usia)
    if (age_str == "bayi") { nilai_numerik.age = 5; }
    else if (age_str == "anak") { nilai_numerik.age = 12; }
    else if (age_str == "remaja") { nilai_numerik.age = 22; }
    else if (age_str == "dewasa") { nilai_numerik.age = 40; }
    else if (age_str == "tua") { nilai_numerik.age = 65; }

    // 2. Konversi Health (Kesehatan)
    if (health_str == "rendah") { nilai_numerik.health = 20; }
    else if (health_str == "sedang") { nilai_numerik.health = 50; }
    else if (health_str == "tinggi") { nilai_numerik.health = 85; }

    // 3. Konversi Hungry (Rasa Lapar)
    if (hungry_str == "kenyang") { nilai_numerik.hungry = 30; }
    else if (hungry_str == "lapar") { nilai_numerik.hungry = 60; }
    else if (hungry_str == "SangatLapar") { nilai_numerik.hungry = 90; }
        
    // 4. Konversi Energy (Energi)
    if (energy_str == "rendah") { nilai_numerik.energy = 20; }
    else if (energy_str == "sedang") { nilai_numerik.energy = 50; }
    else if (energy_str == "tinggi") { nilai_numerik.energy = 85; }

    // 5. Konversi Money (Uang)
    if (money_str == "miskin") { nilai_numerik.money = 50; }
    else if (money_str == "cukup") { nilai_numerik.money = 200; }
    else if (money_str == "kaya") { nilai_numerik.money = 500; }

    // 6. Konversi Time (Waktu)
    if (time_str == "pagi") { nilai_numerik.time_of_day_cycle = 0; }
    else if (time_str == "siang") { nilai_numerik.time_of_day_cycle = 1; }
    else if (time_str == "malam") { nilai_numerik.time_of_day_cycle = 2; }
    return nilai_numerik;
}

function run_ai_cycle(training = true) {
    if training{
        current_state_key = all_possible_states[step_training[step_num]];
        var numerik = konversi_state_ke_struct(current_state_key);
        age = numerik.age
        health = numerik.health
        hungry = numerik.hungry
        energy = numerik.energy
        money = numerik.money
        time_of_day = time_of_day_map[numerik.time_of_day_cycle]
        if array_length(current_day_log) > 2 current_day_log = []
    }else current_state_key = get_state_string();
    
    available_actions_list = get_valid_actions();
    // 2. Dapatkan rekomendasi lengkap (sekarang sudah termasuk Q-Value)
    var _recommendation = get_recommendation_details(current_state_key, available_actions_list);
    // 3. Pilih aksi
    var _chosen_action = choose_action(current_state_key, available_actions_list);
    // --- Turunkan Epsilon (selalu dilakukan setiap siklus) ---
    if (epsilon > epsilon_min) && !training{
        epsilon *= epsilon_decay;
    }
    // =====================================================================
    // Proses dan pencatatan log HANYA dilakukan jika ada aksi yang valid
    if (_chosen_action != -1) {
        // Ambil Q-Value untuk aksi yang DIPILIH oleh agen
        var _q_values_for_state = q_table[? current_state_key];
        var _q_value_of_action_taken = 0;
        if (!is_undefined(_q_values_for_state)) {
            _q_value_of_action_taken = _q_values_for_state[_chosen_action];
        }
        // Lakukan aksi dan simpan hasilnya
        last_action_result = perform_action_and_get_reward(_chosen_action, false);
        last_reward = last_action_result.reward;
        current_action_name = action_names[_chosen_action];
        // --- DAPATKAN DETAIL PEMBELAJARAN ---
        var _next_state_key = get_state_string();
        // Panggil update_q_table dan simpan hasilnya
        var _learning_details = update_q_table(current_state_key, _chosen_action, last_reward, _next_state_key);
        // Buat dan simpan log UNTUK AKSI INI
        var _log_entry = {
            action_result: last_action_result,
            state_key_at_the_time: current_state_key,
            time_of_day: time_of_day,
            action_name: current_action_name,
            action_result: last_action_result,
            learning_details: _learning_details, // Simpan seluruh detailnya
            recommendation: _recommendation
        };
        array_push(current_day_log, _log_entry);
    }
    if training step_training[step_num]++
}