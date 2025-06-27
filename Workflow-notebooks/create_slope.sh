#!/usr/bin/env bash
# Adapted from https://github.com/digitalearthafrica/dem-derivative/blob/main/tiled_dem_processing_saga.sh

INPUT_DEM=$1
OUTPUT_SLOPE=$2

gdaldem slope "$INPUT_DEM" "$OUTPUT_SLOPE" -p -compute_edges
