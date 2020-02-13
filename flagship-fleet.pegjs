start
  = name:ListName author:Author faction:Faction commander:Commander objectives:Objectives ships:Ship* sqd:Squadrons {
    var squadrons = sqd.squads;
    var squadron_points = sqd.points;

    return {name, author, faction, squadron_points, commander, objectives, ships, squadrons};
  }

ListName
  = name:Name [ \n\t]* { return name; }

Author
  = "Author:" _ name:Name _ [\n]* { return name; }

Faction
  = "Faction:" _ value:FactionValue _ [\n]* { return value; }

FactionValue
  = RebelFaction / ImperialFaction

ImperialFaction
  = "Empire" { return "Galactic Empire"; }

RebelFaction
  = "Rebels" { return "Rebel Alliance"; }

Points
  = "Points:" _ points:Integer "/" max_points:Integer [ \n\t]* { return {points, max_points}; }

Commander
  = "Commander:" _ name:CardName [\n]* { return name; }

Objectives
  = objs:(Objective Objective Objective) [\n]* { return objs; }

Objective
  = type:ObjectiveType _ "Objective:" _ name:Name _ [\n]* { return {type: type, name: name}; }

ObjectiveType
  = "Assault"/"Defense"/"Navigation"

Ship
  = flagship:Flagship? ship_class:ShipClass upgrades:Upgrade* points:TotalCost [\n]* {
    if (flagship) { return { flagship, ship_class, upgrades, points }; }
    else          { return {           ship_class, upgrades, points }; }
  }

Flagship
  = "[" _ "flagship" _ "]" _ { return true; }

ShipClass
  = name:Name _ points:Cost _ [\n]? { return {name: name, points: points}; }

Upgrade
  = "-" _ name:CardName _ points:Cost _ [\n]? { return {name: name, points: points}; }

Cost
  = "(" _ cost:Integer _ ")" _ [\n]? { return cost; }

TotalCost
  = "=" _ totalCost:Integer _ "points" _ [\n]? { return totalCost; }

Squadrons
  = squads:Squadron* points:TotalCost _ [\n]? { return {squads, points}; }

Squadron
  = count:Integer _ name:CardName _ cost:Cost _ [\n]? { return {count, name, cost}; }

NameVariant
  = "com"/"off"

CardName
  = name:Name _ variant:(("(" NameVariant ")")?) {
  	if (variant) {
      return name.concat(" ", variant.join(""));
    } else {
      return name;
    }
  }

Name
  = words:(NameWord)* [ \n\t]* { return words.join(" "); }

NameWord
  = chars:[-_a-zA-Z0-9!']+ _ { return chars.join(""); }

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
