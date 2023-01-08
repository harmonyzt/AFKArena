#include < amxmodx >
#include < amxmisc >
#include < fun >
#include < cstrike >
#include < hamsandwich >
#include < fakemeta >
#include < cs_teams_api >

new is_infected[32]
new infection_began = 0;
new exp[32], exp_next_lvl[32], level[32], money[32];
new countdown = 20;
new first_infected = 0;

public plugin_init()
{
	register_plugin("AFK Arena", "1.0", "harmony");
    register_logevent("round_start", 2, "1=Round_Start");
	register_event("SendAudio", "mutants_win", "a", "2&%!MRAD_terwin");
	register_event("SendAudio", "heroes_win", "a", "2&%!MRAD_ctwin");
	register_event("SendAudio", "draw", "a", "2&%!MRAD_rounddraw")
	register_dictionary("afk_arena.txt");
	RegisterHam(Ham_Killed, "player", "player_killed", 1);
	RegisterHam(Ham_Spawn, "player", "player_spawn", 1);
	RegisterHam(Ham_TakeDamage,"player","player_damaged");
    set_task(1.0,"display_hud",_,_,_,"b");
}
public draw(){
	client_cmd(0,"spk afkarena/draw");
}
public mutants_win(){
	client_cmd(0,"spk afkarena/mutants_win");
}

public heroes_win(){
	client_cmd(0,"spk afkarena/heroes_win");
}

public player_spawn(id){
	client_cmd(id,"spk afkarena/spawn");
}

public player_killed(victim,killer){
	if(victim != killer) {
		exp[killer] += level[killer] + 15; 
		check_exp(killer)
		is_infected[victim] = 0;
	}
}

public client_putinserver(id){
	exp[id] = 0;
	exp_next_lvl[id] = 250;
	level[id] = 1;
	is_infected[id] = 0;
}

public display_hud(){
	// Countdown stuff
	if(countdown >= 1){
		countdown--
	}
	if(countdown == 15){
		client_cmd(0,"spk afkarena/countdown/15");
	}
	if(countdown < 11 && countdown > 0){
		set_hudmessage(160, 100, 100, 0.05, 0.50, random_num(0, 2), 0.02, 1.0, 0.01, 0.1, -1);
		show_hudmessage(0,"%L", LANG_PLAYER, "INFECTION_BEGINS_IN", countdown)
		client_cmd(0,"spk afkarena/countdown/%d", countdown);
	} else if(countdown == 0 && infection_began == 0) {
		// Infect someone
		static name[32];
		new CsTeams:team;

		infection_began = 1;

		new player[32], num, randomplayer
		get_players(player, num, "ah")
		randomplayer = player[random(num)]

		get_user_name(randomplayer, name, 31);
		client_print(0, print_chat,"%L", LANG_PLAYER, "FIRST_INFECTED", name)
		infect_user(randomplayer);

		for (new idz = 1; idz <= get_maxplayers(); idz++){
			// Skip if not connected
			if (!is_user_connected(idz) && !is_user_alive(idz) && is_user_infected(idz))
				return;

			team = cs_get_user_team(idz)
			
			// Skip if not playing
			if (team == CS_TEAM_SPECTATOR || team == CS_TEAM_UNASSIGNED)
				return;
			
			// Set team
			cs_set_user_team(idz, CS_TEAM_CT,_, true)
		}
	}

	// EXP Money and level HUD
	for(new id = 1; id <= get_maxplayers(); id++){
		if(!is_user_bot(id) && is_user_connected(id) && is_user_alive(id))
		{
			set_hudmessage(150, 100, 100,-1.0,0.85, 0, 1.0, 1.0);
			show_hudmessage(id,"%L",LANG_PLAYER,"HUD_EXP", exp[id], exp_next_lvl[id], level[id], money[id]);
		}
	}
}

public player_damaged(victim,inflictor,attacker,Float:damage,damage_type){
		// If player is valid
		if(!is_user_connected(attacker) | !is_user_connected(victim))
			return;
		if(victim == attacker || !victim)
			return;
		if(get_user_team(attacker) == get_user_team(victim))
			return;
		if(infection_began == 1)
			return;

		exp[attacker] += 3 + level[attacker];
		// Check EXP
		check_exp(attacker);
}

public check_exp(id){
	if(exp[id] >= exp_next_lvl[id]){
		level[id]++
		money[id] += level[id] + 5;
		exp_next_lvl[id] += 250 + exp_next_lvl[id];
		client_cmd(id,"spk afkarena/lvlup");
	}
}

// Countdown Begins
public round_start(){
	new CsTeams:team

	infection_began = 0
	countdown = 20;

	set_hudmessage(160, 100, 100, 0.05, 0.50, random_num(0, 2), 0.02, 5.0, 0.01, 0.1, -1);
	show_hudmessage(0,"%L", LANG_PLAYER, "INFECTION_STARTS_SOON");

}

infect_user(id){
	if(is_user_alive(id) && is_user_connected(id)){
		set_user_health(id, 350000)
		is_infected[id] = 1;
		cs_set_user_team(id, CS_TEAM_T,_ , true)
	}
}

is_user_infected(id){
	if(is_user_alive(id) && is_infected[id]){
		return is_infected[id];
	}
	return 0;
}

public plugin_precache(){
	precache_sound("afkarena/lvlup.wav");
	precache_sound("afkarena/countdown/15.wav");
	precache_sound("afkarena/countdown/10.wav");
	precache_sound("afkarena/countdown/9.wav");
	precache_sound("afkarena/countdown/8.wav");
	precache_sound("afkarena/countdown/7.wav");
	precache_sound("afkarena/countdown/6.wav");
	precache_sound("afkarena/countdown/5.wav");
	precache_sound("afkarena/countdown/4.wav");
	precache_sound("afkarena/countdown/3.wav");
	precache_sound("afkarena/countdown/2.wav");
	precache_sound("afkarena/countdown/1.wav");
	precache_sound("afkarena/draw.wav");
	precache_sound("afkarena/heroes_win.wav");
	precache_sound("afkarena/mutants_win.wav");
	precache_sound("afkarena/spawn.wav");
}