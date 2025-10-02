randomize()
time_of_day_map = ["pagi", "siang", "malam"]
reset_agent_stats = function() {
    health = irandom_range(80,100)
    hungry = irandom(10)
    money = irandom_range(100,300)
    iq = 0
    social = 10
    stress = irandom_range(10,35)
    energy = irandom_range(70,100)
    age = 0
    is_married = false
    is_sick = false
    time_of_day_cycle = 0
    time_of_day = time_of_day_map[time_of_day_cycle]
    days_passed = 0
}

initialize_ai_system = function() {
    alpha = 0.1
    gamma = 0.9
    epsilon = 1
    epsilon_decay = 0.9999
    epsilon_min = 0.001
    q_table = ds_map_create()
}

current_state_key = "Inisialisasi..."
current_action_name = "Menunggu..."
last_reward = 0

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

action_names = array_create(ACTIONS._count)
action_names[ACTIONS.Tidur] = "Tidur"
action_names[ACTIONS.Makan] = "Makan"
action_names[ACTIONS.Bermain] = "Bermain"
action_names[ACTIONS.Menangis] = "Menangis"
action_names[ACTIONS.Belajar] = "Belajar"
action_names[ACTIONS.Istirahat] = "Istirahat"
action_names[ACTIONS.Bekerja] = "Bekerja"
action_names[ACTIONS.Bersosialisasi] = "Bersosialisasi"
action_names[ACTIONS.Olahraga] = "Olahraga"
action_names[ACTIONS.Liburan] = "Liburan"
action_names[ACTIONS.Menikah] = "Menikah"
action_names[ACTIONS.Punya_Anak] = "Punya Anak"
action_names[ACTIONS.Rawat_Jalan] = "Rawat Jalan"
action_names[ACTIONS.Sakit] = "Sakit"

s_health_cat = ""
s_hungry_cat = ""
s_energy_cat = ""
s_money_cat  = ""
s_age_cat    = ""

is_simulating = true        //Jika True maka sedang melakukan simulasi
current_day_log = []        //Untuk menyimpan log aktifitas harian Agen
last_action_result = 0      //Aksi terakhir yang dilakukan oleh agen
available_actions_list = [] //List aksi yang dapat dilakukan agen saat ini

reset_agent_stats()
initialize_ai_system()
generate_all_states()

time_learning = 0