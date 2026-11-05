#!/data/data/com.termux/files/usr/bin/bash
REPO_DIR="$HOME/mobailefolder"
cd "$REPO_DIR" || exit 1

# ফোল্ডার পরিবর্তন নজরদারি করুন, ফাইল বন্ধ/স্থানান্তর ইভেন্ট শুনুন
inotifywait -m -r -e close_write,moved_to --format '%w%f' "$REPO_DIR" | while read -r FILE; do
    # .git ডিরেক্টরির ভিতরের পরিবর্তন উপেক্ষা করুন
    case "$FILE" in
        */.git/*) continue ;;
    esac

    cd "$REPO_DIR" || exit 1

    # কোনো প্রকৃত পরিবর্তন আছে কিনা পরীক্ষা করুন
    if git diff --quiet && git diff --cached --quiet; then
        continue
    fi

    git add -A
    git commit -m "auto sync $(date '+%Y-%m-%d %H:%M:%S')"
    git push
done
