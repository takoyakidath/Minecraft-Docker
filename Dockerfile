# ベースイメージとしてJavaを使用
FROM eclipse-temurin:17-jre-alpine

# 作業ディレクトリを設定
WORKDIR /minecraft

# 必要なパッケージをインストール
RUN apk add --no-cache curl jq

# PaperMC関連の環境変数を設定
ENV MEMORY_SIZE="2G" \
    PAPERMC_VERSION="1.20.4" \
    PAPERMC_BUILD="latest"

# PaperMCのダウンロードと設定を行うスクリプトを作成
RUN echo '#!/bin/sh' > /minecraft/start.sh && \
    echo 'if [ "$PAPERMC_BUILD" = "latest" ]; then' >> /minecraft/start.sh && \
    echo '  PAPERMC_BUILD=$(curl -s "https://api.papermc.io/v2/projects/paper/versions/${PAPERMC_VERSION}" | jq ".builds[-1]")' >> /minecraft/start.sh && \
    echo 'fi' >> /minecraft/start.sh && \
    echo 'if [ ! -f paper.jar ]; then' >> /minecraft/start.sh && \
    echo '  curl -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${PAPERMC_VERSION}/builds/${PAPERMC_BUILD}/downloads/paper-${PAPERMC_VERSION}-${PAPERMC_BUILD}.jar"' >> /minecraft/start.sh && \
    echo 'fi' >> /minecraft/start.sh && \
    echo 'exec java -Xms${MEMORY_SIZE} -Xmx${MEMORY_SIZE} -jar paper.jar nogui' >> /minecraft/start.sh && \
    chmod +x /minecraft/start.sh

# eula.txtを作成して同意
RUN echo "eula=true" > eula.txt

# 必要なポートを公開
EXPOSE 25565

# 永続化するためのボリュームを設定
VOLUME ["/minecraft/world", "/minecraft/logs", "/minecraft/plugins", "/minecraft/config"]

# サーバー起動
CMD ["/minecraft/start.sh"]
