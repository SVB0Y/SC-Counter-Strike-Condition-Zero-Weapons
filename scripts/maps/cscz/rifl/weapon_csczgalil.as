// Counter-Strike Condition Zero IDF Defender (IMI Galil)
/* Model Credits
/ Model: Valve
/ Textures: Valve
/ Animations: Valve
/ Sounds: Valve
/ Sprites: Valve, burken, R4to0
/ Misc: Valve, D.N.I.O. 071 (Magazine Model Rip), SV BOY
/ Script: KernCore
/ Hand Rig: Mementocity, Garompa (Fixing, merging, additional rigs), Norman and DNIO071 (Remappable hands)
*/

namespace CSCZ_GALIL
{

// Animations
enum CSCZ_Galil_Animations
{
	IDLE = 0,
	RELOAD,
	DRAW,
	SHOOT1,
	SHOOT2,
	SHOOT3
};

// Models
string W_MODEL  	= "models/csczsven/wpn/galil/w_galil.mdl";
string V_MODEL  	= "models/csczsven/wpn/galil/v_galil.mdl";
string P_MODEL  	= "models/csczsven/wpn/galil/p_galil.mdl";
string A_MODEL  	= "models/csczsven/ammo/mags.mdl";
int MAG_BDYGRP  	= 9;
// Sprites
string SPR_CAT  	= "rifl/"; //Weapon category used to get the sprite's location
// Sounds
array<string> 		WeaponSoundEvents = {
					"csczsven/galil/magout.wav",
					"csczsven/galil/magin.wav",
					"csczsven/galil/bltbk.wav"
};
string SHOOT_S  	= "csczsven/galil/shoot.wav";
// Information
int MAX_CARRY   	= 300;
int MAX_CLIP    	= 35;
int DEFAULT_GIVE 	= MAX_CLIP * 3;
int WEIGHT      	= 5;
int FLAGS       	= ITEM_FLAG_NOAUTOSWITCHEMPTY;
uint DAMAGE     	= 22;
uint SLOT       	= 5;
uint POSITION   	= 6;
float RPM       	= 0.0875f;
uint MAX_SHOOT_DIST	= 8192;
string AMMO_TYPE 	= "CSCZ_5.56nato";

//Buy Menu Information
string WPN_NAME 	= "IMI Galil";
uint WPN_PRICE  	= 340;
string AMMO_NAME 	= "GALIL 5.56 NATO Magazine";
uint AMMO_PRICE  	= 35;

class weapon_csczgalil : ScriptBasePlayerWeaponEntity, CSCZBASE::WeaponBase
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
		self.pev.scale = 1;
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
		return Deploy( V_MODEL, P_MODEL, DRAW, "m16", GetBodygroup(), (35.0/35.0) );
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
		if( self.m_iClip <= 0 || m_pPlayer.pev.waterlevel == WATERLEVEL_HEAD )
		{
			self.PlayEmptySound();
			self.m_flNextPrimaryAttack = WeaponTimeBase() + 0.15f;
			return;
		}

		Vector vecSpread;

		if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			vecSpread = VECTOR_CONE_1DEGREES * 1.34 * (0.12 + (m_iShotsFired * 0.21));
		}
		else if( m_pPlayer.pev.velocity.Length2D() > 140 )
		{
			vecSpread = VECTOR_CONE_1DEGREES * 1.14 * (0.07 + (m_iShotsFired * 0.135));
		}
		else
		{
			vecSpread = VECTOR_CONE_1DEGREES * 1.0375;
		}

		vecSpread = vecSpread * (m_iShotsFired * 0.215); // do vector math calculations here to make the Spread worse

		self.m_flNextPrimaryAttack = WeaponTimeBase() + RPM;
		self.m_flTimeWeaponIdle = WeaponTimeBase() + 1.5f;

		ShootWeapon( SHOOT_S, 1, vecSpread, MAX_SHOOT_DIST, DAMAGE );
		self.SendWeaponAnim( SHOOT1 + Math.RandomLong( 0, 2 ), 0, GetBodygroup() );

		if( m_pPlayer.pev.velocity.Length2D() > 0 )
		{
			KickBack( 1.0, 0.45, 0.28, 0.045, 3.75, 3.0, 7 );
		}
		else if( !( m_pPlayer.pev.flags & FL_ONGROUND != 0 ) )
		{
			KickBack( 1.2, 0.5, 0.23, 0.15, 5.5, 3.5, 6 );
		}
		else if( m_pPlayer.pev.flags & FL_DUCKING != 0 )
		{
			KickBack( 0.6, 0.3, 0.2, 0.0125, 3.25, 2.0, 7 );
		}
		else
		{
			KickBack( 0.65, 0.35, 0.25, 0.015, 3.5, 2.25, 7 );
		}

		m_pPlayer.m_iWeaponVolume = NORMAL_GUN_VOLUME;
		m_pPlayer.m_iWeaponFlash = BRIGHT_GUN_FLASH;

		ShellEject( m_pPlayer, m_iShell, Vector( 20, 10, -10 ), true, false );
	}

	void Reload()
	{
		if( self.m_iClip == MAX_CLIP || m_pPlayer.m_rgAmmo( self.m_iPrimaryAmmoType ) <= 0 )
			return;

		Reload( MAX_CLIP, RELOAD, (80.0/30.0), GetBodygroup() );

		BaseClass.Reload();
	}

	void WeaponIdle()
	{	
		self.ResetEmptySound();
		m_pPlayer.GetAutoaimVector( AUTOAIM_10DEGREES );

		if( self.m_flNextPrimaryAttack < g_Engine.time )
			m_iShotsFired = 0;

		if( self.m_flTimeWeaponIdle > WeaponTimeBase() )
			return;

		self.SendWeaponAnim( IDLE, 0, GetBodygroup() );

		self.m_flTimeWeaponIdle = WeaponTimeBase() + g_PlayerFuncs.SharedRandomFloat( m_pPlayer.random_seed, 5, 7 );
	}
}

class GALIL_MAG : ScriptBasePlayerAmmoEntity, CSCZBASE::AmmoBase
{
	void Spawn()
	{
		Precache();

		CommonSpawn( A_MODEL, MAG_BDYGRP );
		self.pev.scale = 1.1;
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
	return "ammo_csczgalil";
}

string GetName()
{
	return "weapon_csczgalil";
}

void Register()
{
	CSCZBASE::RegisterCWEntity( "CSCZ_GALIL::", "weapon_csczgalil", GetName(), GetAmmoName(), "GALIL_MAG", 
		CSCZBASE::MAIN_CSTRIKE_DIR + SPR_CAT, (CSCZBASE::ShouldUseCustomAmmo) ? AMMO_TYPE : CSCZBASE::DF_AMMO_556 );
}

}