# NPMap Symbol Library

[![Circle CI](https://circleci.com/gh/nationalparkservice/npmap-symbol-library.svg?style=svg)](https://circleci.com/gh/nationalparkservice/npmap-symbol-library)

National Park Service [map symbols](http://www.nps.gov/hfc/carto/map-symbols.cfm) optimized for the web. Read more about this project on the [NPS maps website](http://www.nps.gov/maps/tools/symbol-library/).

## New symbols

Add requests for new symbols as an [issue](https://github.com/nationalparkservice/npmap-symbol-library/issues/new). Newly developed symbols will be bundled into periodic releases. A more detailed release checklist can be found [here](https://github.com/nationalparkservice/npmap-symbol-library/wiki/Symbol-Library-release-checklist).

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


## File structure

This repository was originally forked from Mapbox's [Maki](https://github.com/mapbox/maki) project, so the file structure is similar.

### src

Source [SVG](http://en.wikipedia.org/wiki/Scalable_Vector_Graphics) files are in the `src` subdirectory. To create pixel-perfect icons at different sizes, each icon is designed 6 times to support two different use cases:

1. At 12, 18, and 24 pixels wide/tall for use in [NPMap Builder](https://github.com/nationalparkservice/npmap-builder/) (found in `/builder` directory)
2. At 14, 22, and 30 pixels wide/tall for use in [Park Tiles](https://github.com/nationalparkservice/park-tiles/) and Park Mobile apps (found in `/standalone` directory)

### renders

PNG renders of all of the SVGs are in the `renders` directory. High-resolution (aka Retina) versions of each icon are present as well, named using the common `@2x` convention.

### render.sh

You can use the SVGs and PNGs in this repository as they are without building anything, however a render script is included to assist designers/developers who want to modify or create new icons. It will render SVGs to PNGs at 100% and 200% resolution, create sprites used by [NPMap.js](https://github.com/nationalparkservice/npmap.js), [NPMap Builder](https://github.com/nationalparkservice/npmap-builder), and the [Places Editor](https://github.com/nationalparkservice/places-editor), and generate corresponding CSS styles for the sprites.

The script requires Node, [Bash](http://www.gnu.org/software/bash/bash.html), [Inkscape](http://inkscape.org), and [ImageMagick](http://www.imagemagick.org/). In addition, each icon must have an appropriate entry in `www/npmap-symbol-library.json` to be rendered correctly.

After installing the required prerequisites, you can run the script like this:

    cd npmap-symbol-library
    npm install
    bash render.sh
