function perform_action_and_get_reward(_action, _dry_run = false) {
    // REVISI: Biaya hidup diperkecil agar tidak terlalu banyak hukuman.
    var _result = {
        reward: -1, // Biaya dasar setiap aksi (waktu yang terbuang).
        delta_iq: 0, delta_money: 0, delta_health: 0, delta_hungry: 0,
        delta_social: 0, delta_stress: 0, delta_energy: 0
    };

    // --- REVISI: Konsep "Bonus Kebutuhan" ---
    // Kita hitung seberapa mendesak kebutuhan agen SEBELUM melakukan aksi.
    // Bonus ini akan ditambahkan ke aksi yang bisa memenuhi kebutuhan tersebut.
    var _urgency_money = (money < 50) ? 40 : ((money < 100) ? 20 : 0);
    var _urgency_hungry = (hungry > 80) ? 50 : ((hungry > 60) ? 25 : 0);
    var _urgency_energy = (energy < 20) ? 60 : ((energy < 40) ? 30 : 0);
    var _urgency_stress = (stress > 80) ? 50 : ((stress > 60) ? 25 : 0);
    var _urgency_health = (health < 30) ? 70 : 0;
    var _urgency_social = (social < 30) ? 30 : 0;

    // Efektivitas tetap menjadi mekanik yang bagus.
    var effectiveness = 1.0;
    if (stress > 70) effectiveness -= 0.25;
    if (energy < 30) effectiveness -= 0.25;
    effectiveness = max(0.25, effectiveness);

    switch (_action) {
        case ACTIONS.Tidur:
            var energy_gain = (time_of_day == "malam" ? 30 : 15);
            _result.delta_energy += energy_gain;
            _result.delta_stress -= 10;
            _result.delta_hungry += 10;
            // REVISI: Reward = hasil aksi + bonus kebutuhan.
            _result.reward += (energy_gain / 2) + _urgency_energy;
            if (energy > 95) _result.reward -= 30; // Hukuman jika tidur saat tidak lelah.
            break;

        case ACTIONS.Makan:
            var cost_of_food = 15;
            _result.delta_hungry -= 50;
            _result.delta_energy += 10;
            _result.delta_money -= cost_of_food;
            // REVISI: Logika makan yang lebih realistis.
            if (money >= cost_of_food) {
                // Jika mampu makan, rewardnya adalah kepuasan + bonus lapar.
                _result.reward += 25 + _urgency_hungry;
            } else {
                // Jika tidak mampu makan, beri hukuman SANGAT BESAR.
                _result.reward -= 150;
                // Ini akan mendorong agen untuk BEKERJA jika lapar tapi tidak punya uang.
            }
            if (hungry < 30) _result.reward -= 50; // Hukuman jika makan saat kenyang.
            break;

        case ACTIONS.Bekerja:
            var money_gained = round(25 * effectiveness);
            _result.delta_money += money_gained;
            _result.delta_energy -= 20;
            _result.delta_stress += 5;
            _result.delta_hungry += 15;
            // REVISI: Reward = hasil kerja + bonus kebutuhan uang.
            _result.reward += money_gained + _urgency_money;
            if (effectiveness < 0.5) _result.reward -= 20; // Hukuman jika kerja tidak efektif.
            break;

        case ACTIONS.Bermain:
            _result.delta_stress -= 15;
            _result.delta_social += 5;
            _result.delta_energy -= 10;
            _result.delta_hungry += 5;
            // REVISI: Reward bermain adalah untuk fun (mengurangi stres/menambah sosial)
            _result.reward += 15 + _urgency_stress + _urgency_social;
            if (energy < 20 || hungry > 80) _result.reward -= 30; // Jangan bermain jika kondisi fisik buruk.
            break;

        case ACTIONS.Belajar:
            _result.delta_iq += round(3 * effectiveness);
            _result.delta_energy -= 15;
            _result.delta_stress += 5;
            _result.delta_hungry += 10;
            _result.delta_money -= 5;
            // REVISI: Belajar adalah investasi jangka panjang, beri reward kecil tapi stabil.
            _result.reward += 10;
            if (iq > 150) _result.reward += 20; // Bonus jika sudah pintar.
            if (effectiveness < 0.5) _result.reward -= 30;
            break;

        case ACTIONS.Olahraga:
            _result.delta_health += 10;
            _result.delta_stress -= 5;
            _result.delta_energy -= 25;
            _result.delta_hungry += 20;
            // REVISI: Reward olahraga adalah untuk kesehatan.
            _result.reward += 15 + _urgency_health;
            if (energy < 30 || health < 30) _result.reward -= 40; // Jangan olahraga jika sakit/lelah.
            break;

        case ACTIONS.Liburan:
            var cost_of_holiday = 80;
            _result.delta_money -= cost_of_holiday;
            _result.delta_stress -= 40; // Sangat efektif
            _result.delta_social += 10;
            _result.delta_energy -= 5;
            if (money >= cost_of_holiday) {
                // Liburan itu mewah, tapi sangat memuaskan jika stres.
                _result.reward += 30 + (_urgency_stress * 1.5); // Bonus stresnya lebih besar.
            } else {
                _result.reward -= 100; // Hukuman jika nekat liburan padahal miskin.
            }
            break;

        case ACTIONS.Rawat_Jalan:
            var cost_of_treatment = 40;
            _result.delta_money -= cost_of_treatment;
            _result.delta_health += 30;
            if (money >= cost_of_treatment) {
                // REVISI: Sangat penting jika kesehatan kritis.
                _result.reward += 20 + _urgency_health;
            } else {
                _result.reward -= 50; // Tidak bisa berobat jika tidak punya uang.
            }
            if (!is_sick && health > 50) _result.reward -= 40; // Jangan buang uang jika sehat.
            break;
            
        // Catatan: Aksi seperti Menikah, Punya Anak, Istirahat, dll bisa direvisi dengan pola yang sama.
        // Untuk sekarang, kita fokus pada loop utama.
        default:
            // Aksi lain yang belum direvisi akan mendapat penalti kecil.
            _result.reward -= 5;
            break;
    }

    // Bagian ini tetap sama, sangat penting.
    if (!_dry_run) {
        iq += _result.delta_iq;
        money += _result.delta_money;
        health += _result.delta_health;
        hungry += _result.delta_hungry;
        social += _result.delta_social;
        stress += _result.delta_stress;
        energy += _result.delta_energy;
        
        // Konsekuensi status (sangat penting untuk mendorong perilaku baik)
        if (hungry > 95) { health -= 3; _result.reward -= 15; }
        if (energy < 5) { health -= 2; _result.reward -= 15; }
        if (stress > 95) { health -= 2; _result.reward -= 15; }
        
        health = clamp(health, 0, 100); hungry = clamp(hungry, 0, 100); energy = clamp(energy, 0, 100);
        stress = clamp(stress, 0, 100); social = clamp(social, 0, 100); iq = clamp(iq, 0, 200); money = max(0, money);
    }
    
    return _result;
}