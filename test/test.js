const fs = require("fs");
const assert = require("assert");

const warlordsParser = require("../armada-warlords-fleet.js");
const kingstonParser = require("../ryan-kingston-fleet.js");

describe("Armada Warlords", function() {
  var parser = warlordsParser;
  describe("Well-formed lists", function() {
    it("Should parse squadless", function() {
      var list = fs.readFileSync("test/squadless.txt");
      assert.doesNotThrow(() => {
        parser.parse(list.toString("utf8"));
      });
    });
  });

  describe("Malformed lists", function() {
    it("Should not parse no-commander", function() {
      var list = fs.readFileSync("test/failures/no-commander.txt");
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
  });
});
