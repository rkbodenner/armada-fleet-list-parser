{
  function extractSquadsFromShips(ships, squads, squad_points) {
    if (!ships || !squads || !squad_points ) { return 0; }

    var pointsMoved = 0;
    squads.forEach(function(squad) {
      pointsMoved += squad.points * squad.count;
    });

    while ( pointsMoved < squad_points ) {
      var moved = ships.pop();
      var squad = { count:1, name:moved.ship_class.name, points:moved.points };
      squads.push(squad);
      pointsMoved += moved.points;
    }

    return pointsMoved;
  }
}

start
  = name:ListName pts:Points "="* [\n]* ships:Ship* squadrons:Squadron* objectives:Objectives  {
    var squadron_points = pts.squad_points;
    var points = pts.points;
    var max_points = pts.max_points;

	  var p = extractSquadsFromShips(ships, squadrons, squadron_points);

    return {name, points, max_points, squadron_points, objectives, ships, squadrons};
  }

ListName
  = name:Name _ { return name; }

Points
  = "(" squad_points:Integer "/" points:Integer "/" max_points:Integer ")" [ \n\t]* { return {squad_points, points, max_points}; }

Commander
  = "Commander:" _ name:CardName [\n]* { return name; }

Objectives
  = objs:(AssaultObjective DefenseObjective NavigationObjective) [\n]* { return objs; }

AssaultObjective
  = _ name:Name _ [\n]* {
    var type = "Assault";
    return {type, name};
  }

DefenseObjective
  = _ name:Name _ [\n]* {
    var type = "Defense";
    return {type, name};
  }

NavigationObjective
  = _ name:Name _ [\n]* {
    var type = "Navigation";
    return {type, name};
  }

Ship
  = ship_class:ShipClass points:TotalCost? ")" [\n]* upgrades:Upgrade* [\n]* {
      if ( points === null ) {
        points = ship_class.points;
      }
      return { ship_class, upgrades, points };
    }

ShipClass
  = name:Name _ "(" points:Integer { return { name, points }; }

Upgrade
  = _ "+" _ name:CardName _ points:UpgradeCost _ [\n]? { return {name, points}; }

TotalCost
  = _ "+" _ Integer _ ":" _ cost:Integer {
      return cost;
    }

UpgradeCost
  = "(" cost:Integer ")" [\n]? { return cost; }

Squadron
  = count:Integer _ "x" _ name:CardName _ points:SquadronCost _ [\n]? { return {count, name, points}; }

SquadronCost
  = "(" Integer _ "x" _ cost:Integer ")" [\n]? { return cost; }

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
