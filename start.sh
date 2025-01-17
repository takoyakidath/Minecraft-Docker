#!/bin/sh
if [ "$PAPERMC_BUILD" = "latest" ]; then
  PAPERMC_BUILD=$(curl -s "https://api.papermc.io/v2/projects/paper/versions/${PAPERMC_VERSION}" | jq ".builds[-1]")
fi
if [ ! -f paper.jar ]; then
  curl -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${PAPERMC_VERSION}/builds/${PAPERMC_BUILD}/downloads/paper-${PAPERMC_VERSION}-${PAPERMC_BUILD}.jar"
fi
exec java -Xms${MEMORY_SIZE} -Xmx${MEMORY_SIZE} -jar paper.jar nogui
