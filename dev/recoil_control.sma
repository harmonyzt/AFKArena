#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <xs>

#define PLUGIN	"Recoil Control"
#define AUTHOR	"OT"
#define VERSION	"1.5"

#define NO_RECOIL_WEAPONS_BITSUM  (1<<2 | 1<<CSW_KNIFE | 1<<CSW_HEGRENADE | 1<<CSW_FLASHBANG | 1<<CSW_SMOKEGRENADE | 1<<CSW_C4)
#define MAX_PLAYERS  			  32

new pcvars[CSW_P90 + 1]
new cl_weapon[MAX_PLAYERS + 1]
new Float:cl_pushangle[MAX_PLAYERS + 1][3]

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_cvar("recoil_control_version",VERSION,FCVAR_SERVER)
	
	register_event("CurWeapon", "event_active_weapon", "be","1=1")
	
	new weapon_name[20], cvar_name[21] 
	for (new i=CSW_P228;i<=CSW_P90;i++) 
	{         
		if(!(NO_RECOIL_WEAPONS_BITSUM & (1<<i)) && get_weaponname(i, weapon_name, charsmax(weapon_name))) 
		{ 
			RegisterHam(Ham_Weapon_PrimaryAttack, weapon_name, "fw_primary_attack")
			RegisterHam(Ham_Weapon_PrimaryAttack, weapon_name, "fw_primary_attack_post",1) 
			formatex(cvar_name, charsmax(cvar_name), "amx_recoil_%s", weapon_name[7]) 
			pcvars[i] = register_cvar(cvar_name,"1.0") 
		} 
	}
	
	pcvars[0] = register_cvar("amx_recoil_mode","1")
	pcvars[9] = register_cvar("amx_recoil_all","1.0")
}

public event_active_weapon(id)
{
	cl_weapon[id] = read_data(2)
	return PLUGIN_CONTINUE
}

public fw_primary_attack(ent)
{
	new id = pev(ent,pev_owner)
	pev(id,pev_punchangle,cl_pushangle[id])
	
	return HAM_IGNORED
}

public fw_primary_attack_post(ent)
{
	new id = pev(ent,pev_owner)

	new Float:push[3]
	pev(id,pev_punchangle,push)
	xs_vec_sub(push,cl_pushangle[id],push)
	switch(get_pcvar_num(pcvars[0]))
	{
		case 1:
		{
			xs_vec_mul_scalar(push,get_pcvar_float(pcvars[cl_weapon[id]]),push)
			xs_vec_add(push,cl_pushangle[id],push)
			set_pev(id,pev_punchangle,push)
			return HAM_IGNORED
		}
		case 2:
		{
			xs_vec_mul_scalar(push,get_pcvar_float(pcvars[9]),push)
			xs_vec_add(push,cl_pushangle[id],push)
			set_pev(id,pev_punchangle,push)
			return HAM_IGNORED
		}
		default: return HAM_IGNORED
	}
	
	return HAM_IGNORED
}