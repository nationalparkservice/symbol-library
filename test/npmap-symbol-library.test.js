const fs = require('fs');
const test = require('tap').test;

const renderedPath = __dirname + '/../renders/sheilded/';
const inputPath = __dirname + '/../src/shielded/';
const sizes = [14, 22, 30];

test('NPMap Symbol Library', function (t) {
  let jsonStandalone;

  t.doesNotThrow(function () {
    jsonStandalone = JSON.parse(fs.readFileSync(renderedPath + '/sprite@2.json'));
  }, 'Standalone JSON is invalid');
  jsonStandalone.forEach(function (f) {
    t.equal(typeof f.name, 'string', 'name property');
    t.equal(typeof f.icon, 'string', 'icon property');
    t.equal(typeof f.release, 'string', 'release property');
    t.equal(typeof f.tags, 'object', 'tags property');
    sizes.forEach(function (size) {
      t.doesNotThrow(function () {
        fs.statSync(inputPath + f.icon + '-' + size + '.svg');
      }, 'source file present');
    });
  });
  t.end();
});
