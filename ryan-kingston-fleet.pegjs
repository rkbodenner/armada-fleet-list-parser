start
  = ListName Faction Commander Objectives Ship* Squadrons Points

ListName
  = _ "Name:" _ name:Name [ \n\t]* { return name; }

Faction
  = _ "Faction:" _ value:FactionValue _ [\n]* { return value; }

FactionValue
  = "Rebel"/"Imperial"

Commander
  = "Commander:" _ name:CardName [\n]* { return name; }

Objectives
  = objs:(Objective Objective Objective) [\n]* { return objs; }

Objective
  = type:ObjectiveType ":" _ name:Name _ [\n]* { return {type: type, name: name}; }

ObjectiveType
  = "Assault"/"Defense"/"Navigation"

Ship
  = shipVar:ShipVariant upg:Upgrade* cost:TotalCost [\n]* { return {shipVar, upg, cost}; }

ShipVariant
  = name:Name _ cost:Cost _ [\n]? { return {name: name, cost: cost}; }

Upgrade
  = "•" _ name:CardName _ cost:Cost _ [\n]? { return {name: name, cost: cost}; }

Cost
  = "(" _ cost:Integer _ ")" _ [\n]? { return cost; }

TotalCost
  = "=" _ totalCost:Integer _ "Points" _ [\n]? { return totalCost; }

Squadrons
  = "Squadrons:" [\n]* squads:Squadron* totalSquadronCost:TotalCost _ [\n]? { return {squads, totalSquadronCost}; }

Squadron
  = "•" _ count:SquadronCount? _ name:CardName _ cost:Cost _ [\n]? {
    if ( count === null ) {
      count = 1;
    }
    cost = cost / count;
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
  = chars:[-_a-zA-Z0-9!]+ _ { return chars.join(""); }

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
