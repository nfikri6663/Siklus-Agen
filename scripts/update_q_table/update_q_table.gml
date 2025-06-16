function update_q_table(_state, _action, _reward, _next_state) {
    // 1. Ambil "Nilai Lalu" (prediksi sebelum belajar) dari Q-Table
    var _old_q_values = q_table[? _state];
    var _old_q_value = 0;
    // Pengecekan keamanan jika ini adalah state yang baru dibuat di siklus yang sama
    if (!is_undefined(_old_q_values)) {
        _old_q_value = _old_q_values[_action];
    }

    // 2. Cari "Nilai Masa Depan Terbaik" dari state berikutnya
    var _max_next_q = 0;
    var _next_q_values = q_table[? _next_state];
    if (!is_undefined(_next_q_values) && array_length(_next_q_values) > 0) {
        _max_next_q = _next_q_values[0];
        for (var i = 1; i < array_length(_next_q_values); i++) {
            if (_next_q_values[i] > _max_next_q) { 
                _max_next_q = _next_q_values[i];
            }
        }
    }
    
    // 3. Hitung "Nilai Target" (nilai yang seharusnya AI pelajari)
    var _target_value = _reward + gamma * _max_next_q;

    // 4. Hitung "Nilai Baru" (prediksi setelah belajar) menggunakan rumus Bellman
    var _new_q_value = _old_q_value + alpha * (_target_value - _old_q_value);
    
    // 5. Pastikan state ini ada di Q-Table sebelum diperbarui (pengaman)
    if (is_undefined(q_table[? _state])) {
        q_table[? _state] = array_create(ACTIONS._count, 0);
    }
    
    // 6. Perbarui Q-Table dengan nilai baru yang lebih pintar
    q_table[? _state][@ _action] = _new_q_value;
    
    // 7. KEMBALIKAN (RETURN) struct berisi semua data penting untuk analisis
    return {
        past_q: _old_q_value,
        present_q: _new_q_value,
        target_q: _target_value
    };
}