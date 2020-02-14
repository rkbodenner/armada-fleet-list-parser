# armada-fleet-list-parser
Parse fleet lists for Star Wars: Armada

This module includes parsers for the text export formats used by some popular list-building apps for Armada:
- Ryan Kingston's Armada Fleet Builder (https://armada.ryankingston.com)
- Armada Fleet Builder, an iOS and Android app
- Armada Warlords (https://armadawarlords.hivelabs.solutions)
- Flagship (https://flagship.barronsoftware.com)
- Armada Fleets Designer, a web and Android app (https://swm-dmb.blogspot.com)

The parsers return a JSON structure encoding the fleet list, including ships, upgrades, squadrons, objectives, and other data.

A goal of this project is to create increasingly consistent output from a larger number of export formats. Though the different apps export different data to some degree, these parsers attempt to normalize the output into a consistent schema, so that a fleet generated with any of the apps will produce (mostly) the same JSON.

## Prerequisites
1. Node and npm
1. npm modules: `pegjs`, `mocha` (for testing)

## Generating parsers
Parsers are written in a parsing expression grammar, which `pegjs` turns into a JavaScript class implementing a parser. For example:

  `pegjs armada-warlords-fleet.pegjs`

will produce `armada-warlords-fleet.js`, which implements the parser for Armada Warlords.

## Using a parser
See `test/test.js` for examples.

## Testing
Just run `npm test`.

## Legal
All the Star Wars stuff is Copyright & Trademark Lucasfilm Ltd. Please Lord, don't let The Mouse sue me.
