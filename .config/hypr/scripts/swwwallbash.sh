#!/usr/bin/env sh

# set variables

export ScrDir=`dirname "$(realpath "$0")"`
source $ScrDir/globalcontrol.sh
dcoDir="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/wallbash"
input_wall="$1"
export cacheImg=$(basename "${input_wall}")

if [ -z "${input_wall}" ] || [ ! -f "${input_wall}" ] ; then
    echo "Error: Input wallpaper not found!"
    exit 1
fi

# color conversion functions (unchanged)

hex_conv() {
    rgb_val=$(echo "$1" | sed 's/[-srgb()%]//g ; s/,/ /g')
    red=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $1}')
    green=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $2}')
    blue=$(echo "$rgb_val * 255 / 100" | awk '{printf "%d", $3}')
    printf "%02X%02X%02X\n" "$red" "$green" "$blue"
}

rgb_negative() {
    local rgb_val=$1
    red=${rgb_val:0:2}
    green=${rgb_val:2:2}
    blue=${rgb_val:4:2}
    red_dec=$((16#$red))
    green_dec=$((16#$green))
    blue_dec=$((16#$blue))
    negative_red=$(printf "%02X" $((255 - $red_dec)))
    negative_green=$(printf "%02X" $((255 - $green_dec)))
    negative_blue=$(printf "%02X" $((255 - $blue_dec)))
    echo "${negative_red}${negative_green}${negative_blue}"
}

dark_light() {
    inCol="$1"
    red=$(printf "%d" "0x${inCol:1:2}")
    green=$(printf "%d" "0x${inCol:3:2}")
    blue=$(printf "%d" "0x${inCol:5:2}")
    brightness=$((red + green + blue))
    [ "$brightness" -lt 250 ]
}

# extract 3 primary colors from matugen JSON and generate accent variables

if [ ! -f "${cacheDir}/${gtkTheme}/${cacheImg}.dcol" ] ; then
    mkdir -p "${cacheDir}/${gtkTheme}"
    palette_json="${HOME}/.config/matugen/templates/colors.json"

    # keys to extract in order
    keys="primary secondary tertiary"
    j=0

    for key in $keys; do
        base=$(jq -r --arg k "$key" '.colors.dark[$k]' "$palette_json" | tr -d '#')
        cont=$(jq -r --arg k "${key}_container" '.colors.dark[$k]' "$palette_json" | tr -d '#')
        fixed=$(jq -r --arg k "${key}_fixed" '.colors.dark[$k]' "$palette_json" | tr -d '#')
        fixed_dim=$(jq -r --arg k "${key}_fixed_dim" '.colors.dark[$k]' "$palette_json" | tr -d '#')
        on_base=$(jq -r --arg k "on_${key}" '.colors.dark[$k]' "$palette_json" | tr -d '#')
        on_cont=$(jq -r --arg k "on_${key}_container" '.colors.dark[$k]' "$palette_json" | tr -d '#')

        echo "dcol_pry${j}=\"${base}\""      >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        echo "dcol_txt${j}=\"${on_base}\""    >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        echo "dcol_cont${j}=\"${cont}\""      >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        echo "dcol_oncont${j}=\"${on_cont}\"" >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        echo "dcol_fixed${j}=\"${fixed}\""    >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
        echo "dcol_fd${j}=\"${fixed_dim}\""   >> "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"

        j=$((j+1))
    done

    cat "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"
fi

# wallbash fn to apply colors to templates

fn_wallbash () {
    local tplt="${1}"
    eval target=$(head -1 "${tplt}" | awk -F '|' '{print $1}')
    eval appexe=$(head -1 "${tplt}" | awk -F '|' '{print $2}')
    source "${ScrDir}/globalcontrol.sh"
    source "${cacheDir}/${gtkTheme}/${cacheImg}.dcol"

    sed '1d' "${tplt}" > "${target}"
    sed -i "s/<wallbash_pry0>/${dcol_pry0}/g
            s/<wallbash_txt0>/${dcol_txt0}/g
            s/<wallbash_0xa1>/${dcol_cont0}/g
            s/<wallbash_0xa2>/${dcol_oncont0}/g
            s/<wallbash_0xa3>/${dcol_fixed0}/g
            s/<wallbash_0xa4>/${dcol_fd0}/g
            s/<wallbash_pry1>/${dcol_pry1}/g
            s/<wallbash_txt1>/${dcol_txt1}/g
            s/<wallbash_1xa1>/${dcol_cont1}/g
            s/<wallbash_1xa2>/${dcol_oncont1}/g
            s/<wallbash_1xa3>/${dcol_fixed1}/g
            s/<wallbash_1xa4>/${dcol_fd1}/g
            s/<wallbash_pry2>/${dcol_pry2}/g
            s/<wallbash_txt2>/${dcol_txt2}/g
            s/<wallbash_2xa1>/${dcol_cont2}/g
            s/<wallbash_2xa2>/${dcol_oncont2}/g
            s/<wallbash_2xa3>/${dcol_fixed2}/g
            s/<wallbash_2xa4>/${dcol_fd2}/g" "${target}"

    if [ ! -z "${appexe}" ] ; then
        "${appexe}"
    fi
}

export -f fn_wallbash

# exec wallbash fn in parallel

find "$dcoDir" -type f -name "*.dcol" | parallel -j 0 fn_wallbash
