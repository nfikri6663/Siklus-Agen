randomize()
atribut = function() {
    // --- Variabel Stats Agen ---
    health = irandom_range(80,100);
    hungry = irandom(10)
    money = irandom_range(35,100);
    iq = 0;
    social = 10;
    stress = irandom_range(10,35);
    energy = irandom_range(70,100);
    age = 0; // Dalam tahun
    is_sick = false;
    time_of_day = "pagi"; // pagi, siang, malam
    
    // --- Variabel Sistem Waktu ---
    time_of_day_cycle = 0; // 0=pagi, 1=siang, 2=malam. Mulai dari siang.
    time_of_day_map = ["pagi", "siang", "malam"]; // Peta untuk nama hari
    time_of_day = time_of_day_map[time_of_day_cycle]; // Set string awal
    days_passed = 0; // Penghitung hari yang telah berlalu
}

atribut()
// --- Parameter Q-Learning ---
alpha = 0.1;   // Learning Rate
gamma = 0.9;   // Discount Factor
epsilon = 1.0; // Epsilon awal, 100% eksplorasi
epsilon_decay = 0.999; // Setiap keputusan, epsilon akan berkurang sedikit
epsilon_min = 0.01;  // Epsilon tidak akan pernah lebih rendah dari ini

// --- Q-Table ---
q_table = ds_map_create();

// --- Daftar Aksi ---
enum ACTIONS {
    Tidur,
    Makan,
    Bermain,
    Menangis,
    Belajar,
    Istirahat,
    Bekerja,
    Bersosialisasi,
    Olahraga,
    Liburan,
    Menikah,
    Punya_Anak,
    Rawat_Jalan,
    Sakit,
    _count // Untuk mengetahui jumlah total aksi
}

// --- PEMETAAN NAMA AKSI (TAMBAHAN) ---
action_names = array_create(ACTIONS._count);
action_names[ACTIONS.Tidur] = "Tidur";
action_names[ACTIONS.Makan] = "Makan";
action_names[ACTIONS.Bermain] = "Bermain";
action_names[ACTIONS.Menangis] = "Menangis";
action_names[ACTIONS.Belajar] = "Belajar";
action_names[ACTIONS.Istirahat] = "Istirahat";
action_names[ACTIONS.Bekerja] = "Bekerja";
action_names[ACTIONS.Bersosialisasi] = "Bersosialisasi";
action_names[ACTIONS.Olahraga] = "Olahraga";
action_names[ACTIONS.Liburan] = "Liburan";
action_names[ACTIONS.Menikah] = "Menikah";
action_names[ACTIONS.Punya_Anak] = "Punya Anak";
action_names[ACTIONS.Rawat_Jalan] = "Rawat Jalan";
action_names[ACTIONS.Sakit] = "Sakit";

// --- VARIABEL UNTUK DRAW EVENT ---
current_state_key = "Inisialisasi...";
current_action_name = "Menunggu...";
last_reward = 0;

// --- Variabel Kontrol Simulasi & Log ---
is_simulating = true; // Simulasi berjalan otomatis pertama kali

current_day_log = []; // Log untuk hari yang sedang berjalan
previous_day_log = []; // Log untuk hari kemarin, yang akan ditampilkan
last_action_result = 0; // Menyimpan detail aksi terakhir
available_actions_list = []; // List aksi yang bisa di lakukan saat ini
// --- Variabel untuk Q-Table Viewer ---
q_viewer_time_index = 0;    // State ke berapa yang sedang dilihat

generate_all_states()
alarm[0] = room_speed; // Agen akan membuat keputusan pertama setelah 1 detik