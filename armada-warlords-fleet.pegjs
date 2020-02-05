start
  = ListName Author Faction Points Commander Objectives Ship*

ListName
  = name:AuthorName [ \n\t]* { return name; }

Author
  = "Author:" _ name:AuthorName _ [\n]* { return name; }

Faction
  = "Faction:" _ value:FactionValue _ [\n]* { return value; }

FactionValue
  = "Rebel Alliance"/"Galactic Empire"

Points
  = "Points:" _ points:Integer "/" max:Integer [ \n\t]* { return {points, max}; }

Commander
  = "Commander:" _ name:Name [\n]* { return name; }

Objectives
  = Objective Objective Objective [\n]*

Objective
  = type:ObjectiveType _ "Objective:" _ name:Name _ [\n]? { return {type: type, name: name}; }

ObjectiveType
  = "Assault"/"Defense"/"Navigation"

Ship
  = shipVar:ShipVariant upg:Upgrade* cost:TotalCost [\n]* { return {shipVar: shipVar, upg: upg, cost: cost}; }

ShipVariant
  = name:Name _ cost:Cost _ [\n]? { return {name: name, cost: cost}; }

Upgrade
  = "-" _ name:Name _ cost:Cost _ [\n]? { return {name: name, cost: cost}; }

Cost
  = "(" _ cost:Integer _ "points)" _ [\n]? { return cost; }

TotalCost
  = "=" _ totalCost:Integer _ "total ship cost" _ [\n]? { return totalCost; }

NameVariant
  = "com"/"off"

Name
  = [-a-zA-Z0-9! ]+ _ ("(" NameVariant ")")? { return text(); }

AuthorName
  = [-_a-zA-Z0-9! ]+ { return text(); }

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
