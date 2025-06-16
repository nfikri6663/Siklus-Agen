function choose_action(_state_key, _valid_actions) {
    // Jika karena suatu alasan tidak ada pilihan, jangan lakukan apa-apa
    if (array_length(_valid_actions) == 0) {
        return -1;
    }
    // Langkah 1: Cek "otak" (Q-Table). Apakah kita pernah di situasi ini sebelumnya?
    var _q_values = q_table[? _state_key];
    // Jika belum pernah (ini state baru), buat "catatan" baru di otak untuk situasi ini
    if (is_undefined(_q_values)) {
        _q_values = array_create(ACTIONS._count, 0);
        q_table[? _state_key] = _q_values;
    }
    
    // Langkah 2: Lempar dadu untuk Epsilon-Greedy
    if (random(1) < epsilon) {
        // EKSPLORASI
        // Pilih aksi acak DARI DAFTAR YANG VALID.
        var _random_index = irandom(array_length(_valid_actions) - 1);
        return _valid_actions[_random_index];
    } else {
        // EKSPLOITASI
        // Cari aksi terbaik dari daftar yang valid berdasarkan Q-Table
        var _best_action = _valid_actions[0];
        var _max_q = _q_values[_best_action];
        // Loop melalui semua pilihan yang valid
        for (var i = 1; i < array_length(_valid_actions); i++) {
            var _current_action = _valid_actions[i];
            // Jika nilai aksi saat ini lebih tinggi dari nilai terbaik sejauh ini
            if (_q_values[_current_action] > _max_q) {
                // ...maka jadikan ini sebagai aksi terbaik yang baru
                _max_q = _q_values[_current_action];
                _best_action = _current_action;
            }
        }
        return _best_action;
    }
}