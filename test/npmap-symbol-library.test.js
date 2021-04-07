/* globals require __dirname */

const fs = require('fs');
const test = require('tap').test;

const renderedPath = __dirname + '/../renders/shielded/';
const inputPath = __dirname + '/../src/shielded/';

test('NPMap Symbol Library', function (t) {
  let jsonShielded;

  t.doesNotThrow(function () {
    jsonShielded = JSON.parse(fs.readFileSync(renderedPath + 'symbol-library@2x.json'));
  }, 'Shielded JSON file is invalid');
  Object.keys(jsonShielded).forEach(function (key) {
    let f = jsonShielded[key];
    t.equal(typeof key, 'string', 'name property');
    t.equal(typeof f.width, 'number', 'width property');
    t.equal(typeof f.height, 'number', 'height property');
    t.equal(typeof f.x, 'number', 'x property');
    t.equal(typeof f.y, 'number', 'y property');
    t.equal(typeof f.pixelRatio, 'number', 'pixelRatioproperty');
    t.doesNotThrow(function () {
      fs.statSync(inputPath + key + '.svg');
    }, 'source file present');
  });
  t.end();
});
