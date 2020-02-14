start
  = name:ListName pts:Points faction:Faction author:Author commander:Commander objectives:Objectives? ships:Ship* sqd:Squadrons {
    var points = pts.points;
    var max_points = pts.max_points;

    var squadrons = sqd.squads;
    var squadron_points = sqd.points;

    if ( ! objectives ) { objectives =  []; }

    return {name, author, faction, points, max_points, squadron_points, commander, objectives, ships, squadrons};
  }

ListName
  = name:Name [ \n\t]* { return name; }

Author
  = "Author:" _ name:Name _ [\n]* { return name; }

Faction
  = value:FactionValue _ "-" _ { return value; }

FactionValue
  = RebelFaction / ImperialFaction

ImperialFaction
  = "Empire" { return "Galactic Empire"; }

RebelFaction
  = "Rebels" { return "Rebel Alliance"; }

Points
  = _ "(" points:Integer "/" max_points:Integer ")" [ \n\t]* { return {points, max_points}; }

Commander
  = "Commander:" _ name:CardName [\n]* { return name; }

Objectives
  = "Objectives:" _ objs:(AssaultObjective DefenseObjective NavigationObjective) [\n]* { return objs; }

AssaultObjective
  = _ name:Name "," _ [\n]* {
    var type = "Assault";
    return {type, name};
  }

DefenseObjective
  = _ name:Name "," _ [\n]* {
    var type = "Defense";
    return {type, name};
  }

NavigationObjective
  = _ name:Name _ [\n]* {
    var type = "Navigation";
    return {type, name};
  }

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
  = "=" _ totalCost:Integer _ "total points" _ [\n]? { return totalCost; }

Squadrons
  = "Squadrons (" points:Integer "/" Integer "):" [\n]* squads:Squadron* _ [\n]? { return {squads, points}; }

Squadron
  = count:Integer "x" _ name:CardName _ cost:Cost _ [\n]? { return {count, name, cost}; }

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
