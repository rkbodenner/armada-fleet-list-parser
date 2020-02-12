const fs = require("fs");
const assert = require("assert");

const warlordsParser = require("../armada-warlords-fleet.js");
const kingstonParser = require("../ryan-kingston-fleet.js");

describe("Armada Warlords", function() {
  var parser = warlordsParser;
  describe("Well-formed lists", function() {
    it("Should parse squadless", function() {
      var list = fs.readFileSync("test/warlords/squadless.txt");
      assert.doesNotThrow(() => {
        parser.parse(list.toString("utf8"));
      });
    });
    it("Should parse dumpster-fire-mk-18", function() {
      var list = fs.readFileSync("test/warlords/dumpster-fire-mk-18.txt");
      assert.doesNotThrow(() => {
        parser.parse(list.toString("utf8"));
      });
    });
  });

  describe("Malformed lists", function() {
    it("Should not parse no-commander", function() {
      var list = fs.readFileSync("test/warlords/failures/no-commander.txt");
      assert.throws(() => {
        parser.parse(list.toString("utf8"));
      });
    });
  });
});

describe("Ryan Kingston's", function() {
  var parser = kingstonParser;
  describe("Well-formed lists", function() {
    it("Should parse starhawk", function() {
      var list = fs.readFileSync("test/ryan-kingston/starhawk.txt");
      assert.doesNotThrow(() => {
        parser.parse(list.toString("utf8"));
      });
    });
    it("Should parse no-obj-no-com-multi-squad", function() {
      var list = fs.readFileSync("test/ryan-kingston/no-obj-no-com-multi-squad.txt");
      assert.doesNotThrow(() => {
        parser.parse(list.toString("utf8"));
      });
    });
  });
});

describe("Data format consistency", function() {
  describe("Dumpster fire", function() {
    it("Should produce consistent output with Kingston and Warlords versions", function() {
      var kingstonList = fs.readFileSync("test/ryan-kingston/dumpster-fire-mk-18.txt");
      var kingstonFleet = kingstonParser.parse(kingstonList.toString("utf8"));

      var warlordsList = fs.readFileSync("test/warlords/dumpster-fire-mk-18.txt");
      var warlordsFleet = warlordsParser.parse(warlordsList.toString("utf8"));

      // Warlords removes apostrophes from names! Normalize Kingston to match.
      kingstonFleet.ships.forEach(function(ship) {
        ship.upgrades.forEach(function(upgrade) {
          upgrade.name = upgrade.name.replace("'","");
        });
      });

      // Warlords pluralizes squadron names. Normalize to the singular.
      warlordsFleet.squadrons.forEach(function(squad) {
        squad.name = squad.name.replace("Squadrons", "Squadron");
      });

      // Warlords capitalizes "wing" in "X-wing". Normalize to the name as printed on the card.
      warlordsFleet.squadrons.forEach(function(squad) {
        squad.name = squad.name.replace("-Wing", "-wing");
      });

      // Kingston uses shorthand for some ship classes. Use the full names.
      kingstonFleet.ships.forEach(function(ship) {
        if ( ship.ship_class.name === "Pelta Command Ship" ) {
          ship.ship_class.name = "Modified Pelta-class Command Ship";
        }
      });

      // Remove properties that Kingston doesn't include
      warlordsFleet.ships.forEach(function(ship) {
        delete ship.flagship;
      });

      // Order of upgrades is not guaranteed to match
      [kingstonFleet,warlordsFleet].forEach(function(fleet) {
        fleet.ships.forEach(function(ship) {
          ship.upgrades.sort(function(a,b) {
            return ('' + a.name).localeCompare(b.name);
          });
        });
      });

      var matchingProps = [
        'name',
        'faction',
        'points',
        'squadron_points',
        'objectives',
        'ships',
        'squadrons'
      ];
      matchingProps.forEach(function(property){
        assert.deepStrictEqual(kingstonFleet[property], warlordsFleet[property]);
      });
    });
  });
});
