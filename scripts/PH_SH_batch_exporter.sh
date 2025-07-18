#!/bin/bash
## @license AGPLv3 <https://www.gnu.org/licenses/agpl-3.0.html>
## @author Copyright (C) 2015 Robin Schneider <ypid@riseup.net>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as
## published by the Free Software Foundation, version 3 of the
## License.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Script for generating PH/SH files for https://github.com/anschuetz/linuxmuster

script_url="https://github.com/opening-hours/opening_hours.js/blob/main/PH_SH_batch_exporter.sh"

print_header()
{
    echo "# This file was generated by the script ${script_url}."
    echo "# Do not edit this file manually ;-)"
    echo "#"
    echo "# Diese Datei wurde durch das Skript ${script_url} erzeugt."
    echo "# Nicht von Hand editieren ;-)"
}
gen_sh() {
    local state="${1}"
    local from="${2}"
    local to="${3}"

    local filepath="ferien_${state}.conf"
    echo "Generating $filepath …"
    ./PH_SH_exporter.js /tmp/PH_SH_export.list --from "$from" --to "$to" --school-holidays --state "$state" --omit-date-hyphens
    (
        print_header
        cat /tmp/PH_SH_export.list
    ) > "$filepath"
}

for state in by be bb hb hh he mv ni nw rp sn
do
    gen_sh "$state" "2017" "2023"
done

# Only defined until 2019, lazy …
for state in bw st
do
    gen_sh "$state" "2017" "2019"
done

for state in bw by be bb hb hh he mv ni nw rp sn st sl sh th
do
    filepath="feiertage_${state}.conf"
    echo "Generating $filepath …"
    ./PH_SH_exporter.js /tmp/PH_SH_export.list --from "2017" --to 2042 --public-holidays --state $state --omit-date-hyphens
    (
        print_header
        cat /tmp/PH_SH_export.list
    ) > $filepath
done
