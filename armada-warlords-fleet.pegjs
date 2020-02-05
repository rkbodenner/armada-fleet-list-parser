start
  = ship:Ship*

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

Name
  = [-a-zA-Z0-9! ]+ { return text(); }

Integer "integer"
  = [0-9]+ { return parseInt(text(), 10); }

_ "whitespace"
  = [ \t]*
  
