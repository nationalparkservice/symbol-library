/* globals __dirname require */
const spritezero = require('@mapbox/spritezero');
const fs = require('fs');
const glob = require('glob');
const path = require('path');
const ratios = [1, 2, 4];
const inputPath = '/src/shielded/';
const outputPath = '/renders/shielded/';
const spriteName = 'symbol-library';

ratios.forEach(function(pxRatio) {
  console.log(path.join(__dirname, inputPath, '*.svg'));
  let svgs = glob.sync(path.resolve(path.join(__dirname, inputPath, '*.svg')))
    .map(function(f) {
      console.log(f);
      return {
        svg: fs.readFileSync(f),
        id: path.basename(f).replace('.svg', '')
      };
    });
  let pngPath = path.resolve(path.join(__dirname, outputPath, '/' + spriteName + '@' + pxRatio + 'x.png'));
  let jsonPath = path.resolve(path.join(__dirname, outputPath, '/' + spriteName + '@' + pxRatio + 'x.json'));

  // Pass `true` in the layout parameter to generate a data layout
  // suitable for exporting to a JSON sprite manifest file.
  spritezero.generateLayout({ imgs: svgs, pixelRatio: pxRatio, format: true }, function(err, dataLayout) {
    if (err) return;
    fs.writeFileSync(jsonPath, JSON.stringify(dataLayout));
  });

  // Pass `false` in the layout parameter to generate an image layout
  // suitable for exporting to a PNG sprite image file.
  spritezero.generateLayout({ imgs: svgs, pixelRatio: pxRatio, format: false }, function(err, imageLayout) {
    spritezero.generateImage(imageLayout, function(err, image) {
      if (err) return;
      fs.writeFileSync(pngPath, image);
    });
  });

});
