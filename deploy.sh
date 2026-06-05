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
FULL_REPO="${OWNER}/${REPO_NAME}"

echo ""
echo "✅ 已推送到 https://github.com/${FULL_REPO}"

# 启用 GitHub Pages（main 分支根目录）
if gh api "repos/${FULL_REPO}/pages" >/dev/null 2>&1; then
  gh api "repos/${FULL_REPO}/pages" -X PUT \
    -f "build_type=legacy" \
    -f "source[branch]=main" \
    -f "source[path]=/" >/dev/null
else
  gh api "repos/${FULL_REPO}/pages" -X POST \
    -f "build_type=legacy" \
    -f "source[branch]=main" \
    -f "source[path]=/" >/dev/null
fi

echo "✅ GitHub Pages 已启用"
echo ""
echo "几分钟后访问："
echo "  https://${OWNER}.github.io/${REPO_NAME}/"
