if [ -d ~/.functions ]; then
    for file in ~/.functions/*.func; do
        if [[ -f $file ]]; then
            source "$file"
        fi
    done
fi