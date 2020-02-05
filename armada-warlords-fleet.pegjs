start
  = Commander Objectives Ship*

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

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
