# NPMap Symbol Library

[![Circle CI](https://circleci.com/gh/nationalparkservice/npmap-symbol-library.svg?style=svg)](https://circleci.com/gh/nationalparkservice/npmap-symbol-library)

National Park Service [map symbols](https://www.nps.gov/carto/app/#!/maps/symbols) optimized for the web. View the complete set and read more about this project and on the [NPS maps website](https://www.nps.gov/carto/app/#!/parks).

## New symbols

Add requests for new symbols as an [issue](https://github.com/nationalparkservice/npmap-symbol-library/issues/new). Starting in 2018, newly developed symbols will be added to the `src/standalone` directory and bundled into periodic releases. Symbol development for NPMap Builder will be temporarily suspended until that application is rewritten to pull symbols from the `standalone` directory. A more detailed release checklist can be found [here](https://github.com/nationalparkservice/npmap-symbol-library/wiki/Symbol-Library-release-checklist).

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


## File structure

This repository was originally forked from Mapbox's [Maki](https://github.com/mapbox/maki) project, so the file structure is similar.

### src

Source [SVG](http://en.wikipedia.org/wiki/Scalable_Vector_Graphics) files are in the `src` subdirectory. Each symbol is designed at three pixel-perfect sizes (max dimensions 14, 22, and 30 pixels square) and in black and white versions to support different use cases. These can be found in the `src/standalone` directory. In addition, a subset of 94 symbols are designed at 12, 18, and 24 pixels square for use in NPMap Builder.

### renders

PNG renders of all of the SVGs are in the `renders` directory. High-resolution (aka Retina) versions of each icon are present as well, named using the common `@2x` convention.

### render.sh

You can use the SVGs and PNGs in this repository as they are without building anything, however a render script is included to assist designers/developers who want to modify or create new icons. It will render SVGs to PNGs at 100% and 200% resolution, create sprites used by [NPMap.js](https://github.com/nationalparkservice/npmap.js), [NPMap Builder](https://github.com/nationalparkservice/npmap-builder), and the [Places Editor](https://github.com/nationalparkservice/places-editor), and generate corresponding CSS styles for the sprites.

The script requires Node, [Bash](http://www.gnu.org/software/bash/bash.html), [Inkscape](http://inkscape.org), and [ImageMagick](http://www.imagemagick.org/). In addition, each icon must have an appropriate entry in `www/npmap-symbol-library.json` to be rendered correctly.

After installing the required prerequisites, you can run the script like this:

    cd npmap-symbol-library
    npm install
    bash render.sh
