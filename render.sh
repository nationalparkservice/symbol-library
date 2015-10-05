#!/bin/bash
set -e -u

# Usage:
#   ./render.sh [png|sprite|css]

# Config
pngdirbuilder=`pwd`"/renders/npmap-builder"  # PNGs will be created, possibly overwritten, here
pngdirstandalone=`pwd`"/renders/standalone"  # PNGs will be created, possibly overwritten, here
svgdirbuilder=`pwd`"/src/npmap-builder"  # SVGs should already be here
svgdirstandalone=`pwd`"/src/standalone"  # SVGs should already be here
tilex=15  # how many icons wide the sprites will be

function build_pngs_builder {
    # Takes a list of SVG files and renders both 1x and 2x scale PNGs
    for svg in $@; do

        icon=$(basename $svg .svg)

        inkscape \
            --export-dpi=90 \
            --export-png=${pngdirbuilder}/${icon}.png \
            $svg > /dev/null

        inkscape \
            --export-dpi=180 \
            --export-png=${pngdirbuilder}/${icon}@2x.png \
            $svg > /dev/null
    done
}

function build_pngs_standalone {
    # Takes a list of SVG files and renders both 1x and 2x scale PNGs
    for svg in $@; do

        icon=$(basename $svg .svg)

        inkscape \
            --export-dpi=90 \
            --export-png=${pngdirstandalone}/${icon}.png \
            $svg > /dev/null

        inkscape \
            --export-dpi=180 \
            --export-png=${pngdirstandalone}/${icon}@2x.png \
            $svg > /dev/null
    done
}

function build_sprite {
    # Takes a list of PNG files and creates a sprite file

    # The `montage` results are weird if the number of images passed in
    # do not grid perfectly, so we calculate the correct number of null
    # images to add into the command.

    outfile=$1
    shift   # the rest of the arguments should be filenames

    count=$(echo $@ | tr ' ' '\n' | wc -l)
    remainder=$(($count % $tilex))
    rnull=$(for ((i=1; i<=$remainder; i++)); do echo -n 'null: '; done)

    montage \
        -type TrueColorMatte \
        -background transparent \
        -geometry +0+0 \
        -tile ${tilex}x \
        -gravity Northwest \
        $@ $rnull \
        $outfile
}

function build_css_builder {
    # Takes a list of icon names, calculates the correct CSS background-
    # positions for 24px icons, and creates an appropriate CSS file.
    # Assumes that the icon list matches what was passed to the last run
    # of the build_pngs function.

    count=0
    dx=0
    dy=0
    maxwidth=$((54*$tilex/3-1))

    cat www/npmap-symbol-library-sprite.css.tpl > www/npmap-builder/npmap-symbol-library-sprite.css

    for icon in $@; do
        count=$(($count + 1))

        echo ".npmap-symbol-library-icon.$icon { background-position: ${dx}px ${dy}px; }" \
            >> www/npmap-builder/npmap-symbol-library-sprite.css

        # Check if we need to add a new row yet,
        # and if so, adjust dy and dy accordingly.
        # Otherwise just adjust dx.
        if [ $(($count * 3 % $tilex)) -eq 0 ]; then
            dy=$(($dy - 24))
            dx=0
        else
            dx=$(($dx - 54))
        fi
    done

    # Update sprite dimensions for retina rules.
    dim="$(identify -format "%wpx %hpx" www/npmap-builder/images/npmap-symbol-library-sprite.png)"
    cat www/npmap-builder/npmap-symbol-library-sprite.css | sed "s/background-size: [0-9]*px [0-9]*px;/background-size: $dim;/" > www/npmap-builder/npmap-symbol-library-sprite.css.tmp
    mv www/npmap-builder/npmap-symbol-library-sprite.css.tmp www/npmap-builder/npmap-symbol-library-sprite.css
}

function build_css_standalone {
    count=0
    dx=0
    dy=0
    maxwidth=$((54*$tilex/3-1))

    cat www/npmap-symbol-library-sprite.css.tpl > www/standalone/npmap-symbol-library-sprite.css

    for icon in $@; do
        count=$(($count + 1))

        echo ".npmap-symbol-library-icon.$icon { background-position: ${dx}px ${dy}px; }" \
            >> www/standalone/npmap-symbol-library-sprite.css

        # Check if we need to add a new row yet,
        # and if so, adjust dy and dy accordingly.
        # Otherwise just adjust dx.
        if [ $(($count * 3 % $tilex)) -eq 0 ]; then
            dy=$(($dy - 24))
            dx=0
        else
            dx=$(($dx - 54))
        fi
    done

    # Update sprite dimensions for retina rules.
    dim="$(identify -format "%wpx %hpx" www/standalone/images/npmap-symbol-library-sprite.png)"
    cat www/standalone/npmap-symbol-library-sprite.css | sed "s/background-size: [0-9]*px [0-9]*px;/background-size: $dim;/" > www/standalone/npmap-symbol-library-sprite.css.tmp
    mv www/standalone/npmap-symbol-library-sprite.css.tmp www/standalone/npmap-symbol-library-sprite.css
}

function build_positions_builder {
    # Takes a list of icon names, calculates the positions, outputs json

    count=0
    dx=0
    dy=0
    maxwidth=$((54*$tilex/3-1))

    file="www/npmap-builder/npmap-symbol-library-sprite.json"

    echo "{" > $file;

    for icon in $@; do

        if [ $count -ne 0 ]; then  ## avoid trailing comma
            echo "," >> $file
        fi

        count=$(($count + 1))

        echo "\"$icon-24\": { \"x\": $((-1 * dx)), \"y\": $((-1 * $dy)), \"width\": 24, \"height\": 24 }," >> $file
        echo "\"$icon-18\": { \"x\": $((-1 * dx + 24)), \"y\": $((-1 * $dy)), \"width\": 18, \"height\": 18 }," >> $file
        echo -n "\"$icon-12\": { \"x\": $((-1 * dx + 42)), \"y\": $((-1 * $dy)), \"width\": 12, \"height\": 12 }" >> $file

        # Check if we need to add a new row yet,
        # and if so, adjust dy and dy accordingly.
        # Otherwise just adjust dx.
        if [ $(($count * 3 % $tilex)) -eq 0 ]; then
            dy=$(($dy - 24))
            dx=0
        else
            dx=$(($dx - 54))
        fi
    done

    echo "}" >> $file
}

function build_positions_standalone {
    count=0
    dx=0
    dy=0
    maxwidth=$((72*$tilex/3-1))

    file="www/standalone/npmap-symbol-library-sprite.json"

    echo "{" > $file;

    for icon in $@; do

        if [ $count -ne 0 ]; then  ## avoid trailing comma
            echo "," >> $file
        fi

        count=$(($count + 1))

        echo "\"$icon-32\": { \"x\": $((-1 * dx)), \"y\": $((-1 * $dy)), \"width\": 32, \"height\": 32 }," >> $file
        echo "\"$icon-24\": { \"x\": $((-1 * dx + 32)), \"y\": $((-1 * $dy)), \"width\": 24, \"height\": 24 }," >> $file
        echo -n "\"$icon-16\": { \"x\": $((-1 * dx + 56)), \"y\": $((-1 * $dy)), \"width\": 16, \"height\": 16 }" >> $file

        # Check if we need to add a new row yet,
        # and if so, adjust dy and dy accordingly.
        # Otherwise just adjust dx.
        if [ $(($count * 3 % $tilex)) -eq 0 ]; then
            dy=$(($dy - 32))
            dx=0
        else
            dx=$(($dx - 72))
        fi
    done

    echo "}" >> $file
}

# Get a lcst of all the icon names - any icons not in npmap-symbol-library.json
# will not be rendered or included in the sprites.
iconsbuilder=$(grep '"icon":' www/npmap-builder/npmap-symbol-library.json \
    | sed 's/.*\:\ "\([-a-z0-9]*\)".*/\1/' \
    | tr '\n' ' ')
iconsstandalone=$(grep '"icon":' www/standalone/npmap-symbol-library.json \
    | sed 's/.*\:\ "\([-a-z0-9]*\)".*/\1/' \
    | tr '\n' ' ')

# Build lists of all the SVG and PNG files from the icons list
svgsbuilder=$(for icon in $iconsbuilder; do echo -n $svgdirbuilder/${icon}-{24,18,12}.svg" "; done)
pngsbuilder=$(for icon in $iconsbuilder; do echo -n $pngdirbuilder/${icon}-{24,18,12}.png" "; done)
pngs2xbuilder=$(for icon in $iconsbuilder; do echo -n $pngdirbuilder/${icon}-{24,18,12}@2x.png" "; done)
svgsstandalone=$(for icon in $iconsstandalone; do echo -n $svgdirstandalone/${icon}-{32,24,16}.svg" "; done)
pngsstandalone=$(for icon in $iconsstandalone; do echo -n $pngdirstandalone/${icon}-{32,24,16}.png" "; done)
pngs2xstandalone=$(for icon in $iconsstandalone; do echo -n $pngdirstandalone/${icon}-{32,24,16}@2x.png" "; done)

case $@ in
    png | pngs )
        build_pngs $svgsbuilder
        build_pngs $svgsstandalone
        ;;
    sprite | sprites )
        build_sprite "www/npmap-builder/images/npmap-symbol-library-sprite.png" $pngsbuilder
        build_sprite "www/npmap-builder/images/npmap-symbol-library-sprite@2x.png" $pngs2xbuilder
        build_sprite "www/standalone/images/npmap-symbol-library-sprite.png" $pngsstandalone
        build_sprite "www/standalone/images/npmap-symbol-library-sprite@2x.png" $pngs2xstandalone
        ;;
    css )
        build_css_builder $iconsbuilder
        build_css_standalone $iconsstandalone
        ;;
    positions )
        build_positions_builder $iconsbuilder
        build_positions_standalone $iconsstandalone
        ;;
    debug )
        # Prints out all of the icon and file lists for debugging
        echo -e "\nIcons (NPMap Builder):"
        echo $iconsbuilder
        echo -e "\nIcons (Standalone):"
        echo $iconsstandalone
        echo -e "\nSVGs (NPMap Builder):"
        echo $svgsbuilder
        echo -e "\nSVGs (Standalone):"
        echo $svgsstandalone
        echo -e "\nPNGs (NPMap Builder):"
        echo $pngsbuilder
        echo -e "\nPNGs (Standalone):"
        echo $pngsstandalone
        echo -e "\nPNGs @2x (NPMap Builder):"
        echo $pngs2xbuilder
        echo -e "\nPNGs @2x (Standalone):"
        echo $pngs2xstandalone
        ;;
    * )
        # By default we build the PNGs, sprites, CSS, and position JSON
        build_pngs_builder $svgsbuilder
        build_sprite "www/npmap-builder/images/npmap-symbol-library-sprite.png" $pngsbuilder
        build_sprite "www/npmap-builder/images/npmap-symbol-library-sprite@2x.png" $pngs2xbuilder
        build_css_builder $iconsbuilder
        build_positions_builder $iconsbuilder
        build_pngs_standalone $svgsstandalone
        build_sprite "www/standalone/images/npmap-symbol-library-sprite.png" $pngsstandalone
        build_sprite "www/standalone/images/npmap-symbol-library-sprite@2x.png" $pngs2xstandalone
        build_css_standalone $iconsstandalone
        build_positions_standalone $iconsstandalone
        ;;
esac
