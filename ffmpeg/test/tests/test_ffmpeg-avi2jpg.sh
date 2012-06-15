#! /bin/bash

function log {

if [ "${VERBOSE}" ]; then
echo $1
fi

}

export INPUT_AVI_FILE=${TEST_BASE_DIR}/data/video.avi

log "- [START] test for ffmpeg-avi2jpg"

${SCRIPT_LOCATION_DIR}/ffmpeg-avi2jpg.sh

log "- [STOP] test for ffmpeg-avi2jpg"

if [ $(ls ${VISHNU_OUTPUT_DIR} | wc -l) -eq "10" ]; then 
echo "ffmpeg-avi2jpg [OK]"
else
echo "ffmpeg-avi2jpg [NOK]"
fi
