py=py
asar=asar

rm sm_practice_working.sfc
cp sm_practice.sfc sm_practice_working.sfc
$asar common_reduced_flashing.asm sm_practice_working.sfc
