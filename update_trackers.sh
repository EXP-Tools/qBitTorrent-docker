#!/bin/sh

DOCKER_ID=`docker ps -aq --filter name=docker_torrent`
if [ ! -z "${DOCKER_ID}" ]; then
    CFG_PATH="/config/qBittorrent/qBittorrent.conf"
    BITTORRENT_KEY="Bittorrent\\"
    TRACKERS_KEY="TrackersList="
    TRACKERS_VAL=`curl -k https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt | xargs echo | awk '{gsub(/ /,"\\\\n");print}'`

    if [ -z "${TRACKERS_VAL}" ]; then
        echo "undo"

    else
        MATCH=`docker exec -u root ${DOCKER_ID} /bin/bash -c "grep '${TRACKERS_KEY}' ${CFG_PATH}"`
        if [[ "${MATCH}" =~ ${TRACKERS_KEY}.*$ ]] ; then
            echo "Del Old Trackers ..."
            docker exec -u root ${DOCKER_ID} /bin/bash -c "sed -i \"/${TRACKERS_KEY}.*/d\" ${CFG_PATH}"
        fi

        echo "Add New Trackers ..."
        docker exec -u root ${DOCKER_ID} /bin/bash -c "echo \"${BITTORRENT_KEY}${TRACKERS_KEY}${TRACKERS_VAL}\" >> ${CFG_PATH}"

        echo "Restart qBitTorrent ..."
        docker stop ${DOCKER_ID}
        docker start ${DOCKER_ID}
        echo "done"
    fi
fi
