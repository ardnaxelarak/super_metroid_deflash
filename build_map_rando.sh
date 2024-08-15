py=py
asar=asar
flips=flips

set -e

if test -f maprando_working.sfc; then
  rm maprando_working.sfc
fi
cp maprando.sfc maprando_working.sfc
$asar glow_mosaic.asm maprando_working.sfc > patch.yml

if test -f maprando_working_2.sfc; then
  rm maprando_working_2.sfc
fi
cp maprando_working.sfc maprando_working_2.sfc
$asar common_flashing_placebo.asm maprando_working_2.sfc
$flips --create --ips maprando_working.sfc maprando_working_2.sfc common_flashing_placebo.ips

if test -f maprando_working_3.sfc; then
  rm maprando_working_3.sfc
fi
cp maprando_working_2.sfc maprando_working_3.sfc
$asar common_reduced_flashing.asm maprando_working_3.sfc
$flips --create --ips maprando_working_2.sfc maprando_working_3.sfc common_reduced_flashing.ips

$py build_glowpatch_json.py -i patch.yml -p common_reduced_flashing.ips -o reduced_flashing.json
