py=py
asar=asar

rm maprando_working.sfc
cp maprando.sfc maprando_working.sfc
$asar glow_mosaic.asm maprando.sfc > patch.yml
$py build_glowpatch.py -i patch.yml -o patch.glowpatch
