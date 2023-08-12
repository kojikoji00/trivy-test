# 使用するベースイメージを指定
FROM golang:1.17 AS builder

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係のファイルをコピー
COPY go.mod go.sum ./

# 依存関係をダウンロード
RUN go mod download

# ソースコードをコピー
COPY . .

# Goアプリケーションをビルド
RUN go build -o myapp .

# 実行ステージ
FROM debian:stretch

# 脆弱性を持つopensslの古いバージョンをインストール
RUN apt-get update && apt-get install -y curl=7.52.1-5

# ビルドしたバイナリをコピー
COPY --from=builder /app/myapp /myapp

# アプリケーションを実行
CMD ["/myapp"]

