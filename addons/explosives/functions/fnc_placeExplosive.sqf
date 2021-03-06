/*
 * Author: Garth 'L-H' de Wet
 * Places an explosive at the requested position
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Position to place explosive <POSITION>
 * 2: Rotation <NUMBER>
 * 3: Magazine class <STRING>
 * 4: Config of trigger <STRING>
 * 5: Variables required for the trigger type <ARRAY>
 * 6: Explosive placeholder <OBJECT> <OPTIONAL>
 *
 * Return Value:
 * Placed explosive <OBJECT>
 *
 * Example:
 * _explosive = [player, player modelToWorldVisual [0,0.5, 0.1], 134,
 *  "SatchelCharge_Remote_Mag", "Command", []] call ACE_Explosives_fnc_placeExplosive;
 *
 * Public: Yes
 */
#include "script_component.hpp"
private ["_ammo", "_explosive"];
EXPLODE_6_PVT(_this,_unit,_pos,_dir,_magazineClass,_triggerConfig,_triggerSpecificVars);
if (count _this > 6) then {
    deleteVehicle (_this select 6);
};

if (isNil "_triggerConfig") exitWith {
    diag_log format ["ACE_Explosives: Error config not passed to PlaceExplosive: %1", _this];
    objNull
};

_magazineTrigger = ConfigFile >> "CfgMagazines" >> _magazineClass >> "ACE_Triggers" >> _triggerConfig;
_triggerConfig = ConfigFile >> "ACE_Triggers" >> _triggerConfig;

if (isNil "_triggerConfig") exitWith {
    diag_log format ["ACE_Explosives: Error config not found in PlaceExplosive: %1", _this];
    objNull
};

_ammo = getText(ConfigFile >> "CfgMagazines" >> _magazineClass >> "ammo");
if (isText(_magazineTrigger >> "ammo")) then {
    _ammo = getText (_magazineTrigger >> "ammo");
};
_triggerSpecificVars pushBack _triggerConfig;
private ["_defuseHelper"];
_defuseHelper = createVehicle ["ACE_DefuseObject", _pos, [], 0, "NONE"];
_defuseHelper setPosATL _pos;

_explosive = createVehicle [_ammo, _pos, [], 0, "NONE"];
_defuseHelper attachTo [_explosive, [0,0,0], ""];
_defuseHelper setVariable [QGVAR(Explosive),_explosive,true];

_expPos = getPosATL _explosive;
_defuseHelper setPosATL (((getPosATL _defuseHelper) vectorAdd (_pos vectorDiff _expPos)));
_explosive setPosATL _pos;

if (isText(_triggerConfig >> "onPlace") && {[_unit,_explosive,_magazineClass,_triggerSpecificVars]
    call compile (getText (_triggerConfig >> "onPlace"))}) exitWith {_explosive};
[[_explosive, _dir, getNumber (_magazineTrigger >> "pitch")], QFUNC(setPosition)] call EFUNC(common,execRemoteFnc);
_explosive
