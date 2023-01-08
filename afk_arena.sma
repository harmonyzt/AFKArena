#include < amxmodx >
#include < amxmisc >
#include < fun >
#include < cstrike >
#include < hamsandwich >
#include < fakemeta >
#include < cs_teams_api >

new countdown = 0;

new exp[32], exp_next_lvl[32], level[32];
new money[32];

public plugin_init()
{
	register_plugin("AFK Arena", "1.0", "harmony");
    register_logevent("round_start", 2, "1=Round_Start");
	register_event("SendAudio", "mutants_win", "a", "2&%!MRAD_terwin");
	register_event("SendAudio", "heroes_win", "a", "2&%!MRAD_ctwin");
	register_dictionary("afk_arena.txt");
	RegisterHam(Ham_Killed, "player", "player_killed", 1);
	RegisterHam(Ham_Spawn, "player", "player_spawn", 1);
	RegisterHam(Ham_TakeDamage,"player","player_damaged");
    set_task(1.0,"display_hud",_,_,_,"b");
}

public mutants_win(){
}

public heroes_win(){
}

public player_spawn(){

}

public player_killed(victim,killer){
	if(victim != killer) {
		exp[killer] += level[killer] + 15; 
		check_exp(killer)
	}
}

public client_putinserver(id){
	exp[id] = 0;
	exp_next_lvl[id] = 250;
	level[id] = 1;
}

public display_hud(){
	if(countdown >= 1){
		countdown--
	}
	if(countdown < 11 && countdown > 0){
		set_hudmessage(160, 100, 100, 0.05, 0.50, random_num(0, 2), 0.02, 1.0, 0.01, 0.1, -1);
		show_hudmessage(0,"%L", LANG_PLAYER, "INFECTION_BEGINS_IN", countdown)
	} else {
		// Infect someone
	}

	for(new id = 1; id <= get_maxplayers(); id++){
		if(!is_user_bot(id) && is_user_connected(id) && is_user_alive(id))
		{
			set_hudmessage(150, 100, 100,-1.0,0.85, 0, 1.0, 1.0);
			show_hudmessage(id,"%L",LANG_PLAYER,"HUD_EXP", exp[id], exp_next_lvl[id], level[id], money[id]);
		}
	}
}

public player_damaged(victim,inflictor,attacker,Float:damage,damage_type){
		if (victim == attacker || !is_user_alive(attacker))
			return HAM_IGNORED;

		exp[attacker] += 3 + level[attacker];

		// Check EXP
		check_exp(attacker);

		return HAM_IGNORED;
}

public check_exp(id){
	if(exp[id] >= exp_next_lvl[id]){
		level[id]++
		money[id] += level[id] + 5;
		exp_next_lvl[id] += 250;
		client_cmd(id,"spk afkarena/lvlup");
	}
}

// Countdown Begins
public round_start(){
	set_hudmessage(160, 100, 100, 0.05, 0.50, random_num(0, 2), 0.02, 5.0, 0.01, 0.1, -1);
	show_hudmessage(0,"%L", LANG_PLAYER, "INFECTION_STARTS_SOON");
	countdown = 15;

	new CsTeams:team

	for (new id = 1; id <= get_maxplayers(); id++){
		// Skip if not connected
		if (!is_user_connected(id))
			continue;

		team = cs_get_user_team(id)
		
		// Skip if not playing
		if (team == CS_TEAM_SPECTATOR || team == CS_TEAM_UNASSIGNED)
			continue;
		
		// Set team
		cs_set_player_team(id, CS_TEAM_CT, 0)
	}

}

public plugin_precache(){
	precache_sound("afkarena/lvlup.wav");
}