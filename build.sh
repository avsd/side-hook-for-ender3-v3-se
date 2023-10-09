#!/usr/bin/env bash

openscad-nightly ender3-hook.scad -D isMirrored=1 -o ender3-hook-left.stl
openscad-nightly ender3-hook.scad -D isMirrored=0 -o ender3-hook-right.stl
