# Justfile for rendering OpenSCAD (.scad) files to STL
# Usage:
#   just render mymodel.scad          # Renders mymodel.scad -> mymodel.stl
#   just render all                   # Renders all .scad files in the current directory
#   just render mymodel.scad out.stl  # Custom output filename

# Default recipe: list available commands
default:
    @just --list

# Render a single .scad file to .stl (default output: same basename)
render scad_file out_stl="":
    #!/usr/bin/env bash
    input="{{scad_file}}"
    if [[ ! -f "$input" ]]; then
        echo "Error: File '$input' not found!"
        exit 1
    fi

    if [[ -z "{{out_stl}}" ]]; then
        output="${input%.scad}.stl"
    else
        output="{{out_stl}}"
    fi

    echo "Rendering $input → $output ..."
    openscad -o "$output" "$input"

# Render all .scad files in the current directory
all:
    #!/usr/bin/env bash
    shopt -s nullglob
    for scad in *.scad; do
        just render "$scad"
    done
    echo "All done!"

# Clean generated .stl files
clean:
    rm -f *.stl
    echo "Cleaned .stl files"

