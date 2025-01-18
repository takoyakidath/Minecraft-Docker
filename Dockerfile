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
RUN curl https://gist.githubusercontent.com/takoyakidath/13c89e54ca4244ed3decd1b2f42fec1f/raw/dddf4c8c038632dd6e619474be97e89d00a8753e/start.sh >  /minecraft/start.sh
RUN chmod +x start.sh
# world download 
RUN apk add --no-cache unzip && \
    curl -L https://github.com/takoyakidath/Minecraft-Docker/raw/refs/heads/main/world.zip -o world.zip && \
    unzip world.zip

# eula.txtを作成して同意
RUN echo "eula=true" > eula.txt

# 必要なポートを公開
EXPOSE 25565

# 永続化するためのボリュームを設定
VOLUME ["/minecraft/world", "/minecraft/logs", "/minecraft/plugins", "/minecraft/config"]

# サーバー起動
CMD ["/minecraft/start.sh"]
