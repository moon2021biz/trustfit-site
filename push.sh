#!/bin/bash
# ============================================================
# TrustFit — GitHub push + Cloudflare Pages 直接デプロイ
# 使い方: bash push.sh "更新内容のメモ"
# 例:     bash push.sh "index.html を更新"
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

MESSAGE="${1:-update: $(date '+%Y-%m-%d %H:%M')}"

echo ""
echo "📁 対象フォルダ: $REPO_DIR"
echo "📝 コミットメッセージ: $MESSAGE"
echo ""

# ===== STEP 1: GitHub push =====
CHANGED=$(git status --porcelain)
if [ -z "$CHANGED" ]; then
  echo "ℹ️  git変更なし — GitHub pushをスキップ"
else
  echo "📋 変更ファイル:"
  git status --short
  git add .
  git commit -m "$MESSAGE"
  git push origin main
  echo "✅ GitHub push 完了"
fi

echo ""

# ===== STEP 2: Cloudflare Pages 直接デプロイ =====
echo "☁️  Cloudflare Pages にデプロイ中..."
npx wrangler pages deploy . --project-name trustfit-site --commit-dirty=true

echo ""
echo "🎉 完了！サイトが更新されました"
echo "🌐 URL: https://trustfit-site.pages.dev"
echo ""
