// by CAA-Picard

#include "script_component.hpp"

visibleMap &&
{alive ACE_player} &&
{"ItemMap" in (assignedItems ACE_player)} &&
{"ACE_MapTools" in (items ACE_player)} &&
{!GVAR(mapTool_isDragging)} &&
{!GVAR(mapTool_isRotating)}
