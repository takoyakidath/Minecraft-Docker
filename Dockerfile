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
RUN curl https://raw.githubusercontent.com/takoyakidath/Minecraft-Docker/refs/heads/main/start.sh?token=GHSAT0AAAAAAC5H6JGBCYNSJGZL3XJMYCHWZ4KKR7A > /minecraft/start.sh

# eula.txtを作成して同意
RUN echo "eula=true" > eula.txt

# 必要なポートを公開
EXPOSE 25565

# 永続化するためのボリュームを設定
VOLUME ["/minecraft/world", "/minecraft/logs", "/minecraft/plugins", "/minecraft/config"]

# サーバー起動
CMD ["/minecraft/start.sh"]
