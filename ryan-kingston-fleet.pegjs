start
  = name:ListName faction:Faction commander:Commander objectives:Objectives ships:Ship* sqd:Squadrons pts:Points {
    var points = pts.points;

    var squadrons = sqd.squads;
    var squadron_points = sqd.points;

    return {name, faction, points, squadron_points, objectives, ships, squadrons};
  }

ListName
  = _ "Name:" _ name:Name [ \n\t]* { return name; }

Faction
  = _ "Faction:" _ value:FactionValue _ [\n]* { return value; }

FactionValue
  = RebelFaction / ImperialFaction

ImperialFaction
  = "Imperial" { return "Galactic Empire"; }

RebelFaction
  = "Rebel" { return "Rebel Alliance"; }

Commander
  = "Commander:" _ name:CardName [\n]* { return name; }

Objectives
  = objs:(Objective Objective Objective) [\n]* { return objs; }

Objective
  = type:ObjectiveType ":" _ name:Name _ [\n]* { return {type: type, name: name}; }

ObjectiveType
  = "Assault"/"Defense"/"Navigation"

Ship
  = ship_class:ShipClass upgrades:Upgrade* points:TotalCost [\n]* { return {ship_class, upgrades, points}; }

ShipClass
  = name:Name _ points:Cost _ [\n]? { return {name, points}; }

Upgrade
  = "•" _ name:CardName _ points:Cost _ [\n]? { return {name, points}; }

Cost
  = "(" _ cost:Integer _ ")" _ [\n]? { return cost; }

TotalCost
  = "=" _ totalCost:Integer _ "Points" _ [\n]? { return totalCost; }

Squadrons
  = "Squadrons:" [\n]* squads:Squadron* points:TotalCost _ [\n]? { return {squads, points}; }

Squadron
  = "•" _ count:SquadronCount? _ name:CardName _ cost:Cost _ [\n]? {
    if ( count === null ) {
      count = 1;
    }
    return {name, count, cost};
  }

SquadronCount
  = count:Integer _ "x" { return count; }

SquadronCost
  = "=" _ cost:Integer _ "total squadron cost" [\n]* { return cost; }

Points
  = "Total Points:" _ points:Integer [ \n\t]* { return {points}; }

CardName
  = Name

Name
  = words:(NameWord)* [ \n\t]* { return words.join(" "); }

NameWord
  = chars:[-_a-zA-Z0-9!']+ _ { return chars.join(""); }

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
