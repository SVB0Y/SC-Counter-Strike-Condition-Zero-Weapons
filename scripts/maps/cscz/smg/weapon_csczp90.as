// Counter-Strike Condition Zero ES C90 (FN P90)
/* Model Credits
/ Model: Valve
/ Textures: Valve
/ Animations: Valve
/ Sounds: Valve
/ Sprites: Valve, R4to0
/ Misc: Valve, D.N.I.O. 071 (Magazine Model Rip), SV BOY
/ Script: KernCore
/ Hand Rig: Mementocity, Garompa (Fixing, merging, additional rigs), Norman and DNIO071 (Remappable hands)
*/

#include "../base"

namespace CSCZ_P90
{

// Animations
enum CSCZ_P90_Animations
{
	IDLE = 0,
	RELOAD,
	DRAW,
	SHOOT1,
	SHOOT2,
	SHOOT3
};

// Models
string W_MODEL  	= "models/csczsven/wpn/p90/w_p90.mdl";
string V_MODEL  	= "models/csczsven/wpn/p90/v_p90.mdl";
string P_MODEL  	= "models/csczsven/wpn/p90/p_p90.mdl";
string A_MODEL  	= "models/csczsven/ammo/mags.mdl";
int MAG_BDYGRP  	= 19;
// Sprites
string SPR_CAT  	= "smg/"; //Weapon category used to get the sprite's location
// Sounds
array<string> 		WeaponSoundEvents = {
					"csczsven/p90/bltbk.wav",
					"csczsven/p90/magin.wav",
					"csczsven/p90/magout.wav",
					"csczsven/p90/magrel.wav"
};
string SHOOT_S  	= "csczsven/p90/shoot.wav";
// Information
int MAX_CARRY   	= 500;
int MAX_CLIP    	= 50;
int DEFAULT_GIVE 	= MAX_CLIP * 3;
int WEIGHT      	= 5;
int FLAGS       	= ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 15;
uint SLOT       	= 2;
uint POSITION   	= 8;
float RPM       	= 0.066f;
uint MAX_SHOOT_DIST	= 8192;
string AMMO_TYPE 	= "CSCZ_5.7mm";

//Buy Menu Information
string WPN_NAME 	= "FN P90";
uint WPN_PRICE  	= 375;
string AMMO_NAME 	= "P90 Magazine";
uint AMMO_PRICE  	= 55;

class weapon_csczp90 : ScriptBasePlayerWeaponEntity, CSCZBASE::WeaponBase
{
	private CBasePlayer@ m_pPlayer
	{
		get const 	{ return cast<CBasePlayer@>( self.m_hPlayer.GetEntity() ); }
		set       	{ self.m_hPlayer = EHandle( @value ); }
	}
	private int m_iShell;
	private int GetBodygroup()
	{
		return 0;
	}

	void Spawn()
	{
		Precache();
		CommonSpawn( W_MODEL, DEFAULT_GIVE );
		self.pev.scale = 1.2;
	}

	void Precache()
	{
		self.PrecacheCustomModels();
		//Models
		g_Game.PrecacheModel( W_MODEL );
		g_Game.PrecacheModel( V_MODEL );
		g_Game.PrecacheModel( P_MODEL );
		g_Game.PrecacheModel( A_MODEL );
		m_iShell = g_Game.PrecacheModel( CSCZBASE::SHELL_RIFLE );
		//Entity
		g_Game.PrecacheOther( GetAmmoName() );
		//Sounds
		CSCZBASE::PrecacheSound( SHOOT_S );
		CSCZBASE::PrecacheSound( CSCZBASE::EMPTY_RIFLE_S );
		CSCZBASE::PrecacheSounds( WeaponSoundEvents );
		//Sprites
		CommonSpritePrecache();
		g_Game.PrecacheGeneric( CSCZBASE::MAIN_SPRITE_DIR + CSCZBASE::MAIN_CSTRIKE_DIR + SPR_CAT + self.pev.classname + ".txt" );
	}

	bool GetItemInfo( ItemInfo& out info )
	{
		info.iMaxAmmo1 	= (CSCZBASE::ShouldUseCustomAmmo) ? MAX_CARRY : CSCZBASE::DF_MAX_CARRY_556;
		info.iAmmo1Drop	= MAX_CLIP;
		info.iMaxAmmo2 	= -1;
		info.iAmmo2Drop	= -1;
		info.iMaxClip 	= MAX_CLIP;
		info.iSlot  	= SLOT;
		info.iPosition 	= POSITION;
		info.iId     	= g_ItemRegistry.GetIdForName( self.pev.classname );
		info.iFlags 	= FLAGS;
		info.iWeight 	= WEIGHT;

		return true;
	}

	bool AddToPlayer( CBasePlayer@ pPlayer )
	{
		return CommonAddToPlayer( pPlayer );
	}

	bool Deploy()
	{
		return Deploy( V_MODEL, P_MODEL, DRAW, "mp5", GetBodygroup(), (30.0/30.0) );
	}

	bool PlayEmptySound()
	{
		return CommonPlayEmptySound( CSCZBASE::EMPTY_RIFLE_S );
	}

	void Holster( int skiplocal = 0 )
	{
		CommonHolster();

		BaseClass.Holster( skiplocal );
	}

	void PrimaryAttack()
	{
		if( self.m_iClip <= 0 )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + RPM;
			return;
		}

		Vector vecSpread;

		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			vecSpread = VECTOR_CONE_2DEGREES * 1.3f * 1.45f;
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 170 )
		{
			vecSpread = VECTOR_CONE_1DEGREES * 1.115f * 1.41f;
		}
		else
		{
			vecSpread = VECTOR_CONE_1DEGREES * 1.045f * 1.38f;
		}

		vecSpread = vecSpread * (m_iShotsFired * 0.2f);

		self.m_flNextPrimaryAttack = WeaponTimeBase() + RPM;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.0f;

		ShootWeapon( SHOOT_S, 1, vecSpread, MAX_SHOOT_DIST, DAMAGE, DMG_SNIPER | DMG_NEVERGIB );
		self.SendWeaponAnim( SHOOT1 + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 0.9, 0.45, 0.35, 0.04, 5.25, 3.5, 4 );
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 0.45, 0.3, 0.2, 0.0275, 4.0, 2.25, 7 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.275, 0.2, 0.125, 0.02, 3.0, 1.0, 9 );
		}
		else
		{
			KickBack( 0.3, 0.225, 0.125, 0.02, 3.25, 1.25, 8 );
		}

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = DIM_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 15, 8, -5 ), false, true );
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, RELOAD, (135.0/40.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flNextPrimaryAttack + 0.2 < g_Engine.time ) // wait 0.2 seconds before reseting how many shots the player fired
			m_iShotsFired = 0;

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( IDLE, 0, GetBodygroup() );
		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class P90_MAG : ScriptBasePlayerAmmoEntity, CSCZBASE::AmmoBase
{
	void Spawn()
	{
		Precache();

		CommonSpawn( A_MODEL, MAG_BDYGRP );
		self.pev.scale = 1;
	}

	void Precache()
	{
		//Models
		g_Game.PrecacheModel( A_MODEL );
		//Sounds
		CommonPrecache();
	}

	bool AddAmmo( CBaseEntity@ pOther )
	{
		return CommonAddAmmo( pOther, MAX_CLIP, (CSCZBASE::ShouldUseCustomAmmo) ? MAX_CARRY : CSCZBASE::DF_MAX_CARRY_556, (CSCZBASE::ShouldUseCustomAmmo) ? AMMO_TYPE : CSCZBASE::DF_AMMO_556 );
	}
}

string GetAmmoName()
{
	return "ammo_csczp90";
}

string GetName()
{
	return "weapon_csczp90";
}

void Register()
{
	CSCZBASE::RegisterCWEntity( "CSCZ_P90::", "weapon_csczp90", GetName(), GetAmmoName(), "P90_MAG", 
		CSCZBASE::MAIN_CSTRIKE_DIR + SPR_CAT, (CSCZBASE::ShouldUseCustomAmmo) ? AMMO_TYPE : CSCZBASE::DF_AMMO_556 );
}

}