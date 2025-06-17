//// Periksa di fase mana kita sekarang
if (game_phase == "auto_learning") {
    run_ai_cycle()
    if step_training[step_num] > (_training_cycles-1){
        if step_num == array_length(step_training)-1{
            alarm[1] = 1
        }
        if step_num < array_length(step_training)-1 step_num ++
    }
    alarm[0] = 1;
    exit
}

// --- EVENT ACAK (Jatuh Sakit) ---
var _sakit_chance = 2;
if (age > 60) { _sakit_chance = 10; }
if (irandom(99) < _sakit_chance && !is_sick) {
    health -= age < 18 ? 20 : (age > 32 ? 30 : 45);
    stress += age < 18 ? 5 : (age > 32 ? 10 : 12);
    energy -= age < 18 ? 5 : (age > 32 ? 15 : 20);
    hungry -= 5
}

if health < 65 is_sick = true;
if health >= 90 is_sick = irandom(1);
if health == 100 is_sick = false;

run_ai_cycle(false)

// --- Sistem Waktu & Penuaan (selalu dilakukan setiap siklus) ---
time_of_day_cycle++;
if (time_of_day_cycle >= array_length(time_of_day_map)) {
    time_of_day_cycle = 0;
    if game_phase != "auto_learning" is_simulating = false;
}
time_of_day = time_of_day_map[time_of_day_cycle];
if (is_simulating) alarm[0] = 1;