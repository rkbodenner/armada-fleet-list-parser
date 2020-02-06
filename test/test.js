const fs = require("fs");
const assert = require("assert");

const parser = require("../armada-warlords-fleet.js");

describe("Armada Warlords", function() {
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
