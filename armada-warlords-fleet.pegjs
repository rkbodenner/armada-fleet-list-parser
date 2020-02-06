start
  = ListName Author Faction Points Commander Objectives Ship* Squadrons

ListName
  = name:Name [ \n\t]* { return name; }

Author
  = "Author:" _ name:Name _ [\n]* { return name; }

Faction
  = "Faction:" _ value:FactionValue _ [\n]* { return value; }

FactionValue
  = "Rebel Alliance"/"Galactic Empire"

Points
  = "Points:" _ points:Integer "/" max:Integer [ \n\t]* { return {points, max}; }

Commander
  = "Commander:" _ name:CardName [\n]* { return name; }

Objectives
  = objs:(Objective Objective Objective) [\n]* { return objs; }

Objective
  = type:ObjectiveType _ "Objective:" _ name:Name _ [\n]* { return {type: type, name: name}; }

ObjectiveType
  = "Assault"/"Defense"/"Navigation"

Ship
  = flagship:Flagship? shipVar:ShipVariant upg:Upgrade* cost:TotalCost [\n]* { return {flagship, shipVar, upg, cost}; }

Flagship
  = "[" _ "flagship" _ "]" _ { return true; }

ShipVariant
  = name:Name _ cost:Cost _ [\n]? { return {name: name, cost: cost}; }

Upgrade
  = "-" _ name:CardName _ cost:Cost _ [\n]? { return {name: name, cost: cost}; }

Cost
  = "(" _ cost:Integer _ "points)" _ [\n]? { return cost; }

TotalCost
  = "=" _ totalCost:Integer _ "total ship cost" _ [\n]? { return totalCost; }

Squadrons
  = squads:Squadron* totalSquadronCost:SquadronCost _ [\n]? { return {squads, totalSquadronCost}; }

Squadron
  = count:Integer _ name:CardName _ cost:Cost _ [\n]? { return {count, name, cost}; }

SquadronCost
  = "=" _ cost:Integer _ "total squadron cost" [\n]* { return cost; }

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
  = chars:[-_a-zA-Z0-9!]+ _ { return chars.join(""); }

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
