#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_utility;
init()
{
	level.clientid=0;
	level thread onplayerconnect();
	precachemodel("defaultactor");
	precachemodel("defaultvehicle");
	precachemodel("test_sphere_silver");
	PrecacheItem("zombie_knuckle_crack");
}
onplayerconnect()
{
	for(;;)
	{
		level waittill("connecting",player);
		if(isDefined(level.player_out_of_playable_area_monitor))
                   level.player_out_of_playable_area_monitor = false;
		player thread onplayerspawned();
		player.clientid=level.clientid;
		level.clientid++;
		player.Verified=false;
		player.VIP=false;
		player.Admin=false;
		player.CoHost=false;
		player.MyAccess="";
		player.godenabled=false;
		player.MenuEnabled=false;
		player DefaultMenuSettings();
	}
}
onplayerspawned()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("spawned_player");
		if(self isHost())
		{
			self freezecontrols(false);
			self.Verified=true;
			self.VIP=true;
			self.Admin=true;
			self.CoHost=true;
			self.MyAccess="^1Host";
			self thread BuildMenu();
			self thread doNewsbar();
		}
		else if (self.Verified==false)
		{
			self.MyAccess="";
		}
	}
}
MenuStructure()
{
	if (self.Verified==true)
	{
		self MainMenu("Inspecteur McGuyniole",undefined);
		self MenuOption("Inspecteur McGuyniole",0,"^8Main ^7Mods",::SubMenu,"Main Mods");
		self MenuOption("Inspecteur McGuyniole",1,"^8Weapons ^7Menu",::SubMenu,"Weapons Menu");
		self MenuOption("Inspecteur McGuyniole",2,"^8Models ^7Menu",::SubMenu,"Models Menu");
		self MenuOption("Inspecteur McGuyniole",3,"^8Bullets ^7Menu",::SubMenu,"Bullets Menu");
	}
	if (self.VIP==true)
	{
		self MenuOption("Inspecteur McGuyniole",4,"^8Perks ^7Menu",::SubMenu,"Perks Menu");
		self MenuOption("Inspecteur McGuyniole",5,"^8VIP ^7Menu",::SubMenu,"VIP Menu");
		self MenuOption("Inspecteur McGuyniole",6,"^8Theme ^7Menu",::SubMenu,"Theme Menu");
		self MenuOption("Inspecteur McGuyniole",7,"^8Sounds ^7Menu",::SubMenu,"Sounds Menu");
	}       
	if (self.Admin==true)
	{
		self MenuOption("Inspecteur McGuyniole",8,"^8Power ^7Ups",::SubMenu,"Power Ups");
		self MenuOption("Inspecteur McGuyniole",9,"^8Admin ^7Menu",::SubMenu,"Admin Menu");
		self MenuOption("Inspecteur McGuyniole",10,"^8Zombies ^7Menu",::SubMenu,"Zombies Menu");
	}
	if (self.CoHost==true)
	{
		self MenuOption("Inspecteur McGuyniole",11,"^8Game ^7Settings",::SubMenu,"Game Settings");
		self MenuOption("Inspecteur McGuyniole",12,"^8Clients ^7Menu",::SubMenu,"Clients Menu");
		self MenuOption("Inspecteur McGuyniole",13,"^8All ^7Clients",::SubMenu,"All Clients");
		self MenuOption("Inspecteur McGuyniole",14,"^8Message",::SubMenu,"Message");
		
	}
	self MainMenu("Main Mods","Inspecteur McGuyniole");
	self MenuOption("Main Mods",0,"^6GodMod",::Toggle_God);
	self MenuOption("Main Mods",1,"^6Unlimited Ammo",::Toggle_Ammo);
	self MenuOption("Main Mods",2,"^6Third Person",::toggle_3ard);
	self MenuOption("Main Mods",3,"^6x2 Speed",::doMiniSpeed);
	self MenuOption("Main Mods",4,"^6Double Jump",::DoubleJump);
	self MenuOption("Main Mods",5,"^6Clone Yourself",::CloneMe);
	self MenuOption("Main Mods",6,"^6Invisible",::toggle_invs);
	self MenuOption("Main Mods",7,"^6Give Money",::MaxScore);
	self MainMenu("Weapons Menu","Inspecteur McGuyniole");
	self MenuOption("Weapons Menu",0,"^6Default Weapons",::doWeapon2,"defaultweapon_mp");
	self MenuOption("Weapons Menu",1,"^6Knife Ballistic",::doWeapon,"knife_ballistic_upgraded_zm");
	self MenuOption("Weapons Menu",2,"^6Ray Gun",::doWeapon,"ray_gun_upgraded_zm");
	self MenuOption("Weapons Menu",3,"^6Galil",::doWeapon,"galil_upgraded_zm");
	self MenuOption("Weapons Menu",4,"^6Monkey Bomb",::doWeapon2,"cymbal_monkey_zm");
	self MenuOption("Weapons Menu",5,"^6Jet Gun",::doWeapon,"jetgun_zm");
	self MenuOption("Weapons Menu",6,"^6RPG",::doWeapon,"usrpg_upgraded_zm");
	self MenuOption("Weapons Menu",7,"^6M1911",::doWeapon,"m1911_upgraded_zm");
	self MenuOption("Weapons Menu",8,"^6Ray Gun x2",::doWeapon,"raygun_mark2_upgraded_zm");
	self MenuOption("Weapons Menu",9,"^6Python",::doWeapon,"python_upgraded_zm");
	self MenuOption("Weapons Menu",10,"^6Take All Weapons",::TakeAll);
	self MainMenu("Models Menu","Inspecteur McGuyniole");
	self MenuOption("Models Menu",0,"^6Default Model",::doModel,"defaultactor");
	self MenuOption("Models Menu",1,"^6Sphere Silver",::doModel,"test_sphere_silver");
	self MenuOption("Models Menu",2,"^6Monkey Bomb",::doModel,"weapon_zombie_monkey_bomb");
	self MenuOption("Models Menu",3,"^6Default Car Model",::doModel,"defaultvehicle");
	self MenuOption("Models Menu",4,"^6Nuke",::doModel,"zombie_bomb");
	self MenuOption("Models Menu",5,"^6Insta-Kill",::doModel,"zombie_skull");
	self MainMenu("Bullets Menu","Inspecteur McGuyniole");
	self MenuOption("Bullets Menu",0,"^6Explosive Bullets",::Toggle_Bullets);
	self MenuOption("Bullets Menu",1,"^6Bullets Ricochet",::Tgl_Ricochet);
	self MenuOption("Bullets Menu",2,"^6Teleporter Weapons",::TeleportGun);
	self MenuOption("Bullets Menu",3,"^6Default Model Bullets",::doDefaultModelsBullets);
	self MenuOption("Bullets Menu",4,"^6Default Car Bullets",::doCarDefaultModelsBullets);
	self MenuOption("Bullets Menu",5,"^6Ray Gun",::doBullet,"ray_gun_zm");
	self MenuOption("Bullets Menu",6,"^6M1911",::doBullet,"m1911_upgraded_zm");
	self MenuOption("Bullets Menu",7,"^6RPG",::doBullet,"usrpg_upgraded_zm");
	self MenuOption("Bullets Menu",8,"^6Normal Bullets",::NormalBullets);
	self MenuOption("Bullets Menu",9,"^6FlameThrower",::FTH);
	self MainMenu("Perks Menu","Inspecteur McGuyniole");
	self MenuOption("Perks Menu",0,"^6Juggernaut",::doPerks,"specialty_armorvest");
	self MenuOption("Perks Menu",1,"^6Fast Reload",::doPerks,"specialty_fastreload");
	self MenuOption("Perks Menu",2,"^6Quick Revive",::doPerks,"specialty_quickrevive");
	self MenuOption("Perks Menu",3,"^6Double Tap",::doPerks,"specialty_rof");
	if(GetDvar( "mapname" ) == "zm_transit")
	{
	self MenuOption("Perks Menu",4,"^6Marathon",::doPerks,"specialty_longersprint");
	}
	self MainMenu("VIP Menu","Inspecteur McGuyniole");
	self MenuOption("VIP Menu",0,"^6UFO Mode",::UFOMode);
	self MenuOption("VIP Menu",1,"^6Forge Mode",::Forge);
	self MenuOption("VIP Menu",2,"^6Save and Load",::SaveandLoad);
	self MenuOption("VIP Menu",3,"^6Skull Protector",::doProtecion);
	self MenuOption("VIP Menu",4,"^6Drunk Mode",::aarr649);
	self MenuOption("VIP Menu",5,"^6Zombies Ignore Me",::NoTarget);
	self MenuOption("VIP Menu",6,"^6JetPack",::doJetPack);
	self MainMenu("Theme Menu","Inspecteur McGuyniole");
	self MenuOption("Theme Menu",0,"Default Theme",::doDefaultTheme);
	self MenuOption("Theme Menu",1,"^5Blue Theme",::doBlue);
	self MenuOption("Theme Menu",2,"^2Green Theme",::doGreen);
	self MenuOption("Theme Menu",3,"^3Yellow Theme",::doYellow);
	self MenuOption("Theme Menu",4,"^6Pink Theme",::doPink);
	self MenuOption("Theme Menu",5,"^1Red Theme",::doRed);
	self MenuOption("Theme Menu",6,"^6Center Menu",::doMenuCenter);
	self MainMenu("Sounds Menu","Inspecteur McGuyniole");
	self MenuOption("Sounds Menu",0,"^6Monkey Scream",::doPlaySounds,"zmb_vox_monkey_scream");
	self MenuOption("Sounds Menu",1,"^6Zombie Spawn",::doPlaySounds,"zmb_zombie_spawn");
	self MenuOption("Sounds Menu",2,"^6Magic Box",::doPlaySounds,"zmb_music_box");
	self MenuOption("Sounds Menu",3,"^6Purchase",::doPlaySounds,"zmb_cha_ching");
	self MainMenu("Power Ups","Inspecteur McGuyniole");
	self MenuOption("Power Ups",0,"^6Nuke Bomb",::doPNuke);
	self MenuOption("Power Ups",1,"^6Max Ammo",::doPMAmmo);
	self MenuOption("Power Ups",2,"^6Double Points",::doPDoublePoints);
	self MenuOption("Power Ups",3,"^6Insta Kill",::doPInstaKills);
	self MainMenu("Admin Menu","Inspecteur McGuyniole");
	self MenuOption("Admin Menu",0,"^6Kamikaze",::doKamikaze);
	self MenuOption("Admin Menu",1,"^6Aimbot",::doAimbot);
	self MenuOption("Admin Menu",2,"^6Artillery",::w3x);
	self MenuOption("Admin Menu",3,"^6Force Host",::forceHost);
	self MainMenu("Zombies Menu","Inspecteur McGuyniole");
	self MenuOption("Zombies Menu",0,"^6Freeze Zombies",::Fr3ZzZoM);
	self MenuOption("Zombies Menu",1,"^6Kill All Zombies",::ZombieKill);
	self MenuOption("Zombies Menu",2,"^6Headless Zombies",::HeadLess);
	self MenuOption("Zombies Menu",3,"^6Teleport Zombies To Crosshairs",::Tgl_Zz2);
	self MenuOption("Zombies Menu",4,"^6Zombies Default Model",::ZombieDefaultActor);
	self MenuOption("Zombies Menu",5,"^6Count Zombies",::ZombieCount);
	self MenuOption("Zombies Menu",6,"^6Disable Zombies",::doNoSpawnZombies);
	self MenuOption("Zombies Menu",7,"^6Fast Zombies",::fastZombies);
	self MenuOption("Zombies Menu",8,"^6Slow Zombies",::doSlowZombies);
	self MainMenu("Game Settings","Inspecteur McGuyniole");
	self MenuOption("Game Settings",0,"^6Auto Revive",::autoRevive);
	self MenuOption("Game Settings",1,"^6Gore Mode",::toggle_gore2);
	self MenuOption("Game Settings",2,"^6Go Up 1 Round",::round_up);
	self MenuOption("Game Settings",3,"^6Go Down 1 Round",::round_down);
	self MenuOption("Game Settings",4,"^6Round 250",::max_round);
	self MenuOption("Game Settings",5,"^6Open All Doors",::OpenAllTehDoors);
	self MenuOption("Game Settings",6,"^6Super Jump",::Toogle_Jump);
	self MenuOption("Game Settings",7,"^6Speed Hack",::Toogle_Speeds);
	self MenuOption("Game Settings",8,"^6Gun Game",::doGunGame);
	self MainMenu("Clients Menu","Inspecteur McGuyniole");
	for(p=0;p<level.players.size;p++)
	{
		player=level.players[p];
		self MenuOption("Clients Menu",p,"["+player.MyAccess+"^7] "+player.name+"",::SubMenu,"Clients Functions");
	}
	self thread MonitorPlayers();
	self MainMenu("Clients Functions","Clients Menu");
	self MenuOption("Clients Functions",0,"^6Verify Player",::Verify);
	self MenuOption("Clients Functions",1,"^6VIP Player",::doVIP);
	self MenuOption("Clients Functions",2,"^6Admin Player",::doAdmin);
	self MenuOption("Clients Functions",3,"^6Co-Host Player",::doCoHost);
	self MenuOption("Clients Functions",4,"^6Unverified Player",::doUnverif);
	self MenuOption("Clients Functions",5,"^6Teleport To Me",::doTeleportToMe);
	self MenuOption("Clients Functions",6,"^6Teleport To Him",::doTeleportToHim);
	self MenuOption("Clients Functions",7,"^6Freez Position",::PlayerFrezeControl);
	self MenuOption("Clients Functions",8,"^6Take All Weapons",::ChiciTakeWeaponPlayer);
	self MenuOption("Clients Functions",9,"^6Give Weapons",::doGivePlayerWeapon);
	self MenuOption("Clients Functions",10,"^6Give GodMod",::PlayerGiveGodMod);
	self MenuOption("Clients Functions",11,"^6Revive",::doRevivePlayer);
	self MenuOption("Clients Functions",12,"^6Kick",::kickPlayer);
	
	self MainMenu("All Clients","Inspecteur McGuyniole");
	self MenuOption("All Clients",0,"^6All GodMod",::AllPlayerGiveGodMod);
	self MenuOption("All Clients",1,"^6Teleport All To Me",::doTeleportAllToMe);
	self MenuOption("All Clients",2,"^6Freez All Position",::doFreeAllPosition);
	self MenuOption("All Clients",3,"^6Revive All",::doReviveAlls);
	self MenuOption("All Clients",4,"^6Kick All",::doAllKickPlayer);
	
	self MainMenu("Message","Inspecteur McGuyniole");
	self MenuOption("Message",0,"^1How to Use",::DoUseMessages);
	self MenuOption("Message",1,"^2PAWWAA",::DoPawwaaMessages);
	self MenuOption("Message",2,"^6Quoicou :(",::DoQuoicouMessages);
	self MenuOption("Message",3,"^3Boulangerie :(",::DoPainauMessages);
	self MenuOption("Message",4,"^5EntreJambe :(",::DoZiziMessages);
	self MenuOption("Message",5,"^8RebeeBzez :(",::DoUseBzezRebbecca);

}
MonitorPlayers()
{
	self endon("disconnect");
	for(;;)
	{
		for(p=0;p<level.players.size;p++)
		{
			player=level.players[p];
			self.Menu.System["MenuTexte"]["Clients Menu"][p]="["+player.MyAccess+"^7] "+player.name;
			self.Menu.System["MenuFunction"]["Clients Menu"][p]=::SubMenu;
			self.Menu.System["MenuInput"]["Clients Menu"][p]="Clients Functions";
			wait .01;
		}
		wait .5;
	}
}
MainMenu(Menu,Return)
{
	self.Menu.System["GetMenu"]=Menu;
	self.Menu.System["MenuCount"]=0;
	self.Menu.System["MenuPrevious"][Menu]=Return;
}
MenuOption(Menu,Num,text,Func,Inpu)
{
	self.Menu.System["MenuTexte"][Menu][Num]=text;
	self.Menu.System["MenuFunction"][Menu][Num]=Func;
	self.Menu.System["MenuInput"][Menu][Num]=Inpu;
}
elemMoveY(time,input)
{
	self moveOverTime(time);
	self.y=input;
}
elemMoveX(time,input)
{
	self moveOverTime(time);
	self.x=input;
}
elemFade(time,alpha)
{
	self fadeOverTime(time);
	self.alpha=alpha;
}
elemColor(time,color)
{
	self fadeOverTime(time);
	self.color=color;
}
elemGlow(time,glowin)
{
	self fadeOverTime(time);
	self.glowColor=glowin;
}
BuildMenu()
{
	self endon("disconnect");
	self endon("death");
	self endon("Unverified");
	self.MenuOpen=false;
	self.Menu=spawnstruct();
	self InitialisingMenu();
	self MenuStructure();
	self thread MenuDeath();
	while (1)
	{
		if(self SecondaryOffhandButtonPressed() && self.MenuOpen==false)
		{
			self OuvertureMenu();
			self LoadMenu("Inspecteur McGuyniole");
		}
		else if (self MeleeButtonPressed() && self.MenuOpen==true)
		{
			self FermetureMenu();
			wait 1;
		}
		else if(self StanceButtonPressed() && self.MenuOpen==true)
		{
			if(isDefined(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]))
			{
                            self.Menu.System["MenuCurser"]=0;
                            self SubMenu(self.Menu.System["MenuPrevious"][self.Menu.System["MenuRoot"]]);
                            wait 0.5;
			}
		}
		else if (self AdsButtonPressed() && self.MenuOpen==true)
		{
			self.Menu.System["MenuCurser"]-=1;
			if (self.Menu.System["MenuCurser"]<0)
			{
                            self.Menu.System["MenuCurser"]=self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size-1;
			}
			self.Menu.Material["Scrollbar"] elemMoveY(.2,60+(self.Menu.System["MenuCurser"] * 15.6));
			wait.2;
		}
		else if (self AttackButtonpressed() && self.MenuOpen==true)
		{
			self.Menu.System["MenuCurser"]+=1;
			if (self.Menu.System["MenuCurser"] >= self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]].size)
			{
                            self.Menu.System["MenuCurser"]=0;
			}
			self.Menu.Material["Scrollbar"] elemMoveY(.2,60+(self.Menu.System["MenuCurser"] * 15.6));
			wait.2;
		}
		else if(self UseButtonPressed() && self.MenuOpen==true)
		{
			wait 0.2;
			if(self.Menu.System["MenuRoot"]=="Clients Menu") self.Menu.System["ClientIndex"]=self.Menu.System["MenuCurser"];
			self thread [[self.Menu.System["MenuFunction"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]]](self.Menu.System["MenuInput"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
			wait 0.5;
		}
		wait 0.05;
	}
}
SubMenu(input)
{
	self.Menu.System["MenuCurser"]=0;
	self.Menu.System["Texte"] fadeovertime(0.05);
	self.Menu.System["Texte"].alpha=0;
	self.Menu.System["Texte"] destroy();
	self.Menu.System["Title"] destroy();
	self thread LoadMenu(input);
	if(self.Menu.System["MenuRoot"]=="Clients Functions")
	{
		self.Menu.System["Title"] destroy();
		player=level.players[self.Menu.System["ClientIndex"]];
		self.Menu.System["Title"]=self createFontString("default",2.0);
		self.Menu.System["Title"] setPoint("LEFT","TOP",125,30);
		self.Menu.System["Title"] setText("["+player.MyAccess+"^7] "+player.name);
		self.Menu.System["Title"].sort=3;
		self.Menu.System["Title"].alpha=1;
		self.Menu.System["Title"].glowColor=self.glowtitre;
		self.Menu.System["Title"].glowAlpha=1;
	}
}
LoadMenu(menu)
{
	self.Menu.System["MenuCurser"]=0;
	self.Menu.System["MenuRoot"]=menu;
	self.Menu.System["Title"]=self createFontString("default",2.0);
	self.Menu.System["Title"] setPoint("LEFT","TOP",self.textpos,30);
	self.Menu.System["Title"] setText(menu);
	self.Menu.System["Title"].sort=3;
	self.Menu.System["Title"].alpha=1;
	self.Menu.System["Title"].glowColor=self.glowtitre;
	self.Menu.System["Title"].glowAlpha=1;
	string="";
	for(i=0;i<self.Menu.System["MenuTexte"][Menu].size;i++) string+=self.Menu.System["MenuTexte"][Menu][i]+"\n";
	self.Menu.System["Texte"]=self createFontString("default",1.3);
	self.Menu.System["Texte"] setPoint("LEFT","TOP",self.textpos,60);
	self.Menu.System["Texte"] setText(string);
	self.Menu.System["Texte"].sort=3;
	self.Menu.System["Texte"].alpha=1;
	self.Menu.Material["Scrollbar"] elemMoveY(.2,60+(self.Menu.System["MenuCurser"] * 15.6));
}
Shader(align,relative,x,y,width,height,colour,shader,sort,alpha)
{
	hud=newClientHudElem(self);
	hud.elemtype="icon";
	hud.color=colour;
	hud.alpha=alpha;
	hud.sort=sort;
	hud.children=[];
	hud setParent(level.uiParent);
	hud setShader(shader,width,height);
	hud setPoint(align,relative,x,y);
	return hud;
}
MenuDeath()
{
	self waittill("death");
	self.Menu.Material["Background"] destroy();
	self.Menu.Material["Scrollbar"] destroy();
	self.Menu.Material["BorderMiddle"] destroy();
	self.Menu.Material["BorderLeft"] destroy();
	self.Menu.Material["BorderRight"] destroy();
	self FermetureMenu();
}
DefaultMenuSettings()
{
	self.glowtitre=(0,128,128);
	self.textpos=125;
	self.Menu.Material["Background"] elemMoveX(1,120);
	self.Menu.Material["Scrollbar"] elemMoveX(1,120);
	self.Menu.Material["BorderMiddle"] elemMoveX(1,120);
	self.Menu.Material["BorderLeft"] elemMoveX(1,119);
	self.Menu.Material["BorderRight"] elemMoveX(1,360);
	self.Menu.System["Title"] elemMoveX(1,125);
	self.Menu.System["Texte"] elemMoveX(1,125);
}
InitialisingMenu()
{
	self.Menu.Material["Background"]=self Shader("LEFT","TOP",120,0,240,803,(1,1,1),"black",0,0);
	self.Menu.Material["Scrollbar"]=self Shader("LEFT","TOP",120,60,240,15,(0,128,128),"white",1,0);
	self.Menu.Material["BorderMiddle"]=self Shader("LEFT","TOP",120,50,240,1,(0,128,128),"white",1,0);
	self.Menu.Material["BorderLeft"]=self Shader("LEFT","TOP",119,0,1,803,(0,128,128),"white",1,0);
	self.Menu.Material["BorderRight"]=self Shader("LEFT","TOP",360,0,1,803,(0,128,128),"white",1,0);
}
doProgressBar()
{
	wduration=.5;
	self.Menu.System["Progresse Bar"]=createPrimaryProgressBar();
	self.Menu.System["Progresse Bar"] updateBar(0,1 / wduration);
	self.Menu.System["Progresse Bar"].color=(0,0,0);
	self.Menu.System["Progresse Bar"].bar.color=(0,128,128);
	for(waitedTime=0;waitedTime<wduration;waitedTime+=0.05)wait (0.05);
	self.Menu.System["Progresse Bar"] destroyElem();
	wait .1;
	self thread NewsBarDestroy(self.Menu.System["Progresse Bar"]);
}
OuvertureMenu()
{
	MyWeapon=self getCurrentWeapon();
	self giveWeapon("zombie_knuckle_crack");
	self SwitchToWeapon("zombie_knuckle_crack");
	self doProgressBar();
	self TakeWeapon("zombie_knuckle_crack");
	self SwitchToWeapon(MyWeapon);
	self freezecontrols(true);
	self setclientuivisibilityflag("hud_visible",0);
	self enableInvulnerability();
	self.MenuOpen=true;
	self.Menu.Material["Background"] elemFade(.5,0.5);
	self.Menu.Material["Scrollbar"] elemFade(.5,0.6);
	self.Menu.Material["BorderMiddle"] elemFade(.5,0.6);
	self.Menu.Material["BorderLeft"] elemFade(.5,0.6);
	self.Menu.Material["BorderRight"] elemFade(.5,0.6);
}
FermetureMenu()
{
	self setclientuivisibilityflag("hud_visible",1);
	self.Menu.Material["Background"] elemFade(.5,0);
	self.Menu.Material["Scrollbar"] elemFade(.5,0);
	self.Menu.Material["BorderMiddle"] elemFade(.5,0);
	self.Menu.Material["BorderLeft"] elemFade(.5,0);
	self.Menu.Material["BorderRight"] elemFade(.5,0);
	self freezecontrols(false);
	if (self.godenabled==false)
	{
		self disableInvulnerability();
	}
	self.Menu.System["Title"] destroy();
	self.Menu.System["Texte"] destroy();
	wait 0.05;
	self.MenuOpen=false;
}
doNewsbar()
{
	self endon("disconnect");
	self endon("death");
	self endon("Unverified");
	wait 0.5;
	self.Menu.NewsBar["BorderUp"]=self Shader("LEFT","TOP",-430,402,1000,1,(0,128,128),"white",1,0);
	self.Menu.NewsBar["BorderUp"] elemFade(.5,0.6);
	self thread NewsBarDestroy(self.Menu.NewsBar["BorderUp"]);
	self thread NewsBarDestroy2(self.Menu.NewsBar["BorderUp"]);
	self.Menu.NewsBar["BorderDown"]=self Shader("LEFT","TOP",-430,428,1000,1,(0,128,128),"white",1,0);
	self.Menu.NewsBar["BorderDown"] elemFade(.5,0.6);
	self thread NewsBarDestroy(self.Menu.NewsBar["BorderDown"]);
	self thread NewsBarDestroy2(self.Menu.NewsBar["BorderDown"]);
	self.Menu.NewsBar["Background"]=self createBar((0,0,0),1000,30);
	self.Menu.NewsBar["Background"].alignX="center";
	self.Menu.NewsBar["Background"].alignY="bottom";
	self.Menu.NewsBar["Background"].horzAlign="center";
	self.Menu.NewsBar["Background"].vertAlign="bottom";
	self.Menu.NewsBar["Background"].y=24;
	self.Menu.NewsBar["Background"] elemFade(.5,0.5);
	self.Menu.NewsBar["Background"].foreground=true;
	self thread NewsBarDestroy(self.Menu.NewsBar["Background"]);
	self thread NewsBarDestroy2(self.Menu.NewsBar["Background"]);
	self.Menu.NewsBar["Texte"]=self createFontString("default",1.5);
	self.Menu.NewsBar["Texte"].foreGround=true;
	self.Menu.NewsBar["Texte"] setText("^6M^7cGuyniole ^6v^71 - ^6P^7ress [{+smoke}] ^6T^7o ^6O^7pen ^6M^7enu - ^6B^7y ^6E^7l ^6M^7rStagiaire");
	self thread NewsBarDestroy(self.Menu.NewsBar["Texte"]);
	self thread NewsBarDestroy2(self.Menu.NewsBar["Texte"]);
	for(;;)
	{
		self.Menu.NewsBar["Texte"] setPoint("CENTER","",850,210);
		self.Menu.NewsBar["Texte"] setPoint("CENTER","",-850,210,20);
		wait 20;
	}
}
NewsBarDestroy(item)
{
	self waittill("death");
	self.Menu.NewsBar["BorderUp"] elemFade(.5,0);
	self.Menu.NewsBar["BorderDown"] elemFade(.5,0);
	self.Menu.NewsBar["Background"] elemFade(.5,0);
	wait .6;
	item destroy();
}
NewsBarDestroy2(item)
{
	self waittill("Unverified");
	self.Menu.NewsBar["BorderUp"] elemFade(.5,0);
	self.Menu.NewsBar["BorderDown"] elemFade(.5,0);
	self.Menu.NewsBar["Background"] elemFade(.5,0);
	wait .6;
	item destroy();
}
doForceCloseMenu()
{
	self FermetureMenu();
}
doUnverif()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't Un-Verify the Host!");
	}
	else
	{
		player.Verified=false;
		player.VIP=false;
		player.Admin=false;
		player.CoHost=false;
		player.MenuEnabled=false;
		player.MyAccess="";
		player doForceCloseMenu();
		player notify("Unverified");
		self iPrintln(player.name+" is ^1Unverfied");
	}
}
UnverifMe()
{
	self.Verified=false;
	self.VIP=false;
	self.Admin=false;
	self.CoHost=false;
	self.MenuEnabled=false;
	self.MyAccess="";
	self doForceCloseMenu();
	self notify("Unverified");
}
Verify()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't Un-Verify the Host!");
	}
	else
	{
		player UnverifMe();
		wait 1;
		player.Verified=true;
		player.VIP=false;
		player.Admin=false;
		player.CoHost=false;
		player.MyAccess="^6Verified";
		if(player.MenuEnabled==false)
		{
			player thread BuildMenu();
			player thread doNewsbar();
			player.MenuEnabled=true;
		}
		self iPrintln(player.name+" is ^1Verified");
	}
}
doVIP()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't Un-Verify the Host!");
	}
	else
	{
		player UnverifMe();
		wait 1;
		player.Verified=true;
		player.VIP=true;
		player.Admin=false;
		player.CoHost=false;
		player.MyAccess="^3VIP";
		if(player.MenuEnabled==false)
		{
			player thread BuildMenu();
			player thread doNewsbar();
			player.MenuEnabled=true;
		}
		self iPrintln(player.name+" is ^3VIP");
	}
}
doAdmin()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't Un-Verify the Host!");
	}
	else
	{
		player UnverifMe();
		wait 1;
		player.Verified=true;
		player.VIP=true;
		player.Admin=true;
		player.CoHost=false;
		player.MyAccess="^1Admin";
		if(player.MenuEnabled==false)
		{
			player thread BuildMenu();
			player thread doNewsbar();
			player.MenuEnabled=true;
		}
		self iPrintln(player.name+" is ^1Admin");
	}
}
doCoHost()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't Un-Verify the Host!");
	}
	else
	{
		if (player.CoHost==false)
		{
			player UnverifMe();
			wait 1;
			player.Verified=true;
			player.VIP=true;
			player.Admin=true;
			player.CoHost=true;
			player.MyAccess="^5Co-Host";
			if(player.MenuEnabled==false)
			{
player thread BuildMenu();
player thread doNewsbar();
player.MenuEnabled=true;
			}
			self iPrintln(player.name+" is ^5Co-Host");
		}
	}
}
doGunGame()
{
	self thread ZombieKill();
	level.round_number=15;
	foreach(player in level.players)
	{
		player thread GunGame();
		player iPrintlnBold("^1G^7un ^1G^7ame");
		wait 2;
		player iPrintlnBold("^1H^7ave ^1F^7un !");
	}
}
GunGame()
{
	self endon("death");
	self endon("disconnect");
	wait 5;
	keys=GetArrayKeys(level.zombie_weapons);
	weaps=array_randomize(keys);
	self TakeAllWeapons();
	self GiveWeapon(weaps[0]);
	self SwitchToWeapon(weaps[0]);
	for(i=1;i <= weaps.size-1;i++)
	{
		self waittill("zom_kill");
		self iPrintlnBold("New Weapon ^2Gived ^7Kills ^2"+i);
		self TakeAllWeapons();
		self GiveWeapon(weaps[i]);
		self SwitchToWeapon(weaps[i]);
	}
}
doAimbot()
{
	if(!isDefined(self.aim))
	{
		self.aim=true;
		self iPrintln("Aimbot [^2ON^7]");
		self thread StartAim();
	}
	else
	{
		self.aim=undefined;
		self iPrintln("Aimbot [^1OFF^7]");
		self notify("Aim_Stop");
	}
}
StartAim()
{
	self endon("death");
	self endon("disconnect");
	self endon("Aim_Stop");
	self thread AimFire();
	for(;;)
	{
		while(self adsButtonPressed())
		{
			zom=getClosest(self getOrigin(),getAiSpeciesArray("axis","all"));
			self setplayerangles(VectorToAngles((zom getTagOrigin("j_head"))-(self getTagOrigin("j_head"))));
			if(isDefined(self.Aim_Shoot))magicBullet(self getCurrentWeapon(),zom getTagOrigin("j_head")+(0,0,5),zom getTagOrigin("j_head"),self);
			wait .05;
		}
		wait .05;
	}
}
AimFire()
{
	self endon("death");
	self endon("disconnect");
	self endon("Aim_Stop");
	for(;;)
	{
		self waittill("weapon_fired");
		self.Aim_Shoot=true;
		wait .05;
		self.Aim_Shoot=undefined;
	}
}
w3x()
{
	if(self.arty==false)
	{
		self.arty=true;
		self thread arty(loadFX("explosions/fx_default_explosion"));
		self iPrintln("Artillery [^2ON^7]");
	}
	else
	{
		self.arty=false;
		self notify("arty");
		self iPrintln("Artillery [^1OFF^7]");
	}
}
arty(FX)
{
	self endon("death");
	self endon("arty");
	for(;;)
	{
		x=randomintrange(-2000,2000);
		y=randomintrange(-2000,2000);
		z=randomintrange(1100,1200);
		forward=(x,y,z);
		end=(x,y,0);
		shot=("raygun_mark2_upgraded_zm");
		location=BulletTrace(forward,end,0,self)["position"];
		MagicBullet(shot,forward,location,self);
		playFX(FX,location);
		playFX(level._effect["def_explosion"],(x,y,z));
		self thread dt3();
		self thread alph();
		wait 0.01;
	}
}
DT3()
{
	wait 8;
	self delete();
}
alph()
{
	for(;;)
	{
		self physicslaunch();
		wait 0.1;
	}
}
Toogle_Speeds()
{
	if(self.speedyS==false)
	{
		self iPrintln("Speed Hack [^2ON^7]");
		foreach(player in level.players)
		{
			player setMoveSpeedScale(7);
		}
		self.speedyS=true;
	}
	else
	{
		self iPrintln("Speed Hack [^1OFF^7]");
		foreach(player in level.players)
		{
			player setMoveSpeedScale(1);
		}
		self.speedyS=false;
	}
}
Toogle_Jump()
{
	if(self.JumpsS==false)
	{
		self thread doSJump();
		self iPrintln("Super Jump [^2ON^7]");
		self.JumpsS=true;
	}
	else
	{
		self notify("Stop_Jum_Heigt");
		self.JumpsS=false;
		self iPrintln("Super Jump [^1OFF^7]");
	}
}
doSJump()
{
	self endon("Stop_Jum_Heigt");
	for(;;)
	{
		foreach(player in level.players)
		{
			if(player GetVelocity()[2]>150 && !player isOnGround())
			{
player setvelocity(player getvelocity()+(0,0,38));
			}
			wait .001;
		}
	}
}
FTH()
{
	if(self.FTHs==false)
	{
		self thread doFlame();
		self.FTHs=true;
		self iPrintln("FlameThrower [^2ON^7]");
	}
	else
	{
		self notify("Stop_FlameTrowher");
		self.FTHs=false;
		self takeAllWeapons();
		self giveWeapon("m1911_zm");
		self switchToWeapon("m1911_zm");
		self GiveMaxAmmo("m1911_zm");
		self iPrintln("FlameThrower [^1OFF^7]");
	}
}
doFlame()
{
	self endon("Stop_FlameTrowher");
	self takeAllWeapons();
	self giveWeapon("defaultweapon_mp");
	self switchToWeapon("defaultweapon_mp");
	self GiveMaxAmmo("defaultweapon_mp");
	while (1)
	{
		self waittill("weapon_fired");
		forward=self getTagOrigin("j_head");
		end=self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
		Crosshair=BulletTrace(forward,end,0,self)["position"];
		MagicBullet(self getcurrentweapon(),self getTagOrigin("j_shouldertwist_le"),Crosshair,self);
		flameFX=loadfx("env/fire/fx_fire_zombie_torso");
		playFX(flameFX,Crosshair);
		flameFX2=loadfx("env/fire/fx_fire_zombie_md");
		playFX(flameFX,self getTagOrigin("j_hand"));
		RadiusDamage(Crosshair,100,15,15,self);
	}
}
Test()
{
	self iPrintln("Function Test");
}
Toggle_God()
{
	if(self.God==false)
	{
		self iPrintln("GodMod [^2ON^7]");
		self.maxhealth=999999999;
		self.health=self.maxhealth;
		if(self.health<self.maxhealth)self.health=self.maxhealth;
		self enableInvulnerability();
		self.godenabled=true;
		self.God=true;
	}
	else
	{
		self iPrintln("GodMod [^1OFF^7]");
		self.maxhealth=100;
		self.health=self.maxhealth;
		self disableInvulnerability();
		self.godenabled=false;
		self.God=false;
	}
}
Toggle_Ammo()
{
	if(self.unlammo==false)
	{
		self thread MaxAmmo();
		self.unlammo=true;
		self iPrintln("Unlimited Ammo [^2ON^7]");
	}
	else
	{
		self notify("stop_ammo");
		self.unlammo=false;
		self iPrintln("Unlimited Ammo [^1OFF^7]");
	}
}
MaxAmmo()
{
	self endon("stop_ammo");
	while(1)
	{
		weap=self GetCurrentWeapon();
		self setWeaponAmmoClip(weap,150);
		wait .02;
	}
}
toggle_3ard()
{
	if(self.tard==false)
	{
		self.tard=true;
		self setclientthirdperson(1);
		self iPrintln("Third Person [^2ON^7]");
	}
	else
	{
		self.tard=false;
		self setclientthirdperson(0);
		self iPrintln("Third Person [^1OFF^7]");
	}
}
doMiniSpeed()
{
	if(self.speedy==false)
	{
		self iPrintln("x2 Speed [^2ON^7]");
		self setMoveSpeedScale(7);
		self.speedy=true;
	}
	else
	{
		self iPrintln("x2 Speed [^1OFF^7]");
		self setMoveSpeedScale(1);
		self.speedy=false;
	}
}
DoubleJump()
{
	if(self.DoubleJump==false)
	{
		self thread doDoubleJump();
		self iPrintln("Double Jump [^2ON^7]");
		self.DoubleJump=true;
	}
	else
	{
		self notify("DoubleJump");
		self.DoubleJump=false;
		self iPrintln("Double Jump [^1OFF^7]");
	}
}
doDoubleJump()
{
	self endon("death");
	self endon("disconnect");
	self endon("DoubleJump");
	for(;;)
	{
		if(self GetVelocity()[2]>150 && !self isOnGround())
		{
			wait .2;
			self setvelocity((self getVelocity()[0],self getVelocity()[1],self getVelocity()[2])+(0,0,250));
			wait .8;
		}
		wait .001;
	}
}
CloneMe()
{
	self iprintln("Clone ^2Spawned!");
	self ClonePlayer(9999);
}
toggle_invs()
{
	if(self.invisible==false)
	{
		self.invisible=true;
		self hide();
		self iPrintln("Invisible [^2ON^7]");
	}
	else
	{
		self.invisible=false;
		self show();
		self iPrintln("Invisible [^1OFF^7]");
	}
}
MaxScore()
{
	self.score+=21473140;
	self iprintln("Money ^2Gived");
}
doWeapon(i)
{
	self takeWeapon(self getCurrentWeapon());
	self GiveWeapon(i);
	self SwitchToWeapon(i);
	self GiveMaxAmmo(i);
	self iPrintln("Weapon "+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]+" ^2Gived");
}
doWeapon2(i)
{
	self GiveWeapon(i);
	self SwitchToWeapon(i);
	self GiveMaxAmmo(i);
	self iPrintln("Weapon "+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]+" ^2Gived");
}
TakeAll()
{
	self TakeAllWeapons();
	self iPrintln("All Weapons ^1Removed^7!");
}
doModel(i)
{
	self setModel(i);
	self iPrintln("Model Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
}
Toggle_Bullets()
{
	if(self.bullets==false)
	{
		self thread BulletMod();
		self.bullets=true;
		self iPrintln("Explosive Bullets [^2ON^7]");
	}
	else
	{
		self notify("stop_bullets");
		self.bullets=false;
		self iPrintln("Explosive Bullets [^1OFF^7]");
	}
}
BulletMod()
{
	self endon("stop_bullets");
	for(;;)
	{
		self waittill ("weapon_fired");
		Earthquake(0.5,1,self.origin,90);
		forward=self getTagOrigin("j_head");
		end=self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
		SPLOSIONlocation=BulletTrace(forward,end,0,self)["position"];
		RadiusDamage(SPLOSIONlocation,500,1000,500,self);
		playsoundatposition("evt_nuke_flash",SPLOSIONlocation);
		play_sound_at_pos("evt_nuke_flash",SPLOSIONlocation);
		Earthquake(2.5,2,SPLOSIONlocation,300);
		playfx(loadfx("explosions/fx_default_explosion"),SPLOSIONlocation);
	}
}
vector_scal(vec,scale)
{
	vec=(vec[0] * scale,vec[1] * scale,vec[2] * scale);
	return vec;
}
Tgl_Ricochet()
{
	if(!IsDefined(self.Ricochet))
	{
		self.Ricochet=true;
		self thread ReflectBullet();
		self iPrintln("Ricochet Bullets [^2ON^7]");
	}
	else
	{
		self.Ricochet=undefined;
		self notify("Rico_Off");
		self iPrintln("Ricochet Bullets [^1OFF^7]");
	}
}
ReflectBullet()
{
	self endon("Rico_Off");
	for(;;)
	{
		self waittill("weapon_fired");
		Gun=self GetCurrentWeapon();
		Incident=AnglesToForward(self GetPlayerAngles());
		Trace=BulletTrace(self GetEye(),self GetEye()+Incident * 100000,0,self);
		Reflection=Incident-(2 * trace["normal"] * VectorDot(Incident,trace["normal"]));
		MagicBullet(Gun,Trace["position"],Trace["position"]+(Reflection * 100000),self);
		for(i=0;i<1-1;i++)
		{
			Trace=BulletTrace(Trace["position"],Trace["position"]+(Reflection * 100000),0,self);
			Incident=Reflection;
			Reflection=Incident-(2 * Trace["normal"] * VectorDot(Incident,Trace["normal"]));
			MagicBullet(Gun,Trace["position"],Trace["position"]+(Reflection * 100000),self);
			wait 0.05;
		}
	}
}
TeleportGun()
{
	if(self.tpg==false)
	{
		self.tpg=true;
		self thread TeleportRun();
		self iPrintln("Teleporter Weapon [^2ON^7]");
	}
	else
	{
		self.tpg=false;
		self notify("Stop_TP");
		self iPrintln("Teleporter Weapon [^1OFF^7]");
	}
}
TeleportRun()
{
	self endon ("death");
	self endon ("Stop_TP");
	for(;;)
	{
		self waittill ("weapon_fired");
		self setorigin(BulletTrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,0,self)["position"]);
	}
}
doDefaultModelsBullets()
{
	if(self.bullets2==false)
	{
		self thread doactorBullets();
		self.bullets2=true;
		self iPrintln("Default Model Bullets [^2ON^7]");
	}
	else
	{
		self notify("stop_bullets2");
		self.bullets2=false;
		self iPrintln("Default Model Bullets [^1OFF^7]");
	}
}
doactorBullets()
{
	self endon("stop_bullets2");
	while(1)
	{
		self waittill ("weapon_fired");
		forward=self getTagOrigin("j_head");
		end=self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
		SPLOSIONlocation=BulletTrace(forward,end,0,self)["position"];
		M=spawn("script_model",SPLOSIONlocation);
		M setModel("defaultactor");
	}
}
doCarDefaultModelsBullets()
{
	if(self.bullets3==false)
	{
		self thread doacarBullets();
		self.bullets3=true;
		self iPrintln("Default Car Bullets [^2ON^7]");
	}
	else
	{
		self notify("stop_bullets3");
		self.bullets3=false;
		self iPrintln("Default Car Bullets [^1OFF^7]");
	}
}
doacarBullets()
{
	self endon("stop_bullets3");
	while(1)
	{
		self waittill ("weapon_fired");
		forward=self getTagOrigin("j_head");
		end=self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
		SPLOSIONlocation=BulletTrace(forward,end,0,self)["position"];
		M=spawn("script_model",SPLOSIONlocation);
		M setModel("defaultvehicle");
	}
}
UFOMode()
{
	if(self.UFOMode==false)
	{
		self thread doUFOMode();
		self.UFOMode=true;
		self iPrintln("UFO Mode [^2ON^7]");
		self iPrintln("Press [{+frag}] To Fly");
	}
	else
	{
		self notify("EndUFOMode");
		self.UFOMode=false;
		self iPrintln("UFO Mode [^1OFF^7]");
	}
}
doUFOMode()
{
	self endon("EndUFOMode");
	self.Fly=0;
	UFO=spawn("script_model",self.origin);
	for(;;)
	{
		if(self FragButtonPressed())
		{
			self playerLinkTo(UFO);
			self.Fly=1;
		}
		else
		{
			self unlink();
			self.Fly=0;
		}
		if(self.Fly==1)
		{
			Fly=self.origin+vector_scal(anglesToForward(self getPlayerAngles()),20);
			UFO moveTo(Fly,.01);
		}
		wait .001;
	}
}
Forge()
{
	if(!IsDefined(self.ForgePickUp))
	{
		self.ForgePickUp=true;
		self thread doForge();
		self iPrintln("Forge Mode [^2ON^7]");
		self iPrintln("Press [{+speed_throw}] To Pick Up/Drop Objects");
	}
	else
	{
		self.ForgePickUp=undefined;
		self notify("Forge_Off");
		self iPrintln("Forge Mode [^1OFF^7]");
	}
}
doForge()
{
	self endon("death");
	self endon("Forge_Off");
	for(;;)
	{
		while(self AdsButtonPressed())
		{
			trace=bullettrace(self gettagorigin("j_head"),self getTagOrigin("j_head")+anglesToForward(self getPlayerAngles()) * 1000000,true,self);
			while(self AdsButtonPressed())
			{
trace["entity"] ForceTeleport(self getTagOrigin("j_head")+anglesToForward(self getPlayerAngles()) * 200);
trace["entity"] setOrigin(self getTagOrigin("j_head")+anglesToForward(self getPlayerAngles()) * 200);
trace["entity"].origin=self getTagOrigin("j_head")+anglesToForward(self getPlayerAngles()) * 200;
wait .01;
			}
		}
		wait .01;
	}
}
SaveandLoad()
{
	if(self.SnL==0)
	{
		self iPrintln("Save and Load [^2ON^7]");
		self iPrintln("Press [{+actionslot 3}] To Save and Load Position!");
		self thread doSaveandLoad();
		self.SnL=1;
	}
	else
	{
		self iPrintln("Save and Load [^1OFF^7]");
		self.SnL=0;
		self notify("SaveandLoad");
	}
}
doSaveandLoad()
{
	self endon("disconnect");
	self endon("death");
	self endon("SaveandLoad");
	Load=0;
	for(;;)
	{
		if(self actionslotthreebuttonpressed()&& Load==0 && self.SnL==1)
		{
			self.O=self.origin;
			self.A=self.angles;
			self iPrintln("Position ^2Saved");
			Load=1;
			wait 2;
		}
		if(self actionslotthreebuttonpressed()&& Load==1 && self.SnL==1)
		{
			self setPlayerAngles(self.A);
			self setOrigin(self.O);
			self iPrintln("Position ^2Loaded");
			Load=0;
			wait 2;
		}
		wait .05;
	}
}
doProtecion()
{
	if(self.protecti==0)
	{
		self iPrintln("Skull Protector ^2Enabled");
		self thread PAWWAAProtec();
		self.protecti=1;
	}
	else
	{
		self iPrintln("Skull Protector ^1Disabled");
		self thread removeProtc();
		self.protecti=0;
		self notify("Stop_Skull");
	}
}
removeProtc()
{
	self.Skullix delete();
	self.SkullixFX delete();
}
PAWWAAProtec()
{
	self.Skullix=spawn("script_model",self.origin+(0,0,95));
	self.Skullix SetModel("zombie_skull");
	self.Skullix.angles=self.angles+(0,90,0);
	self.Skullix thread GFlic(self);
	self.Skullix thread PAWWAA(self);
	PlayFxOnTag(Loadfx("misc/fx_zombie_powerup_on"),self.Skullix,"tag_origin");
}
GFlic(PAWWAAv1)
{
	PAWWAAv1 endon("disconnect");
	PAWWAAv1 endon("death");
	PAWWAAv1 endon("Stop_Skull");
	for(;;)
	{
		self.origin=PAWWAAv1.origin+(0,0,95);
		self.angles=PAWWAAv1.angles+(0,90,0);
		wait .01;
	}
}
PAWWAA(PAWWAAv1)
{
	PAWWAAv1 endon("death");
	PAWWAAv1 endon("disconnect");
	PAWWAAv1 endon("Stop_Skull");
	for(;;)
	{
		Enemy=GetAiSpeciesArray("axis","all");
		for(i=0;i<Enemy.size;i++)
		{
			if(Distance(Enemy[i].origin,self.origin)<350)
			{
self.SkullixFX=spawn("script_model",self.origin);
self.SkullixFX SetModel("tag_origin");
self.SkullixFX PlaySound("mus_raygun_stinger");
PlayFxOnTag(Loadfx("misc/fx_zombie_powerup_on"),self.SkullixFX,"tag_origin");
self.SkullixFX MoveTo(Enemy[i] GetTagOrigin("j_head"),1);
wait 1;
Enemy[i] maps\mp\zombies\_zm_spawner::zombie_head_gib();
Enemy[i] DoDamage(Enemy[i].health+666,Enemy[i].origin,PAWWAAv1);
self.SkullixFX delete();
			}
		}
		wait .05;
	}
}
autoRevive()
{
	if(level.autoR==false)
	{
		level.autoR=true;
		self thread autoR();
		self iPrintln("Auto Revive [^2ON^7]");
	}
	else
	{
		level.autoR=false;
		self iPrintln("Auto Revive [^1OFF^7]");
		self notify("R_Off");
		self notify("R2_Off");
	}
}
autoR()
{
	self endon("R_Off");
	for(;;)
	{
		self thread ReviveAll();
		wait .05;
	}
}
ReviveAll()
{
	self endon("R2_Off");
	foreach(P in level.players)
	{
		if(IsDefined(P.revivetrigger))
		{
			P notify ("player_revived");
			P reviveplayer();
			P.revivetrigger delete();
			P.revivetrigger=undefined;
			P.ignoreme=false;
			P allowjump(1);
			P.laststand=undefined;
		}
	}
}
aarr649()
{
	if(self.drunk==true)
	{
		self iPrintln("Drunk Mode [^2ON^7]");
		self thread t649();
		wait 10;
		self thread l45();
		self.drunk=false;
	}
	else
	{
		self notify("lil");
		self setPlayerAngles(self.angles+(0,0,0));
		self setBlur(0,1.0);
		self iPrintln("Drunk Mode [^1OFF^7]");
		self.drunk=true;
	}
}
t649()
{
	weap=self GetCurrentWeapon();
	self.give_perks_over=false;
	self thread Give_Perks("649","zombie_perk_bottle_doubletap");
	self waittill("ready");
	self thread Give_Perks("649","zombie_perk_bottle_jugg");
	self waittill("ready");
	self thread Give_Perks("649","zombie_perk_bottle_revive");
	self waittill("ready");
	self thread Give_Perks("649","zombie_perk_bottle_sleight");
	self waittill("ready");
	self SwitchToWeapon(weap);
}
l45()
{
	self endon("lil");
	while(1)
	{
		self setPlayerAngles(self.angles+(0,0,0));
		self setstance("prone");
		wait (0.1);
		self SetBlur(10.3,1.0);
		self setPlayerAngles(self.angles+(0,0,5));
		self setstance("stand");
		wait (0.1);
		self SetBlur(9.1,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,10));
		wait (0.1);
		self setstance("prone");
		wait (0.1);
		self SetBlur(6.2,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,15));
		self setBlur(5.2,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,20));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,25));
		self setBlur(4.2,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,30));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,35));
		self setBlur(3.2,1.0);
		wait (0.1);
		self setstance("crouch");
		self setPlayerAngles(self.angles+(0,0,30));
		wait (0.1);
		self setstance("prone");
		self setPlayerAngles(self.angles+(0,0,25));
		self setBlur(2.2,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,20));
		wait (0.1);
		self setstance("crouch");
		self setPlayerAngles(self.angles+(0,0,15));
		self setBlur(1.2,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,10));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,5));
		self setBlur(0.5,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-5));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-10));
		self setBlur(0,1.0);
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-15));
		wait (0.1);
		self setstance("prone");
		self setPlayerAngles(self.angles+(0,0,-20));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-25));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-30));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-35));
		wait (0.1);
		self setstance("stand");
		self setPlayerAngles(self.angles+(0,0,-30));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-25));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-20));
		wait (0.1);
		self setstance("crouch");
		self setPlayerAngles(self.angles+(0,0,-15));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-10));
		wait (0.1);
		self setPlayerAngles(self.angles+(0,0,-5));
		wait .1;
	}
}
Give_Perks(Perk,Perk_Bottle)
{
	playsoundatposition("bottle_dispense3d",self.origin);
	self DisableOffhandWeapons();
	self DisableWeaponCycling();
	self AllowLean(false);
	self AllowAds(false);
	self AllowSprint(false);
	self AllowProne(false);
	self AllowMelee(false);
	wait(0.05);
	if (self GetStance()=="prone")
	{
		self SetStance("crouch");
	}
	weapon=Perk_Bottle;
	self SetPerk(Perk);
	self GiveWeapon(weapon);
	self SwitchToWeapon(weapon);
	self waittill("weapon_change_complete");
	self EnableOffhandWeapons();
	self EnableWeaponCycling();
	self AllowLean(true);
	self AllowAds(true);
	self AllowSprint(true);
	self AllowProne(true);
	self AllowMelee(true);
	self TakeWeapon(weapon);
	self notify("ready");
}
doKamikaze()
{
	self iPrintln("Kamikaze send to your ^2position");
	kam=spawn("script_model",self.origin+(5000,1000,10000));
	kam setmodel("defaultvehicle");
	kam.angles=VectorToAngles((kam.origin)-(self.origin))-(180,0,180);
	kam moveto(self.origin,3.5,2,1.5);
	kam waittill("movedone");
	Earthquake(2.5,2,kam.origin,300);
	playfx(level._effect["thunder"],kam.origin);
	playfx(loadfx("explosions/fx_default_explosion"),kam.origin);
	playfx(loadfx("explosions/fx_default_explosion"),kam.origin+(0,20,50));
	wait 0.1;
	playfx(loadfx("explosions/fx_default_explosion"),kam.origin);
	playfx(loadfx("explosions/fx_default_explosion"),kam.origin+(0,20,50));
	Earthquake(3,2,kam.origin,500);
	RadiusDamage(kam.origin,500,1000,300,self);
	kam delete();
}
toggle_gore2()
{
	if(self.gore==false)
	{
		self.gore=true;
		self iPrintln("Gore Mode [^2ON^7]");
		self thread Gore();
	}
	else
	{
		self.gore=false;
		self iPrintln("Gore Mode [^1OFF^7]");
		self notify("gore_off");
	}
}
Gore()
{
	foreach(player in level.players)
	{
		player endon("gore_off");
		for(;;)
		{
			playFx(level._effect["headshot"],player getTagOrigin("j_head"));
			playFx(level._effect["headshot"],player getTagOrigin("J_neck"));
			playFx(level._effect["headshot"],player getTagOrigin("J_Shoulder_LE"));
			playFx(level._effect["headshot"],player getTagOrigin("J_Shoulder_RI"));
			playFx(level._effect["bloodspurt"],player getTagOrigin("J_Shoulder_LE"));
			playFx(level._effect["bloodspurt"],player getTagOrigin("J_Shoulder_RI"));
			playFx(level._effect["headshot"],player getTagOrigin("J_Ankle_RI"));
			playFx(level._effect["headshot"],player getTagOrigin("J_Ankle_LE"));
			playFx(level._effect["bloodspurt"],player getTagOrigin("J_Ankle_RI"));
			playFx(level._effect["bloodspurt"],player getTagOrigin("J_Ankle_LE"));
			playFx(level._effect["bloodspurt"],player getTagOrigin("J_wrist_RI"));
			playFx(level._effect["bloodspurt"],player getTagOrigin("J_wrist_LE"));
			playFx(level._effect["headshot"],player getTagOrigin("J_SpineLower"));
			playFx(level._effect["headshot"],player getTagOrigin("J_SpineUpper"));
			wait .5;
		}
	}
}
Fr3ZzZoM()
{
	if(self.Fr3ZzZoM==false)
	{
		self iPrintln("Freeze Zombies [^2ON^7]");
		setdvar("g_ai","0");
		self.Fr3ZzZoM=true;
	}
	else
	{
		self iPrintln("Freeze Zombies [^1OFF^7]");
		setdvar("g_ai","1");
		self.Fr3ZzZoM=false;
	}
}
ZombieKill()
{
	zombs=getaiarray("axis");
	level.zombie_total=0;
	if(isDefined(zombs))
	{
		for(i=0;i<zombs.size;i++)
		{
			zombs[i] dodamage(zombs[i].health * 5000,(0,0,0),self);
			wait 0.05;
		}
		self doPNuke();
		self iPrintln("All Zombies ^1Eliminated");
	}
}
HeadLess()
{
	Zombz=GetAiSpeciesArray("axis","all");
	for(i=0;i<Zombz.size;i++)
	{
		Zombz[i] DetachAll();
	}
	self iPrintln("Zombies Are ^2Headless!");
}
Tgl_Zz2()
{
	if(!IsDefined(self.Zombz2CH))
	{
		self.Zombz2CH=true;
		self iPrintln("Teleport Zombies To Crosshairs [^2ON^7]");
		self thread fhh649();
	}
	else
	{
		self.Zombz2CH=undefined;
		self iPrintln("Teleport Zombies To Crosshairs [^1OFF^7]");
		self notify("Zombz2CHs_off");
	}
}
fhh649()
{
	self endon("Zombz2CHs_off");
	for(;;)
	{
		self waittill("weapon_fired");
		Zombz=GetAiSpeciesArray("axis","all");
		eye=self geteye();
		vec=anglesToForward(self getPlayerAngles());
		end=(vec[0] * 100000000,vec[1] * 100000000,vec[2] * 100000000);
		teleport_loc=BulletTrace(eye,end,0,self)["position"];
		for(i=0;i<Zombz.size;i++)
		{
			Zombz[i] forceTeleport(teleport_loc);
			Zombz[i] maps\mp\zombies\_zm_spawner::reset_attack_spot();
		}
		self iPrintln("All Zombies To ^2Crosshairs");
	}
}
ZombieDefaultActor()
{
	Zombz=GetAiSpeciesArray("axis","all");
	for(i=0;i<Zombz.size;i++)
	{
		Zombz[i] setModel("defaultactor");
	}
	self iPrintln("All Zombies Changed To ^2 Default Model");
}
ZombieCount()
{
	Zombies=getAIArray("axis");
	self iPrintln("Zombies ^1Remaining ^7: ^2"+Zombies.size);
}
max_round()
{
	self thread ZombieKill();
	level.round_number=250;
	self iPrintln("Round Set To ^1"+level.round_number+"");
	wait 2;
}
round_up()
{
	self thread ZombieKill();
	level.round_number=level.round_number+1;
	self iPrintln("Round Set To ^1"+level.round_number+"");
	wait .5;
}
round_down()
{
	self thread ZombieKill();
	level.round_number=level.round_number-1;
	self iPrintln("Round Set To ^1"+level.round_number+"");
	wait .5;
}
NormalBullets()
{
	self iPrintln("Modded Bullets [^1OFF^7]");
	self notify("StopBullets");
}
doBullet(A)
{
	self notify("StopBullets");
	self endon("StopBullets");
	self iPrintln("Bullets Type: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
	for(;;)
	{
		self waittill("weapon_fired");
		B=self getTagOrigin("tag_eye");
		C=self thread Bullet(anglestoforward(self getPlayerAngles()),1000000);
		D=BulletTrace(B,C,0,self)["position"];
		MagicBullet(A,B,D,self);
	}
}
Bullet(A,B)
{
	return (A[0]*B,A[1]*B,A[2]*B);
}
OpenAllTehDoors()
{
	setdvar("zombie_unlock_all",1);
	self give_money();
	wait 0.5;
	self iPrintln("Open all the doors ^2Success");
	Triggers=StrTok("zombie_doors|zombie_door|zombie_airlock_buy|zombie_debris|flag_blocker|window_shutter|zombie_trap","|");
	for(a=0;a<Triggers.size;a++)
	{
		Trigger=GetEntArray(Triggers[a],"targetname");
		for(b=0;b<Trigger.size;b++)
		{
			Trigger[b] notify("trigger");
		}
	}
	wait .1;
	setdvar("zombie_unlock_all",0);
}
give_money()
{
	self maps/mp/zombies/_zm_score::add_to_player_score(100000);
}
NoTarget()
{
	self.ignoreme=!self.ignoreme;
	if (self.ignoreme)
	{
		setdvar("ai_showFailedPaths",0);
	}
	if (self.ignoreme==1)
	{
		self iPrintln("Zombies Ignore Me [^2ON^7]");
	}
	if (self.ignoreme==0)
	{
		self iPrintln("Zombies Ignore Me [^1OFF^7]");
	}
}
doTeleportToMe()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't teleport the Host!");
	}
	else
	{
		player SetOrigin(self.origin);
		player iPrintln("Teleported to ^1"+player.name);
	}
	self iPrintln("^1"+player.name+" ^7Teleported to Me");
}
doTeleportToHim()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't teleport to the host!");
	}
	else
	{
		self SetOrigin(player.origin);
		self iPrintln("Teleported to ^1"+player.name);
	}
	player iPrintln("^1"+self.name+" ^7Teleported to Me");
}
PlayerFrezeControl()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't freez the host!");
	}
	else
	{
		if(self.fronzy==false)
		{
			self.fronzy=true;
			self iPrintln("^2Frozen: ^7"+player.name);
			player freezeControls(true);
		}
		else
		{
			self.fronzy=false;
			self iPrintln("^1Unfrozen: ^7"+player.name);
			player freezeControls(false);
		}
	}
}
ChiciTakeWeaponPlayer()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't take weapon the host!");
	}
	else
	{
		self iPrintln("Taken Weapons: ^1"+player.name);
		player takeAllWeapons();
	}
}
doGivePlayerWeapon()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't give weapon the host!");
	}
	else
	{
		self iPrintln("Given Weapons: ^1"+player.name);
		player GiveWeapon("m1911_zm");
		player SwitchToWeapon("m1911_zm");
		player GiveMaxAmmo("m1911_zm");
	}
}
kickPlayer()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("^1Fuck You Men !");
		kick(self getEntityNumber());
	}
	else
	{
		self iPrintln("^1 "+player.name+" ^7Has Been ^1Kicked ^7!");
		kick(player getEntityNumber());
	}
}
PlayerGiveGodMod()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't give godmod the host!");
	}
	else
	{
		if(self.godmodplater==false)
		{
			self.godmodplater=true;
			self iPrintln("^1"+player.name+" ^7GodMod [^2ON^7]");
			player Toggle_God();
		}
		else
		{
			self.godmodplater=false;
			self iPrintln("^1"+player.name+" ^7GodMod [^1OFF^7]");
			player Toggle_God();
		}
	}
}
doRevivePlayer()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't revive the host!");
	}
	else
	{
		self iPrintln("^1 "+player.name+" ^7Revive ^1!");
		player notify ("player_revived");
		player reviveplayer();
		player.revivetrigger delete();
		player.revivetrigger=undefined;
		player.ignoreme=false;
		player allowjump(1);
		player.laststand=undefined;
	}
}
doAllPlayersToMe()
{
	foreach(player in level.players)
	{
		if(player isHost())
		{
		}
		else
		{
			player SetOrigin(self.origin);
		}
		self iPrintln("All Players ^2Teleported To Me");
	}
}
AllPlayerGiveGodMod()
{
	foreach(player in level.players)
	{
		if(player isHost())
		{
		}
		else
		{
			if(self.godmodplater==false)
			{
self.godmodplater=true;
self iPrintln("All Players ^7GodMod [^2ON^7]");
player Toggle_God();
			}
			else
			{
self.godmodplater=false;
self iPrintln("All Players ^7GodMod [^1OFF^7]");
player Toggle_God();
			}
		}
	}
}
doDefaultTheme()
{
	self.Menu.Material["Background"] elemColor(1,(0,128,128));
	self.Menu.Material["Scrollbar"] elemColor(1,(0,128,128));
	self.Menu.Material["BorderMiddle"] elemColor(1,(0,128,128));
	self.Menu.Material["BorderLeft"] elemColor(1,(0,128,128));
	self.Menu.Material["BorderRight"] elemColor(1,(0,128,128));
	self.Menu.NewsBar["BorderUp"] elemColor(1,(0,128,128));
	self.Menu.NewsBar["BorderDown"] elemColor(1,(0,128,128));
	self.Menu.System["Title"] elemGlow(1,(0,128,128));
	self DefaultMenuSettings();
	self iPrintln("Theme Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
}
doBlue()
{
	self.Menu.Material["Background"] elemColor(1,(0,0,1));
	self.Menu.Material["Scrollbar"] elemColor(1,(0,0,1));
	self.Menu.Material["BorderMiddle"] elemColor(1,(0,0,1));
	self.Menu.Material["BorderLeft"] elemColor(1,(0,0,1));
	self.Menu.Material["BorderRight"] elemColor(1,(0,0,1));
	self.Menu.NewsBar["BorderUp"] elemColor(1,(0,0,1));
	self.Menu.NewsBar["BorderDown"] elemColor(1,(0,0,1));
	self.Menu.System["Title"] elemGlow(1,(0,0,1));
	self.glowtitre=(0,0,1);
	self iPrintln("Theme Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
}
doGreen()
{
	self.Menu.Material["Background"] elemColor(1,(0,1,0));
	self.Menu.Material["Scrollbar"] elemColor(1,(0,1,0));
	self.Menu.Material["BorderMiddle"] elemColor(1,(0,1,0));
	self.Menu.Material["BorderLeft"] elemColor(1,(0,1,0));
	self.Menu.Material["BorderRight"] elemColor(1,(0,1,0));
	self.Menu.NewsBar["BorderUp"] elemColor(1,(0,1,0));
	self.Menu.NewsBar["BorderDown"] elemColor(1,(0,1,0));
	self.Menu.System["Title"] elemGlow(1,(0,1,0));
	self.glowtitre=(0,1,0);
	self iPrintln("Theme Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System[" r"]]);
}
doYellow()
{
	self.Menu.Material["Background"] elemColor(1,(0,1,1));
	self.Menu.Material["Scrollbar"] elemColor(1,(0,1,1));
	self.Menu.Material["BorderMiddle"] elemColor(1,(0,1,1));
	self.Menu.Material["BorderLeft"] elemColor(1,(0,1,1));
	self.Menu.Material["BorderRight"] elemColor(1,(0,1,1));
	self.Menu.NewsBar["BorderUp"] elemColor(1,(0,1,1));
	self.Menu.NewsBar["BorderDown"] elemColor(1,(0,1,1));
	self.Menu.System["Title"] elemGlow(1,(0,1,1));
	self.glowtitre=(0,128,128);
	self iPrintln("Theme Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
}
doPink()
{
	self.Menu.Material["Background"] elemColor(1,(1,0,1));
	self.Menu.Material["Scrollbar"] elemColor(1,(1,0,1));
	self.Menu.Material["BorderMiddle"] elemColor(1,(1,0,1));
	self.Menu.Material["BorderLeft"] elemColor(1,(1,0,1));
	self.Menu.Material["BorderRight"] elemColor(1,(1,0,1));
	self.Menu.NewsBar["BorderUp"] elemColor(1,(1,0,1));
	self.Menu.NewsBar["BorderDown"] elemColor(1,(1,0,1));
	self.Menu.System["Title"] elemGlow(1,(1,0,1));
	self.glowtitre=(1,0,1);
	self iPrintln("Theme Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
}
doRed()
{
	self.Menu.Material["Background"] elemColor(1,(1,0,0));
	self.Menu.Material["Scrollbar"] elemColor(1,(1,0,0));
	self.Menu.Material["BorderMiddle"] elemColor(1,(1,0,0));
	self.Menu.Material["BorderLeft"] elemColor(1,(1,0,0));
	self.Menu.Material["BorderRight"] elemColor(1,(1,0,0));
	self.Menu.NewsBar["BorderUp"] elemColor(1,(1,0,0));
	self.Menu.NewsBar["BorderDown"] elemColor(1,(1,0,0));
	self.Menu.System["Title"] elemGlow(1,(1,0,0));
	self.glowtitre=(1,0,0);
	self iPrintln("Theme Changed To: ^2"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]);
}
doJetPack()
{
	if(self.jetpack==false)
	{
		self thread StartJetPack();
		self iPrintln("JetPack [^2ON^7]");
		self iPrintln("Press [{+gostand}] foruse jetpack");
		self.jetpack=true;	
	}
	else if(self.jetpack==true)
	{
		self.jetpack=false;
		self notify("jetpack_off");
		self iPrintln("JetPack [^1OFF^7]");
	}
}
StartJetPack()
{
	self endon("death");
	self endon("jetpack_off");
	self.jetboots= 100;
	for(i=0;;i++)
	{
		if(self jumpbuttonpressed() && self.jetboots>0)
		{
			playFX(level._effect["lght_marker_flare"],self getTagOrigin("J_Ankle_RI"));
			playFx(level._effect["lght_marker_flare"],self getTagOrigin("J_Ankle_LE"));
			earthquake(.15,.2,self gettagorigin("j_spine4"),50);
			self.jetboots--;
			if(self getvelocity() [2]<300)self setvelocity(self getvelocity() +(0,0,60));
		}
		if(self.jetboots<100 &&!self jumpbuttonpressed())self.jetboots++;
		wait .05;
	}
}
doPerks(a)
{
	self maps/mp/zombies/_zm_perks::give_perk(a);
	self iPrintln("Perk: "+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]+" ^2Gived");
}
doPNuke()
{
	foreach(player in level.players)
	{
		level thread maps\mp\zombies\_zm_powerups::nuke_powerup(self,player.team);
		player maps\mp\zombies\_zm_powerups::powerup_vo("nuke");
		zombies=getaiarray(level.zombie_team);
		player.zombie_nuked=arraysort(zombies,self.origin);
		player notify("nuke_triggered");
	}
	self iPrintln("Nuke Bomb ^2Send");
}
doPMAmmo()
{
	foreach(player in level.players)
	{
		level thread maps\mp\zombies\_zm_powerups::full_ammo_powerup(self,player);
		player thread maps\mp\zombies\_zm_powerups::powerup_vo("full_ammo");
	}
	self iPrintln("Max Ammo ^2Send");
}
doPDoublePoints()
{
	foreach(player in level.players)
	{
		level thread maps\mp\zombies\_zm_powerups::double_points_powerup(self,player);
		player thread maps\mp\zombies\_zm_powerups::powerup_vo("double_points");
	}
	self iPrintln("Double Points ^2Send");
}
doPInstaKills()
{
	foreach(player in level.players)
	{
		level thread maps\mp\zombies\_zm_powerups::insta_kill_powerup(self,player);
		player thread maps\mp\zombies\_zm_powerups::powerup_vo("insta_kill");
	}
	self iPrintln("Insta Kill ^2Send");
}
doNoSpawnZombies()
{
	if(self.SpawnigZombroz==false)
	{
		self.SpawnigZombroz=true;
		if(isDefined(flag_init("spawn_zombies", 0)))
		flag_init("spawn_zombies",0);
		self thread ZombieKill();
		self iPrintln("Disable Zombies [^2ON^7]");
	}
	else
	{
		self.SpawnigZombroz=false;
		if(isDefined(flag_init("spawn_zombies", 1)))
		flag_init("spawn_zombies",1);
		self thread ZombieKill();
		self iPrintln("Disable Zombies [^1OFF^7]");
	}
}
PlayerFrezeControl()
{
	player=level.players[self.Menu.System["ClientIndex"]];
	if(player isHost())
	{
		self iPrintln("You can't freez the host!");
	}
	else
	{
		if(self.fronzy==false)
		{
			self.fronzy=true;
			self iPrintln("^2Frozen: ^7"+player.name);
			player freezeControls(true);
		}
		else
		{
			self.fronzy=false;
			self iPrintln("^1Unfrozen: ^7"+player.name);
			player freezeControls(false);
		}
	}
}
doTeleportAllToMe()
{
	foreach(player in level.players)
	{
		if(player isHost())
		{
		}
		else
		{
			player SetOrigin(self.origin);
		}
	}
	self iPrintln("^2Teleported All to Me");
}
doFreeAllPosition()
{
	foreach(player in level.players)
	{
		if(player isHost())
		{
		}
		else
		{
			if(self.fronzya==false)
			{
self.fronzya=true;
self iPrintln("^2Frozen: ^7"+player.name);
player freezeControls(true);
			}
			else
			{
self.fronzya=false;
self iPrintln("^1Unfrozen: ^7"+player.name);
player freezeControls(false);
			}
		}
	}
}
doReviveAlls()
{
	foreach(player in level.players)
	{
		if(player isHost())
		{
		}
		else
		{
			self iPrintln("^1 "+player.name+" ^7Revive ^1!");
			player notify ("player_revived");
			player reviveplayer();
			player.revivetrigger delete();
			player.revivetrigger=undefined;
			player.ignoreme=false;
			player allowjump(1);
			player.laststand=undefined;
		}
	}
}
doMenuCenter()
{
	self.Menu.Material["Background"] elemMoveX(1,-90);
	self.Menu.Material["Scrollbar"] elemMoveX(1,-90);
	self.Menu.Material["BorderMiddle"] elemMoveX(1,-90);
	self.Menu.Material["BorderLeft"] elemMoveX(1,-91);
	self.Menu.Material["BorderRight"] elemMoveX(1,150);
	self.Menu.System["Title"] elemMoveX(1,-85);
	self.Menu.System["Texte"] elemMoveX(1,-85);
	self.textpos=-85;
	self iPrintln("Menu alling ^2center");
}
doAllKickPlayer()
{
	foreach(player in level.players)
	{
		if(player isHost())
		{
		}
		else
		{
			kick(player getEntityNumber());
		}
		self iPrintln("All Players ^1Kicked");
	}
}
forceHost()
{
	if(self.fhost==false)
	{
		self.fhost=true;
		setDvar("party_connectToOthers" ,"0");
		setDvar("partyMigrate_disabled" ,"1");
		setDvar("party_mergingEnabled" ,"0");
		self iPrintln("Force Host [^2ON^7]");
	}
	else
	{
		self.fhost=false;
		setDvar("party_connectToOthers" ,"1");
		setDvar("partyMigrate_disabled" ,"0");
		setDvar("party_mergingEnabled" ,"1");
		self iPrintln("Force Host [^1OFF^7]");
	}
}
doPlaySounds(i)
{
	self playsound(i);
	self iPrintln("Sound ^1"+self.Menu.System["MenuTexte"][self.Menu.System["MenuRoot"]][self.Menu.System["MenuCurser"]]+" ^2Played");
}
fastZombies()
{
	if(!isDefined(level.fastZombies))
	{
		if(isDefined(level.slowZombies)) level.slowZombies=undefined;
		level.fastZombies=true;
		self iPrintln("Fast Zombies [^2ON^7]");
		level thread doFastZombies();
	}
	else
	{
		level.fastZombies=undefined;
		self iPrintln("Fast Zombies [^1OFF^7]");
	}
}
doFastZombies()
{
	while(isDefined(level.fastZombies))
	{
		zom=getAiArray("axis");
		for(m=0;m<zom.size;m++) zom[m].run_combatanim=level.scr_anim["zombie"]["sprint"+randomIntRange(1,2)];
		wait .05;
	}
}
slowZombies()
{
	if(!isDefined(level.slowZombies))
	{
		if(isDefined(level.fastZombies)) level.fastZombies=undefined;
		level.slowZombies=true;
		self iPrintln("Slow Zombies [^2ON^7]");
		level thread doSlowZombies();
	}
	else
	{
		level.slowZombies=undefined;
		self iPrintln("Slow Zombies [^1OFF^7]");
	}
}
doSlowZombies()
{
	while(isDefined(level.slowZombies))
	{
		zom=getAiArray("axis");
		for(m=0;m<zom.size;m++) zom[m].run_combatanim=level.scr_anim["zombie"]["walk"+randomIntRange(1,4)];
		wait .05;
	}
}

DoUseMessages(message)
{
self iprintlnbold(message);
self iprintln("^6Press ^14 ^2To ^3Open ^4This ^5menu ^7, ^8and ^9move ^1whit ^2your ^3Mouse ^4click ^5enjoy ^6!");
}

DoPawwaaMessages(message)
{
self iprintlnbold(message);
self iprintln("^6Tout Facon PAWWAA on et d'accord ^6!");
}

DoQuoicouMessages(message)
{
self iprintlnbold(message);
self iprintln("^6UwU ^2& ^2Bissous!");
}

DoPainauMessages(message)
{
self iprintlnbold(message);
self iprintln("^2Pain au Chocolate! <3 ++");
}

DoZiziMessages(message)
{
self iprintlnbold(message);
self iprintln("^18==^6B  Et ouai tu est dessus c'est juste une bite tu peux continuer ta game ma poulette ;)");
}

DoUseBzezRebbecca(message)
{
self iprintlnbold(message);
self iprintln("^3Pas d'idée pour ce message la mes on et la mon reuf");
}


