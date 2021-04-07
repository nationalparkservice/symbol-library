# NPMap Symbol Library

National Park Service [map symbols](https://www.nps.gov/carto/app/#!/maps/symbols) optimized for the web.


## New symbols

Development on new symbol artwork is ongoing, we have a completely revised procedure in place start April 2021.

## Versioning

The Symbol Library uses a semantic versioning scheme:

* 0.0.z: Bugfixes and modifications
* 0.y.0: Icons added
* x.0.0: Icons removed, sprite scheme changed, or major features added

## Changelog

* 1.0.0
* 2.0.0
* 2.1.0
* 2.2.2
* 2.2.3
* 2.3.0
* 2.4.0
* 2.5.0
* 3.0.0

## File structure


### src

Source [SVG](http://en.wikipedia.org/wiki/Scalable_Vector_Graphics) files are in the `src` subdirectory. Each symbol is designed at three pixel-perfect sizes (max dimensions 14, 22, and 30 pixels square) and in black and white versions to support different use cases. These can be found in the `src/standalone` directory. In addition, a subset of symbols are designed at 14 and 22 pixels with a shield for use in [npmap.js](https://www.nps.gov/maps/tools/npmap.js/) these are in the `src/shielded/` directory.

### renders

Sprite renders of all of the SVGs are in the `renders` directory. High-resolution (aka Retina) versions of each icon are present as well, named using the common `@2x` and `@4x` conventions.

### index.js

You can use the SVGs and PNGs in this repository as they are without building anything, however a render script is included to assist designers/developers who want to modify or create new icons. It will render SVGs to sprites at 100%, 200%, and 400% resolution that can be used by [NPMap.js](https://www.nps.gov/maps/tools/npmap.js/).

The script depends on [@mapbox/spritezero](https://github.com/mapbox/spritezero), which itself depends on nodejs v10.0.0 or greater.

After installing the required prerequisites, you can run the script like this:

    git clone https://github.com/nationalparkservice/symbol-library.git
    cd symbol-library
    npm install
    node index.js
