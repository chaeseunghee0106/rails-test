# syntax = docker/dockerfile:1

# ベースイメージ
FROM ruby:3.1.6-slim as base

# Railsアプリのディレクトリを設定
WORKDIR /rails

# 環境変数の設定
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips postgresql-client nodejs

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# bundle installの実行
RUN bundle install

# アプリケーションのコードをコピー
COPY . .

# 開発環境ではファイルの変更を即座に反映させるため、ホストディレクトリをボリュームとしてマウント
VOLUME ["/rails"]

# サーバーの起動
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
