.DEFAULT_GOAL := help
.PHONY: up down build restart logs ps help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

up: ## 全サービスをバックグラウンドで起動
	docker compose up -d

down: ## 全サービスを停止・削除
	docker compose down

build: ## イメージをビルド
	docker compose build

restart: ## 全サービスを再起動
	docker compose restart

logs: ## 全サービスのログをフォロー
	docker compose logs -f

ps: ## サービスの状態を確認
	docker compose ps
