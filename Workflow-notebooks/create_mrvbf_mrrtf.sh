#!/usr/bin/env bash
# Adapted from https://github.com/digitalearthafrica/dem-derivative/blob/main/tiled_dem_processing_saga.sh
# Note Saga v2.3.1 was used
# Also note DEM had a buffer of 2430 meters

INPUT_DEM=$1
OUTPUT_MRVBF=$2
OUTPUT_MRRTF=$3
EPSG=$4

saga_cmd io_gdal 0 -GRIDS "DEM.sgrd" -FILES "$INPUT_DEM" -TRANSFORM 1 -RESAMPLING 0

saga_cmd ta_morphometry 8 -DEM "DEM.sgrd" -MRVBF "MrVBF.sgrd" -MRRTF "MrRTF.sgrd" \
  -T_SLOPE 16 -T_PCTL_V 0.400000 -T_PCTL_R 0.350000 -P_SLOPE 4.000000 -P_PCTL 3.000000 \
  -UPDATE 1 -CLASSIFY 0 -MAX_RES 0.5

# convert to geotiff
saga_cmd io_gdal 1 -GRIDS "MrVBF.sgrd" -FILE "$OUTPUT_MRVBF" -FORMAT 1 -TYPE 3 \
  -SET_NODATA 0 -NODATA 3.000000
saga_cmd io_gdal 1 -GRIDS "MrRTF.sgrd" -FILE "$OUTPUT_MRRTF" -FORMAT 1 -TYPE 3 \
  -SET_NODATA 0 -NODATA 3.000000
# clean up intermediate results
rm -f DEM.* MrVBF.* MrRTF.*

# add projection
gdal_edit.py -a_srs $EPSG $OUTPUT_MRVBF
gdal_edit.py -a_srs $EPSG $OUTPUT_MRRTF
