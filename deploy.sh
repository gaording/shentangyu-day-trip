#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${1:-shentangyu-day-trip}"
VISIBILITY="${2:-public}"

cd "$(dirname "$0")"

if ! gh auth status >/dev/null 2>&1; then
  echo "请先登录 GitHub：gh auth login"
  exit 1
fi

if [ ! -d .git ]; then
  git init -b main
  git add index.html README.md .nojekyll
  git commit -m "feat: add Shen Tangyu day trip itinerary page"
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
else
  git push -u origin main
fi

OWNER="$(gh api user -q .login)"
echo ""
echo "✅ 已推送到 https://github.com/${OWNER}/${REPO_NAME}"
echo ""
echo "接下来在浏览器打开并启用 Pages："
echo "  gh repo edit ${OWNER}/${REPO_NAME} --enable-pages --pages-branch main --pages-path /"
echo ""
echo "几分钟后访问："
echo "  https://${OWNER}.github.io/${REPO_NAME}/"
